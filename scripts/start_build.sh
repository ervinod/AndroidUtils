#!/bin/bash
# This script will build APK/AAB
# Run this command:  ./start_build.sh

platform="Android"
echo -e "\n\nSelect the build type for $platform:\n"
echo "1. APK"
echo "2. AAB (Android App Bundle)"

echo -e "\n"
read -p "Enter your choice: " build_type

case $build_type in
1)
  echo "Building APK for $platform"
  build_type="apk"
  ;;
2)
  echo "Building AAB for $platform with flavor $selected_flavor..."
  build_type="appbundle"
  ;;
*)
  echo "Invalid choice. Please enter 1 or 2."
  return 1
  ;;
esac

echo -e "\n"
read -p "Enter build version (Ex. 1.0.0): " build_name
echo -e "\n"
read -p "Enter build number (Ex. 1): " build_number

clear

echo "Selected Options:"
echo "-----------------"
echo "Build Type: $build_type"
echo "Build Name: $build_name"
echo "Build Number: $build_number"
echo "-----------------"

read -p "Press Enter to continue or Ctrl+C to cancel"

fvm flutter clean
fvm flutter pub get
fvm flutter build "$build_type" --release --build-name="$build_name" --build-number="$build_number"

case $build_type in
"apk")
  apk_path="flutter-apk"
  build_extension="apk"
  ;;
"appbundle")
  apk_path="bundle"
  build_extension="aab"
  ;;
*)
  echo "Invalid type."
  exit 1
  ;;
esac


apk_path=$(find "build/app/outputs/${apk_path}/" -name "*.${build_extension}" -print -quit)
flavor_uppercase=$(echo "$flavor" | tr '[:lower:]' '[:upper:]') # Convert to uppercase

if [ -n "$apk_path" ]; then
  mv "$apk_path" "$(dirname "$apk_path")/StucareAdmin_${build_name}+${build_number}.${build_extension}"
  open "$(dirname "$apk_path")"
else
  echo "Error: ${build_extension} not generated. Please check the build process."
fi
