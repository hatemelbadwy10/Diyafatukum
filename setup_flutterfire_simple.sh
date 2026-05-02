#!/bin/bash

# Simple FlutterFire Setup - Using Existing Firebase Projects
# Diyafatukum - User & Provider Flavors

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   FlutterFire Setup - Simple Mode    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Get list of projects
echo -e "${BLUE}Fetching your Firebase projects...${NC}"
echo ""

firebase projects:list 2>/dev/null | grep -E '^\s+✔' | head -10

echo ""
echo -e "${BLUE}Enter your Firebase Project ID${NC}"
echo "(You can find this on https://console.firebase.google.com/)"
echo ""

read -p "Firebase Project ID: " PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}Error: Project ID cannot be empty${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Verifying project: $PROJECT_ID${NC}"

# Verify project exists
if ! firebase projects:list --json 2>/dev/null | grep -q "\"projectId\": \"$PROJECT_ID\""; then
    echo -e "${RED}Error: Project '$PROJECT_ID' not found in your Firebase projects${NC}"
    echo ""
    echo "Available projects:"
    firebase projects:list 2>/dev/null | grep -E '✔'
    exit 1
fi

echo -e "${GREEN}✓ Project verified!${NC}"
echo ""

# Update .firebaserc
echo -e "${BLUE}Configuring .firebaserc...${NC}"

cd "$(dirname "$0")"

cat > .firebaserc << EOF
{
  "projects": {
    "user": "$PROJECT_ID",
    "provider": "$PROJECT_ID"
  },
  "targets": {},
  "etags": {}
}
EOF

echo -e "${GREEN}✓ .firebaserc updated${NC}"
echo ""

# Set active project
firebase use $PROJECT_ID
echo -e "${GREEN}✓ Active project set to: $PROJECT_ID${NC}"
echo ""

echo "============================================"
echo -e "${BLUE}Configuration Complete!${NC}"
echo "============================================"
echo ""
echo "Firebase Project: $PROJECT_ID"
echo "User flavor: lib/main_user.dart"
echo "Provider flavor: lib/main_provider.dart"
echo ""
echo "Next steps:"
echo ""
echo "1. Download google-services.json from Firebase Console:"
echo "   - Go to: https://console.firebase.google.com/"
echo "   - Select: $PROJECT_ID"
echo "   - Go to: Project Settings > General"
echo "   - Scroll to: Android apps"
echo "   - Add Android app with package: com.daem.diyafatukum"
echo "   - Download google-services.json"
echo ""
echo "2. Place the file:"
echo "   - User app: android/app/src/user/google-services.json"
echo "   - Provider app: android/app/src/provider/google-services.json"
echo ""
echo "3. Run the apps:"
echo "   flutter clean && flutter pub get"
echo "   flutter run -t lib/main_user.dart --flavor user"
echo "   flutter run -t lib/main_provider.dart --flavor provider"
echo ""
