#!/bin/bash

# --- SAFETY CHECKS ---
if [ ! -d "website" ]; then
  echo "❌ Error: website directory not found!"
  exit 1
fi

# --- CREATE HIDDEN FOLDER ---
hidden_dir=".website_backup_$(date +%Y%m%d)"
mkdir -p "$hidden_dir"

# --- MOVE UNWANTED FILES ---
echo "🧹 Cleaning up website directory..."

# 1. Move non-WebP images (keep both originals and WebP during transition)
find website -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
  ! -iname "logo-image.*" \
  -exec mv -v --backup=numbered {} "$hidden_dir/" \;

# 2. Move temporary files
find website -type f \( -iname "*.tmp" -o -iname "*.bak" -o -iname "Thumbs.db" \) \
  -exec mv -v {} "$hidden_dir/" \;

# 3. Move empty directories
find website -type d -empty -exec mv -v {} "$hidden_dir/" \;

# --- VERIFICATION ---
echo -e "\n✅ Cleanup complete!"
echo "   Files moved to: $hidden_dir"
echo "   Website size: $(du -sh website)"
echo "   Hidden folder size: $(du -sh "$hidden_dir")"
echo -e "\n⚠️  Recommended next steps:"
echo "   1. Test your website thoroughly"
echo "   2. Commit changes after verification"
echo "   3. Delete $hidden_dir only when confirmed working"