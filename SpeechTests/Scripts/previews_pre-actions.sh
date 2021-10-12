#!bin/bash
# https://blog.slaunchaman.com/2019/09/11/fixing-simulator-status-bars-for-app-store-screenshots-with-xcode-11-and-ios-13/

function version {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

# Don’t run on iOS devices.
if [[ "${SDKROOT}" != *"simulator"* ]]; then
    exit 0
fi

# Don’t run on iOS versions before 13.
if [ $(version "${TARGET_DEVICE_OS_VERSION}") -ge $(version "13") ]; then
    xcrun simctl boot "${TARGET_DEVICE_IDENTIFIER}"

    xcrun simctl status_bar "${TARGET_DEVICE_IDENTIFIER}" override \
        --time "3:13 PM" \
        --dataNetwork wifi \
        --wifiMode active \
        --wifiBars 3 \
        --cellularMode notSupported \
        --batteryState discharging \
        --batteryLevel 100
fi
