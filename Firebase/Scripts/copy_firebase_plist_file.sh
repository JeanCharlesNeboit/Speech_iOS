# https://medium.com/@pablosanchezdev/using-different-firebase-environments-in-an-ios-app-35eb0dd36e7c
# Name of the resource to copy
INFO_PLIST_FILE=GoogleService-Info.plist

# Get references to debug and release versions of the plist file
DEBUG_INFO_PLIST_FILE=${PROJECT_DIR}/Firebase/Debug/${INFO_PLIST_FILE}
RELEASE_INFO_PLIST_FILE=${PROJECT_DIR}/Firebase/Release/${INFO_PLIST_FILE}

# Make sure the debug version exists
echo "Looking for ${INFO_PLIST_FILE} in ${DEBUG_INFO_PLIST_FILE}"
if [ ! -f $DEBUG_INFO_PLIST_FILE ] ; then
    echo "error: File GoogleService-Info.plist for 'Debug' not found."
    exit 1
fi

# Make sure the release version exists
echo "Looking for ${INFO_PLIST_FILE} in ${RELEASE_INFO_PLIST_FILE}"
if [ ! -f $RELEASE_INFO_PLIST_FILE ] ; then
    echo "error: File GoogleService-Info.plist for 'Release' not found."
    exit 1
fi

# Get a reference to the destination location for the plist file
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
echo "Copying ${INFO_PLIST_FILE} to final destination: ${PLIST_DESTINATION}"

# Copy the appropiate file to app bundle
if [ "${CONFIGURATION}" == "Debug" ] ; then
    echo "File ${DEBUG_INFO_PLIST_FILE} copied"
    cp "${DEBUG_INFO_PLIST_FILE}" "${PLIST_DESTINATION}"
else
    echo "File ${RELEASE_INFO_PLIST_FILE} copied"
    cp "${RELEASE_INFO_PLIST_FILE}" "${PLIST_DESTINATION}"
fi
