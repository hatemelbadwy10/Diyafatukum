#!/bin/bash

# Firebase Setup Script for Diyafatukum
# This script helps you create Firebase projects for both user and provider apps

set -e

echo "============================================"
echo "  Firebase Project Setup"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed"
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

echo -e "${GREEN}✓ Firebase CLI is installed ($(firebase --version))${NC}"
echo ""

# Check if user is logged in
echo "Checking Firebase login status..."
if firebase auth:list &> /dev/null; then
    echo -e "${GREEN}✓ You are logged in to Firebase${NC}"
else
    echo -e "${YELLOW}⚠ You are not logged in to Firebase${NC}"
    echo "Attempting to login..."
    firebase login
fi

echo ""
echo "============================================"
echo "  Creating Firebase Projects"
echo "============================================"
echo ""

# Define project details
USER_PROJECT_ID="diyafatukum-user"
PROVIDER_PROJECT_ID="diyafatukum-provider"
PROJECT_NAME_USER="Diyafatukum User"
PROJECT_NAME_PROVIDER="Diyafatukum Provider"

echo -e "${BLUE}Project 1: User App${NC}"
echo "  Project ID: $USER_PROJECT_ID"
echo "  Name: $PROJECT_NAME_USER"
echo "  Package: com.daem.diyafatukum"
echo ""

echo -e "${BLUE}Project 2: Provider App${NC}"
echo "  Project ID: $PROVIDER_PROJECT_ID"
echo "  Name: $PROJECT_NAME_PROVIDER"
echo "  Package: com.daem.diyafatukum.provider"
echo ""

read -p "Continue with project creation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 1
fi

echo ""
echo -e "${YELLOW}Note: Project creation requires a Firebase account and billing enabled${NC}"
echo ""

# Function to check if project exists
check_project_exists() {
    firebase projects:list --json 2>/dev/null | grep -q "\"projectId\": \"$1\"" && echo "true" || echo "false"
}

# Create or use existing user project
echo "Setting up User App project..."
if [ "$(check_project_exists $USER_PROJECT_ID)" = "true" ]; then
    echo -e "${GREEN}✓ Project $USER_PROJECT_ID already exists${NC}"
else
    echo "Creating project $USER_PROJECT_ID..."
    firebase projects:create $USER_PROJECT_ID --display-name="$PROJECT_NAME_USER" || echo -e "${YELLOW}⚠ Project creation requires manual setup in Firebase Console${NC}"
fi

echo ""

# Create or use existing provider project
echo "Setting up Provider App project..."
if [ "$(check_project_exists $PROVIDER_PROJECT_ID)" = "true" ]; then
    echo -e "${GREEN}✓ Project $PROVIDER_PROJECT_ID already exists${NC}"
else
    echo "Creating project $PROVIDER_PROJECT_ID..."
    firebase projects:create $PROVIDER_PROJECT_ID --display-name="$PROJECT_NAME_PROVIDER" || echo -e "${YELLOW}⚠ Project creation requires manual setup in Firebase Console${NC}"
fi

echo ""
echo "============================================"
echo "  Firebase Configuration Files"
echo "============================================"
echo ""

# Instructions for getting google-services.json
cat << 'EOF'
To get your Firebase configuration files, follow these steps:

1. Go to Firebase Console: https://console.firebase.google.com/

2. For User App (diyafatukum-user):
   - Select project: diyafatukum-user
   - Go to Project Settings > Service Accounts
   - Click "Generate New Private Key"
   - Or: Project Settings > General > Android apps section
   - Download google-services.json
   - Place it in: android/app/src/user/google-services.json

3. For Provider App (diyafatukum-provider):
   - Select project: diyafatukum-provider
   - Go to Project Settings > Service Accounts
   - Click "Generate New Private Key"
   - Or: Project Settings > General > Android apps section
   - Download google-services.json
   - Place it in: android/app/src/provider/google-services.json

EOF

echo ""
echo "============================================"
echo "  Firebase Initialization"
echo "============================================"
echo ""

# Check if .firebaserc exists
if [ -f ".firebaserc" ]; then
    echo -e "${GREEN}✓ .firebaserc already exists${NC}"
else
    echo "Creating .firebaserc..."
    cat > .firebaserc << EOF
{
  "projects": {
    "user": "$USER_PROJECT_ID",
    "provider": "$PROVIDER_PROJECT_ID"
  },
  "targets": {},
  "etags": {}
}
EOF
    echo -e "${GREEN}✓ Created .firebaserc${NC}"
fi

echo ""
echo "============================================"
echo "  Next Steps"
echo "============================================"
echo ""
echo "1. Download google-services.json files from Firebase Console"
echo "2. Place android/app/src/user/google-services.json (for user app)"
echo "3. Place android/app/src/provider/google-services.json (for provider app)"
echo ""
echo "4. For iOS, download GoogleService-Info.plist from Firebase Console"
echo "   and place in ios/Runner/"
echo ""
echo "5. Run the apps with:"
echo "   flutter run -t lib/main_user.dart --flavor user"
echo "   flutter run -t lib/main_provider.dart --flavor provider"
echo ""
echo -e "${GREEN}Setup complete!${NC}"
