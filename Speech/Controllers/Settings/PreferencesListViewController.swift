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
            Section(model: .init(header: SwiftyAssets.Strings.preferences_speaking_rate), items: [
                .slider(
                    .init(minimumValue: 0.2,
                          minimumIcon: .image(SwiftyAssets.UIImages.tortoise),
                          maximumValue: 1,
                          maximumIcon: .image(SwiftyAssets.UIImages.hare),
                          initialValue: 0.5,
                          step: 0.1,
                          onSlide: { value in
                            let font = self.editorAreaFonts[safe: Int(value)] ?? .body
                            DefaultsStorage.preferredEditorAreaTextFont = font
                          }
                        )
                    )
                ]
            ),
            Section(model: .init(header: SwiftyAssets.Strings.preferences_voice), items: [
                .switchChoice(.init(title: "Use keyboard language as default*", initialValue: true, onSwitch: { value in
                    
                })),
                .details(title: SwiftyAssets.Strings.preferences_voice, vc: VoiceListViewController())
            ]),
            Section(model: .init(header: SwiftyAssets.Strings.preferences_editor_area_text_size), items: [
                .slider(
                    .init(minimumValue: 0,
                          minimumIcon: .text("A"),
                          maximumValue: Float(editorAreaFonts.count - 1),
                          maximumIcon: .text("A"),
                          initialValue: Float(currentEditorAreaFontIndex),
                          step: 1,
                          onSlide: { value in
                            let font = self.editorAreaFonts[safe: Int(value)] ?? .body
                            DefaultsStorage.preferredEditorAreaTextFont = font
                          }
                        )
                    )
                ]
            ),
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
