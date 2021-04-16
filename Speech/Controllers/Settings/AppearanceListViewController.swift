//
//  AppearanceListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class AppearanceListViewController: BaseListViewController {
    // MARK: - Properties
    private var currentEditorAreaFontIndex: Int {
        editorAreaFonts.firstIndex(where: {
            $0 == DefaultsStorage.preferredEditorAreaTextFont
        }) ?? 0
    }
    
    private var editorAreaFonts: [FontStyle] = [
        .body,
        .title3,
        .title2,
        .title1,
        .largeTitle
    ]
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.settings_appearance
        sections = [
            Section(model: .init(header: "Editor area text size*"), items: [
                .editorAreaTextSize(.init(minimumValue: 0, maximumValue: Float(editorAreaFonts.count - 1), initialValue: Float(currentEditorAreaFontIndex), onSlide: { value in
                    let font = self.editorAreaFonts[safe: Int(value)] ?? .body
                    DefaultsStorage.preferredEditorAreaTextFont = font
                }))
            ]),
            Section(model: .init(header: SwiftyAssets.Strings.generic_messages), items: [
                .switchChoice(.init(title: SwiftyAssets.Strings.appearance_show_frequently_used_messages, initialValue: DefaultsStorage.showFrequentlyUsedMessages, onSwitch: { value in
                    DefaultsStorage.showFrequentlyUsedMessages = value
                }))
            ])
        ]
    }
}
