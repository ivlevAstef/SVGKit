BUILD_PATH=`pwd`/"build"
DEVICE_PATH=`pwd`/"build/Release-iphoneos"
SIM_PATH=`pwd`/"build/Release-iphonesimulator"
OUT_PATH=`pwd`/"temporary"

rm -rf SVGKit.xcframework
rm -rf $OUT_PATH
mkdir $OUT_PATH

rm -rf $BUILD_PATH
xcodebuild -target SVGKit -configuration Release -arch arm64 -verbose defines_module=yes -sdk iphoneos BUILD_LIBRARY_FOR_DISTRIBUTION=YES
mkdir "${OUT_PATH}/arm64_os"
cp -r "${DEVICE_PATH}/SVGKit.framework" "${OUT_PATH}/arm64_os/SVGKit.framework"

rm -rf $BUILD_PATH
xcodebuild -target SVGKit -configuration Release -arch arm64 -verbose defines_module=yes -sdk iphonesimulator BUILD_LIBRARY_FOR_DISTRIBUTION=YES
mkdir "${OUT_PATH}/arm64_sim"
cp -r "${SIM_PATH}/SVGKit.framework" "${OUT_PATH}/arm64_sim/SVGKit.framework"

rm -rf $BUILD_PATH
xcodebuild -target SVGKit -configuration Release -arch x86_64 -verbose defines_module=yes -sdk iphonesimulator BUILD_LIBRARY_FOR_DISTRIBUTION=YES
mkdir "${OUT_PATH}/x86_sim"
cp -r "${SIM_PATH}/SVGKit.framework" "${OUT_PATH}/x86_sim/SVGKit.framework"

mkdir "${OUT_PATH}/universal_sim"
cp -r "${OUT_PATH}/arm64_sim/SVGKit.framework" "${OUT_PATH}/universal_sim/SVGKit.framework"

lipo -create "${OUT_PATH}/x86_sim/SVGKit.framework/SVGKit" "${OUT_PATH}/arm64_sim/SVGKit.framework/SVGKit" -output "${OUT_PATH}/universal_sim/SVGKit.framework/SVGKit"
cp -r "${OUT_PATH}/x86_sim/SVGKit.framework/Modules/SVGKit.swiftmodule/" "${OUT_PATH}/universal_sim/SVGKit.framework/Modules/SVGKit.swiftmodule/"

xcodebuild -create-xcframework \
	-framework "${OUT_PATH}/arm64_os/SVGKit.framework" \
	-framework "${OUT_PATH}/universal_sim/SVGKit.framework" \
	-output "SVGKit.xcframework"

zip -r "SVGKit.zip" "SVGKit.xcframework"

rm -rf $OUT_PATH
rm -rf $BUILD_PATH