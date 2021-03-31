if which swiftlint >/dev/null; then
    if [ "$CI" != true ]; then
        swiftlint
    fi
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
