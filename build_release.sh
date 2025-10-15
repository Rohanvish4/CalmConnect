#!/bin/bash

# CalmConnect APK Release Script
# This script builds optimized APKs and prepares them for release

set -e

echo "🚀 Starting CalmConnect APK Build Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get version from pubspec.yaml
VERSION=$(grep '^version:' pubspec.yaml | cut -d ' ' -f2 | tr -d '\r')
echo -e "${BLUE}📋 Building CalmConnect v${VERSION}${NC}"

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Create release directory
RELEASE_DIR="release/v${VERSION}"
mkdir -p "$RELEASE_DIR"

echo -e "${BLUE}🔨 Building optimized APKs...${NC}"

# Build split APKs (smaller sizes)
echo -e "${YELLOW}Building split APKs...${NC}"
flutter build apk --release --split-per-abi

# Build universal APK (broader compatibility)
echo -e "${YELLOW}Building universal APK...${NC}"
flutter build apk --release

# Copy APKs to release directory with proper names
cp build/app/outputs/flutter-apk/app-release.apk "$RELEASE_DIR/CalmConnect-v${VERSION}-universal.apk"
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk "$RELEASE_DIR/CalmConnect-v${VERSION}-arm64.apk"
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk "$RELEASE_DIR/CalmConnect-v${VERSION}-arm32.apk"
cp build/app/outputs/flutter-apk/app-x86_64-release.apk "$RELEASE_DIR/CalmConnect-v${VERSION}-x64.apk"

# Get file sizes
echo -e "${GREEN}✅ APK Build Complete!${NC}"
echo -e "${BLUE}📊 File Sizes:${NC}"
ls -lh "$RELEASE_DIR"/*.apk | awk '{print "  " $9 ": " $5}'

# Generate release notes
cat > "$RELEASE_DIR/RELEASE_NOTES.md" << EOF
# 🚀 CalmConnect v${VERSION} Release

## 📱 Download Options

### Recommended Downloads:
- **ARM64 APK** (Modern Android devices): \`CalmConnect-v${VERSION}-arm64.apk\`
- **Universal APK** (All devices): \`CalmConnect-v${VERSION}-universal.apk\`

### Other Architectures:
- **ARM32 APK** (Older devices): \`CalmConnect-v${VERSION}-arm32.apk\`
- **x64 APK** (x86 devices): \`CalmConnect-v${VERSION}-x64.apk\`

## ✨ Features
- 🧠 Mental health peer support platform
- 💬 Real-time chat with counselors and peers
- 📚 Professional resource directory
- 🌱 Daily wellness tips and self-care tools
- 🔐 Secure authentication system
- 📱 Modern Material Design 3 UI

## 🛠️ Technical Details
- **Minimum Android Version**: 5.0 (API 21)
- **Target Android Version**: 14 (API 34)
- **Architecture Support**: ARM32, ARM64, x64
- **Built with**: Flutter $(flutter --version | head -n1 | cut -d' ' -f2)

## 📋 Installation Instructions
1. Download the appropriate APK for your device
2. Enable "Install from Unknown Sources" in Android settings
3. Install the APK file
4. Launch CalmConnect and create your account!

## 🏆 Hackathon Project
This app was developed during **Hack O'Gravity 2025** - a 3-day hackathon by Career Development Cell, KNIT Sultanpur in collaboration with TCS.

Built with ❤️ for mental health support and community building.
EOF

echo -e "${GREEN}📝 Release notes generated: $RELEASE_DIR/RELEASE_NOTES.md${NC}"
echo -e "${GREEN}🎉 Release ready! Files available in: $RELEASE_DIR/${NC}"
echo -e "${BLUE}💡 Next steps:${NC}"
echo -e "   1. Upload APKs to GitHub Releases"
echo -e "   2. Update YouTube video link in README.md"
echo -e "   3. Update GitHub repository URL in README.md"
echo -e "   4. Tag the release: git tag v${VERSION}"
echo -e "   5. Push tags: git push origin v${VERSION}"