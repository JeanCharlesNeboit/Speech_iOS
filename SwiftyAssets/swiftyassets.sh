#!/bin/sh
#
# swiftyassets.sh
# SapeursPompiers
#
# Created by Jean-Charles Neboit on 19/10/2020.
#

set -xe

if which swiftyassets >/dev/null; then
    sourceFolder=${PROJECT_DIR}/SwiftyAssets
    outputFolder=${PROJECT_DIR}/${PROJECT}/Resources
#    plistPath=${PROJECT_DIR}/${PROJECT}/SupportingFiles/Info.plist

    # Localizable Strings Generation 📝
    stringsYAML=$sourceFolder/strings.yml
    stringsSwift=$outputFolder/SwiftyStrings.swift

    if [[ ! -f "$stringsSwift" || "$stringsYAML" -nt "$stringsSwift" ]]; then
        swiftyassets strings $stringsYAML $outputFolder --project-name ${PROJECT}
    fi

#    # Colors Generation 🎨
#    colorsYAML=$sourceFolder/colors.yml
#    colorsSwift=$outputFolder/SwiftyColors.swift
#
#    if [[ ! -f "$colorsSwift" || "$colorsYAML" -nt "$colorsSwift" ]]; then
#        swiftyassets colors $colorsYAML $outputFolder --project-name ${PROJECT}
#    fi

    # Images Generation 🌃
    imagesYAML=$sourceFolder/images.yml
    imagesFolder=$sourceFolder/Images
    imagesSwift=$outputFolder/SwiftyImages.swift

    if [[ ! -f "$imagesSwift" || "$imagesYAML" -nt "$imagesSwift" ]]; then
        swiftyassets images $imagesYAML $outputFolder --resources $imagesFolder --project-name ${PROJECT}
    fi
else
    echo "warning: SwiftyAssets not installed, download from https://github.com/JeanCharlesNeboit/SwiftyAssets"
fi
