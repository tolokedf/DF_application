#!/usr/bin/env python3
"""
DF Application Suite - Database Import Tool
Restores databases, ChromaDB vector stores, uploads, and user records
from a portable ZIP archive on deployment PCs.
"""
import os
import sys
import glob
import zipfile
import shutil
from datetime import datetime
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DB_DIR = BASE_DIR / "Database"

def find_latest_zip() -> Path:
    # Check current directory and Database/backups
    zips = glob.glob(str(BASE_DIR / "DF_Database_*.zip"))
    zips += glob.glob(str(DB_DIR / "backups" / "DF_Database_*.zip"))
    zips += glob.glob(str(BASE_DIR / "*.zip"))
    if not zips:
        return None
    # Sort by modification time
    zips.sort(key=lambda p: os.path.getmtime(p), reverse=True)
    return Path(zips[0])

def import_database(zip_source_path: str = None):
    if zip_source_path:
        archive_path = Path(zip_source_path).resolve()
    else:
        archive_path = find_latest_zip()

    if not archive_path or not archive_path.exists():
        print("❌ Error: No database ZIP archive found.")
        print("Usage: python3 scripts/import_database.py /path/to/DF_Database_backup.zip")
        sys.exit(1)

    print("=" * 65)
    print(" 📥 DF APPLICATION SUITE - DATABASE IMPORT TOOL")
    print("=" * 65)
    print(f" Archive Source: {archive_path}")
    print(f" Target Hub:     {DB_DIR}")
    print("-" * 65)

    # 1. Pre-restore safety backup
    if DB_DIR.exists():
        backup_folder = DB_DIR / "backups"
        os.makedirs(backup_folder, exist_ok=True)
        safety_name = f"pre_import_safety_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.zip"
        safety_path = backup_folder / safety_name
        
        print(" Creating safety backup of current data before extraction...")
        with zipfile.ZipFile(safety_path, 'w', zipfile.ZIP_DEFLATED) as zf:
            for root, dirs, files in os.walk(DB_DIR):
                if "backups" in Path(root).parts:
                    continue
                for file in files:
                    full_path = Path(root) / file
                    rel_path = full_path.relative_to(DB_DIR)
                    zf.write(full_path, arcname=str(rel_path))
        print(f"   [✓] Safety snapshot saved to: Database/backups/{safety_name}")

    # 2. Extract archive
    print(" Extracting archive files into Database/ ...")
    os.makedirs(DB_DIR, exist_ok=True)
    extracted_count = 0
    with zipfile.ZipFile(archive_path, 'r') as zf:
        for member in zf.infolist():
            # Security check: prevent zip slip
            target_file = DB_DIR / member.filename
            if not str(target_file.resolve()).startswith(str(DB_DIR.resolve())):
                print(f"   [!] Skipping suspicious path: {member.filename}")
                continue
            zf.extract(member, DB_DIR)
            extracted_count += 1
            print(f"   [✓] Extracted: {member.filename}")

    print("-" * 65)
    print(f" ✅ Import Complete!")
    print(f" 📁 Files Restored: {extracted_count} items")
    print(f" 📂 Database Hub:   {DB_DIR}")
    print("=" * 65)
    print(" 🚀 All 4 web applications are now linked to the restored data.")
    print(" You can start or restart the suite with: ./start_all.sh")
    print("=" * 65)

if __name__ == "__main__":
    src = sys.argv[1] if len(sys.argv) > 1 else None
    import_database(src)
