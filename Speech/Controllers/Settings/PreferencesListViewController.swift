//
//  PreferencesListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

import UIKit

#warning("Add prefered voice language")
class PreferencesListViewController: BaseListViewController {
    // MARK: - Properties
    static let title = SwiftyAssets.Strings.settings_preferences
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
    
    private var automaticLanguageRecognitionAvailable: Bool {
        if #available(iOS 12.0, *) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = Self.title
        
        sections = [
            Section(model: .init(header: SwiftyAssets.Strings.preferences_speaking_rate), items: [
                .slider(
                    .init(minimumValue: 0,
                          minimumIcon: .image(SwiftyAssets.UIImages.tortoise, .text),
                          maximumValue: 1,
                          maximumIcon: .image(SwiftyAssets.UIImages.hare, .text),
                          initialValue: DefaultsStorage.preferredSpeakingRate,
                          step: 1/6,
                          onSlide: { value in
                            DefaultsStorage.preferredSpeakingRate = value
                          }
                        )
                    )
                ]
            ),
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
            Section(model: .init(header: SwiftyAssets.Strings.preferences_voice), items: [
                .details(config: .init(title: SwiftyAssets.Strings.preferences_preferred_voice_language)) { VoiceLanguageListViewController() },
                .details(config: .init(title: SwiftyAssets.Strings.preferences_voice)) { VoiceListViewController() },
                automaticLanguageRecognitionAvailable ? .switchChoice(
                    .init(title: SwiftyAssets.Strings.preferences_automatic_language_recognition,
                          initialValue: DefaultsStorage.automaticLanguageRecognition,
                          onSwitch: { _ in
                            DefaultsStorage.automaticLanguageRecognition.toggle()
                          }
                )) : nil
            ].compactMap { $0 }),
            Section(model: .init(header: SwiftyAssets.Strings.generic_messages), items: [
                .switchChoice(
                    .init(title: SwiftyAssets.Strings.preferences_save_messages_quickly,
                          initialValue: DefaultsStorage.saveMessagesQuickly,
                          onSwitch: { value in
                            DefaultsStorage.saveMessagesQuickly = value
                          })
                ),
                .switchChoice(
                    .init(title: SwiftyAssets.Strings.show_frequently_used_messages,
                          initialValue: DefaultsStorage.showFrequentlyUsedMessages,
                          onSwitch: { value in
                            DefaultsStorage.showFrequentlyUsedMessages = value
                          })
                ),
                .switchChoice(
                    .init(title: SwiftyAssets.Strings.preferences_replace_text_when_message_selected,
                          initialValue: DefaultsStorage.replaceTextWhenMessageSelected,
                          onSwitch: { value in
                            DefaultsStorage.replaceTextWhenMessageSelected = value
                          })
                ),
                UIDevice.current.isPhone ? .switchChoice(
                    .init(title: SwiftyAssets.Strings.preferences_close_message_view_when_message_selected,
                          initialValue: DefaultsStorage.replaceTextWhenMessageSelected,
                          onSwitch: { value in
                            DefaultsStorage.closeMessageViewWhenMessageSelected = value
                          })
                ) : nil
            ].compactMap { $0 })
        ]
    }
}
