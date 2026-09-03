#!/usr/bin/env python3
"""
DF Application Suite - Database Export Tool
Exports all databases, ChromaDB vector stores, uploads, and user records
into a single portable ZIP archive for easy USB transfer between development
laptops and deployment PCs.
"""
import os
import sys
import zipfile
import hashlib
from datetime import datetime
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DB_DIR = BASE_DIR / "Database"

def get_sha256(file_path: Path) -> str:
    h = hashlib.sha256()
    with open(file_path, "rb") as f:
        while chunk := f.read(65536):
            h.update(chunk)
    return h.hexdigest()

def export_database(target_dir: str = None):
    if not DB_DIR.exists():
        print(f"❌ Error: Database directory not found at {DB_DIR}")
        sys.exit(1)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    zip_filename = f"DF_Database_{timestamp}.zip"
    
    if target_dir:
        out_folder = Path(target_dir).resolve()
        os.makedirs(out_folder, exist_ok=True)
        out_path = out_folder / zip_filename
    else:
        # Default: Save to root and Database/backups/
        backup_folder = DB_DIR / "backups"
        os.makedirs(backup_folder, exist_ok=True)
        out_path = DB_DIR / "backups" / zip_filename

    print("=" * 65)
    print(" 📦 DF APPLICATION SUITE - DATABASE EXPORT TOOL")
    print("=" * 65)
    print(f" Source:       {DB_DIR}")
    print(f" Destination:  {out_path}")
    print("-" * 65)
    print(" Compressing operational data...")

    file_count = 0
    total_uncompressed_bytes = 0

    with zipfile.ZipFile(out_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        for root, dirs, files in os.walk(DB_DIR):
            # Skip the backups folder itself
            if "backups" in Path(root).parts:
                continue
            for file in files:
                full_path = Path(root) / file
                rel_path = full_path.relative_to(DB_DIR)
                zf.write(full_path, arcname=str(rel_path))
                file_count += 1
                total_uncompressed_bytes += full_path.stat().st_size
                print(f"   [+] {rel_path}")

    # Also create a copy in the root folder for easy grab
    if not target_dir:
        root_copy = BASE_DIR / zip_filename
        import shutil
        shutil.copy2(out_path, root_copy)

    compressed_size_mb = out_path.stat().st_size / (1024 * 1024)
    uncompressed_size_mb = total_uncompressed_bytes / (1024 * 1024)
    checksum = get_sha256(out_path)

    print("-" * 65)
    print(f" ✅ Export Complete!")
    print(f" 📁 Files Archived:   {file_count} files")
    print(f" 📊 Uncompressed:     {uncompressed_size_mb:.2f} MB")
    print(f" 🗜️  Archive Size:     {compressed_size_mb:.2f} MB")
    print(f" 🔒 SHA-256 Checksum: {checksum[:16]}...{checksum[-8:]}")
    print(f" 💾 Archive Location: {out_path}")
    if not target_dir:
        print(f" 📍 Monorepo Copy:    {BASE_DIR / zip_filename}")
    print("=" * 65)
    print(" 💡 Ready to copy to USB Pen Drive for deployment PC.")
    print("=" * 65)

if __name__ == "__main__":
    dest = sys.argv[1] if len(sys.argv) > 1 else None
    export_database(dest)
