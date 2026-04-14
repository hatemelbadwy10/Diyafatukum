#!/bin/bash

# filepath: /Users/macbook/Developer/Fudex/bnoon/scripts/build_ios_ipa.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🍎 iOS IPA Builder for App Store Distribution${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""

# Function to show usage
show_usage() {
    echo -e "${YELLOW}Usage: $0 [flavor] [options]${NC}"
    echo ""
    echo -e "${BLUE}Flavors:${NC}"
    echo "  user    - Build user app IPA"
    echo "  provider    - Build provider app IPA"
    echo "  both      - Build both app IPAs"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  --clean   - Clean before build"
    echo "  --archive - Archive and export IPA"
    echo "  --upload  - Upload to App Store Connect (requires --archive)"
    echo "  --help    - Show this help message"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 user --clean --archive"
    echo "  $0 provider --archive --upload"
    echo "  $0 both --clean --archive"
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check if Xcode is installed
    if ! command -v xcodebuild &> /dev/null; then
        echo -e "${RED}❌ Xcode is not installed or xcodebuild not found in PATH${NC}"
        exit 1
    fi
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter is not installed or not found in PATH${NC}"
        exit 1
    fi
    
    # Check if we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}❌ iOS builds can only be performed on macOS${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prerequisites check passed${NC}"
}

# Function to clean project
clean_project() {
    echo -e "${BLUE}🧹 Cleaning project...${NC}"
    
    # Flutter clean
    flutter clean
    
    # Clean iOS pods
    cd ios
    rm -rf Pods/
    rm -f Podfile.lock
    pod install
    cd ..
    
    # Get dependencies
    flutter pub get
    
    echo -e "${GREEN}✅ Project cleaned successfully${NC}"
}

# Function to build IPA
build_ipa() {
    local flavor=$1
    local target_file=""
    local export_options=""
    
    case $flavor in
        "user")
            target_file="lib/main_user.dart"
            export_options="ios/ExportOptions-user.plist"
            ;;
        "provider")
            target_file="lib/main_provider.dart"
            export_options="ios/ExportOptions-provider.plist"
            ;;
        *)
            echo -e "${RED}❌ Invalid flavor: $flavor${NC}"
            return 1
            ;;
    esac
    
    echo -e "${BLUE}🏗️  Building $flavor app IPA...${NC}"
    echo -e "${YELLOW}Target: $target_file${NC}"
    
    # Build the app
    flutter build ipa \
        --flavor $flavor \
        --target $target_file 
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Flutter build failed for $flavor app${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Flutter build completed for $flavor app${NC}"
    return 0
}

# Function to archive and export IPA
archive_and_export() {
    local flavor=$1
    local archive_path=""
    local ipa_path=""
    local export_options=""
    
    case $flavor in
        "user")
            archive_path="build/ios/archive/Banoonuser.xcarchive"
            ipa_path="build/ios/ipa/user"
            export_options="ios/ExportOptions-user.plist"
            ;;
        "provider")
            archive_path="build/ios/archive/Banoonprovider.xcarchive"
            ipa_path="build/ios/ipa/provider"
            export_options="ios/ExportOptions-provider.plist"
            ;;
        *)
            echo -e "${RED}❌ Invalid flavor: $flavor${NC}"
            return 1
            ;;
    esac
    
    echo -e "${BLUE}📦 Archiving $flavor app...${NC}"
    
    # Create directories
    mkdir -p "build/ios/archive"
    mkdir -p "$ipa_path"
    
    # Create export options plist if it doesn't exist
    create_export_options "$flavor" "$export_options"
    
    # Archive the app
    xcodebuild archive \
        -workspace ios/Runner.xcworkspace \

        -configuration Release \
        -archivePath "$archive_path" \
        -allowProvisioningUpdates
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Archive failed for $flavor app${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Archive completed for $flavor app${NC}"
    
    # Export IPA
    echo -e "${BLUE}📤 Exporting IPA for $flavor app...${NC}"
    
    xcodebuild -exportArchive \
        -archivePath "$archive_path" \
        -exportPath "$ipa_path" \
        -exportOptionsPlist "$export_options" \
        -allowProvisioningUpdates
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ IPA export failed for $flavor app${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ IPA exported successfully for $flavor app${NC}"
    echo -e "${CYAN}📍 IPA location: $ipa_path/${NC}"
    
    # List the generated IPA files
    echo -e "${BLUE}📋 Generated IPA files:${NC}"
    find "$ipa_path" -name "*.ipa" -exec echo -e "${GREEN}  {}${NC}" \;
    
    return 0
}

# Function to create export options plist
create_export_options() {
    local flavor=$1
    local plist_path=$2
    local bundle_id=""
    
    case $flavor in
        "user")
            bundle_id="com.fudex.banoon-app.bnoon.user"
            ;;
        "provider")
            bundle_id="com.fudex.banoon-app.bnoon.provider"
            ;;
    esac
    
    # Create the export options plist
    cat > "$plist_path" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>\${DEVELOPMENT_TEAM}</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>manageAppVersionAndBuildNumber</key>
    <true/>
    <key>destination</key>
    <string>export</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>$bundle_id</key>
        <string>\${PROVISIONING_PROFILE_SPECIFIER}</string>
    </dict>
</dict>
</plist>
EOF
    
    echo -e "${GREEN}✅ Created export options: $plist_path${NC}"
}

# Function to upload to App Store Connect
upload_to_app_store() {
    local flavor=$1
    local ipa_path=""
    
    case $flavor in
        "user")
            ipa_path="build/ios/ipa/user"
            ;;
        "provider")
            ipa_path="build/ios/ipa/provider"
            ;;
        *)
            echo -e "${RED}❌ Invalid flavor: $flavor${NC}"
            return 1
            ;;
    esac
    
    # Find the IPA file
    local ipa_file=$(find "$ipa_path" -name "*.ipa" | head -n 1)
    
    if [ -z "$ipa_file" ]; then
        echo -e "${RED}❌ No IPA file found in $ipa_path${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🚀 Uploading $flavor app to App Store Connect...${NC}"
    echo -e "${YELLOW}IPA: $ipa_file${NC}"
    
    # Check if Transporter is available
    if command -v xcrun altool &> /dev/null; then
        # Use altool (deprecated but still works)
        echo -e "${YELLOW}⚠️  Using altool (deprecated). Consider using Transporter app.${NC}"
        echo -e "${BLUE}Please provide your App Store Connect credentials:${NC}"
        read -p "Apple ID: " apple_id
        read -s -p "App-specific password: " app_password
        echo ""
        
        xcrun altool --upload-app \
            -f "$ipa_file" \
            -u "$apple_id" \
            -p "$app_password" \
            --type ios
    else
        echo -e "${YELLOW}📋 Manual upload required:${NC}"
        echo -e "${CYAN}1. Open Transporter app${NC}"
        echo -e "${CYAN}2. Sign in with your Apple ID${NC}"
        echo -e "${CYAN}3. Click '+' and select: $ipa_file${NC}"
        echo -e "${CYAN}4. Click 'Deliver'${NC}"
        echo ""
        echo -e "${BLUE}Or use the command line:${NC}"
        echo -e "${YELLOW}xcrun altool --upload-app -f \"$ipa_file\" -u \"your-apple-id\" -p \"app-specific-password\" --type ios${NC}"
    fi
    
    return 0
}

# Function to open IPA location in Finder
open_ipa_location() {
    local flavor=$1
    local ipa_path=""
    
    case $flavor in
        "user")
            ipa_path="build/ios/ipa/user"
            ;;
        "provider")
            ipa_path="build/ios/ipa/provider"
            ;;
        "both")
            ipa_path="build/ios/ipa"
            ;;
    esac
    
    if [ -d "$ipa_path" ]; then
        echo -e "${BLUE}📂 Opening IPA location in Finder...${NC}"
        open "$ipa_path"
    fi
}

# Parse command line arguments
FLAVOR=""
CLEAN_BUILD=false
ARCHIVE_BUILD=false
UPLOAD_BUILD=false

while [[ $# -gt 0 ]]; do
    case $1 in
        user|provider|both)
            FLAVOR="$1"
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --archive)
            ARCHIVE_BUILD=true
            shift
            ;;
        --upload)
            UPLOAD_BUILD=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Validate arguments
if [ -z "$FLAVOR" ]; then
    echo -e "${RED}❌ No flavor specified${NC}"
    show_usage
    exit 1
fi

if [ "$UPLOAD_BUILD" = true ] && [ "$ARCHIVE_BUILD" = false ]; then
    echo -e "${RED}❌ --upload requires --archive option${NC}"
    exit 1
fi

# Main execution
echo -e "${PURPLE}🚀 Starting iOS IPA build process...${NC}"
echo -e "${CYAN}Flavor: $FLAVOR${NC}"
echo -e "${CYAN}Clean: $CLEAN_BUILD${NC}"
echo -e "${CYAN}Archive: $ARCHIVE_BUILD${NC}"
echo -e "${CYAN}Upload: $UPLOAD_BUILD${NC}"
echo ""

# Check prerequisites
check_prerequisites

# Clean if requested
if [ "$CLEAN_BUILD" = true ]; then
    clean_project
fi

# Build function
build_flavor() {
    local flavor=$1
    
    echo -e "${PURPLE}🏗️  Building $flavor app...${NC}"
    
    # Build the app
    build_ipa "$flavor"
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Archive and export if requested
    if [ "$ARCHIVE_BUILD" = true ]; then
        archive_and_export "$flavor"
        if [ $? -ne 0 ]; then
            return 1
        fi
        
        # Upload if requested
        if [ "$UPLOAD_BUILD" = true ]; then
            upload_to_app_store "$flavor"
        fi
    fi
    
    return 0
}

# Execute build based on flavor
case $FLAVOR in
    "user")
        build_flavor "user"
        BUILD_SUCCESS=$?
        ;;
    "provider")
        build_flavor "provider"
        BUILD_SUCCESS=$?
        ;;
    "both")
        echo -e "${PURPLE}🔄 Building both apps...${NC}"
        build_flavor "user"
        user_SUCCESS=$?
        
        build_flavor "provider"
        provider_SUCCESS=$?
        
        if [ $user_SUCCESS -eq 0 ] && [ $provider_SUCCESS -eq 0 ]; then
            BUILD_SUCCESS=0
        else
            BUILD_SUCCESS=1
        fi
        ;;
esac

# Final results
echo ""
echo -e "${PURPLE}📊 Build Summary${NC}"
echo -e "${CYAN}===============${NC}"

if [ $BUILD_SUCCESS -eq 0 ]; then
    echo -e "${GREEN}🎉 Build completed successfully!${NC}"
    open_ipa_location "$FLAVOR"
    
    if [ "$ARCHIVE_BUILD" = true ]; then
        echo -e "${GREEN}📦 IPA files generated${NC}"
        open_ipa_location "$FLAVOR"
        
        echo ""
        echo -e "${BLUE}📋 Next Steps:${NC}"
        echo -e "${CYAN}1. Test the IPA files on TestFlight${NC}"
        echo -e "${CYAN}2. Upload to App Store Connect using Transporter${NC}"
        echo -e "${CYAN}3. Submit for App Store review${NC}"
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo ""
echo -e "${PURPLE}✨ iOS IPA build process completed!${NC}"
