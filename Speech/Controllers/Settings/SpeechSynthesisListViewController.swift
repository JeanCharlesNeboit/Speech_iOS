//
//  SpeechSynthesisListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

import UIKit

class SpeechSynthesisListViewController: BaseListViewController {
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.settings_speech_synthesis
        sections = [
            Section(model: .init(header: "Speaking rate*"), items: [
//                .editorAreaTextSize(.init(minimumValue: 0, maximumValue: Float(editorAreaFonts.count - 1), initialValue: Float(currentEditorAreaFontIndex), onSlide: { value in
//                    let font = self.editorAreaFonts[safe: Int(value)] ?? .body
//                    DefaultsStorage.preferredEditorAreaTextFont = font
//                }))
            ]),
            Section(model: .init(header: "Language*"), items: [
                .switchChoice(.init(title: "Use keyboard language as default*", initialValue: true, onSwitch: { value in
                    
                })),
                .details(title: SwiftyAssets.Strings.settings_voice, vc: VoiceListViewController())
            ])
        ]
    }
}
