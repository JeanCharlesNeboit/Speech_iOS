//
//  PreferencesListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class PreferencesListViewController: BaseListViewController {
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
        title = SwiftyAssets.Strings.settings_preferences
        sections = [
            Section(model: .init(header: "Speaking rate*"), items: [
                .editorAreaTextSize(.init(minimumValue: 0, maximumValue: 1, initialValue: 0.5, onSlide: { value in
                    let font = self.editorAreaFonts[safe: Int(value)] ?? .body
                    DefaultsStorage.preferredEditorAreaTextFont = font
                }))
            ]),
            Section(model: .init(header: "Voice*"), items: [
                .switchChoice(.init(title: "Use keyboard language as default*", initialValue: true, onSwitch: { value in
                    
                })),
                .details(title: SwiftyAssets.Strings.settings_voice, vc: VoiceListViewController())
            ]),
            Section(model: .init(header: "Editor area text size*"), items: [
                .editorAreaTextSize(.init(minimumValue: 0, maximumValue: Float(editorAreaFonts.count - 1), initialValue: Float(currentEditorAreaFontIndex), onSlide: { value in
                    let font = self.editorAreaFonts[safe: Int(value)] ?? .body
                    DefaultsStorage.preferredEditorAreaTextFont = font
                }))
            ]),
            Section(model: .init(header: SwiftyAssets.Strings.generic_messages), items: [
                .switchChoice(
                    .init(title: SwiftyAssets.Strings.preferences_save_messages_quickly,
                          initialValue: DefaultsStorage.saveMessagesQuickly,
                          onSwitch: { value in
                            DefaultsStorage.saveMessagesQuickly = value
                          })
                ),
                .switchChoice(
                    .init(title: SwiftyAssets.Strings.preferences_show_frequently_used_messages,
                          initialValue: DefaultsStorage.showFrequentlyUsedMessages,
                          onSwitch: { value in
                            DefaultsStorage.showFrequentlyUsedMessages = value
                          })
                )
            ])
        ]
    }
}
