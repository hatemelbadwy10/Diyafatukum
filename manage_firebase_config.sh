#!/bin/bash

# Firebase Configuration File Manager
# This script helps you manage google-services.json files for both flavors

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PROJECT_ROOT="/Users/hatemelbadwy/StudioProjects/Diyafatukum"
USER_JSON_PATH="$PROJECT_ROOT/android/app/src/user/google-services.json"
PROVIDER_JSON_PATH="$PROJECT_ROOT/android/app/src/provider/google-services.json"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Firebase Configuration Manager${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

show_status() {
    echo -e "${BLUE}Current Configuration Status:${NC}"
    echo ""
    
    if [ -f "$USER_JSON_PATH" ]; then
        echo -e "${GREEN}✓ User google-services.json${NC} exists"
        echo "  Location: $USER_JSON_PATH"
        echo "  Size: $(du -h "$USER_JSON_PATH" | cut -f1)"
    else
        echo -e "${RED}✗ User google-services.json${NC} missing"
        echo "  Expected: $USER_JSON_PATH"
    fi
    
    echo ""
    
    if [ -f "$PROVIDER_JSON_PATH" ]; then
        echo -e "${GREEN}✓ Provider google-services.json${NC} exists"
        echo "  Location: $PROVIDER_JSON_PATH"
        echo "  Size: $(du -h "$PROVIDER_JSON_PATH" | cut -f1)"
    else
        echo -e "${RED}✗ Provider google-services.json${NC} missing"
        echo "  Expected: $PROVIDER_JSON_PATH"
    fi
    
    echo ""
    echo -e "${BLUE}Firebase Projects:${NC}"
    echo "  User:     diyafatukum-user"
    echo "  Provider: diyafatukum-provider"
    echo ""
}

show_menu() {
    echo -e "${BLUE}What would you like to do?${NC}"
    echo ""
    echo "1) Check configuration status"
    echo "2) Show expected directory paths"
    echo "3) Show Firebase Console download instructions"
    echo "4) Verify JSON files are valid"
    echo "5) Display .firebaserc content"
    echo "6) Exit"
    echo ""
}

check_json_valid() {
    local json_file=$1
    local app_name=$2
    
    if [ ! -f "$json_file" ]; then
        echo -e "${RED}✗ $app_name google-services.json not found${NC}"
        return 1
    fi
    
    if ! python3 -m json.tool "$json_file" > /dev/null 2>&1; then
        echo -e "${RED}✗ $app_name google-services.json is invalid JSON${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ $app_name google-services.json is valid${NC}"
    
    # Extract and show key info
    local package=$(python3 -c "import json; data=json.load(open('$json_file')); print(data.get('projectId', 'N/A'))" 2>/dev/null || echo "N/A")
    echo "  Project ID: $package"
}

show_instructions() {
    cat << 'EOF'

Firebase Console Download Instructions:

1. Go to Firebase Console: https://console.firebase.google.com/

FOR USER APP (diyafatukum-user):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  a) Select "diyafatukum-user" project
  b) Go to: Project Settings (⚙️ icon)
  c) Click: "Service Accounts" tab
  d) Choose: "Generate New Private Key"
     OR go to "General" tab and download from Android apps section
  e) You'll get: google-services.json
  f) Save to: android/app/src/user/google-services.json

FOR PROVIDER APP (diyafatukum-provider):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  a) Select "diyafatukum-provider" project
  b) Go to: Project Settings (⚙️ icon)
  c) Click: "Service Accounts" tab
  d) Choose: "Generate New Private Key"
     OR go to "General" tab and download from Android apps section
  e) You'll get: google-services.json
  f) Save to: android/app/src/provider/google-services.json

VERIFICATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
After downloading, verify with this script option: "4) Verify JSON files"

EOF
}

show_paths() {
    cat << EOF

📁 Expected Directory Structure:

$PROJECT_ROOT/
├── android/
│   └── app/
│       └── src/
│           ├── user/
│           │   ├── AndroidManifest.xml
│           │   └── google-services.json ← DOWNLOAD & PLACE HERE
│           │
│           ├── provider/
│           │   ├── AndroidManifest.xml
│           │   └── google-services.json ← DOWNLOAD & PLACE HERE
│           │
│           ├── main/
│           ├── debug/
│           └── profile/

🔗 Direct Paths:
   User:     $USER_JSON_PATH
   Provider: $PROVIDER_JSON_PATH

EOF
}

# Main loop
while true; do
    show_status
    show_menu
    
    read -p "Enter your choice (1-6): " choice
    echo ""
    
    case $choice in
        1)
            show_status
            ;;
        2)
            show_paths
            ;;
        3)
            show_instructions
            ;;
        4)
            echo -e "${BLUE}Validating JSON files...${NC}"
            echo ""
            check_json_valid "$USER_JSON_PATH" "User"
            echo ""
            check_json_valid "$PROVIDER_JSON_PATH" "Provider"
            echo ""
            ;;
        5)
            echo -e "${BLUE}.firebaserc Content:${NC}"
            echo ""
            cat "$PROJECT_ROOT/.firebaserc"
            echo ""
            ;;
        6)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please enter 1-6.${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done
