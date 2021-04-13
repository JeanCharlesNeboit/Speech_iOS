//
//  VoiceListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 13/04/2021.
//

class VoiceListViewController: BaseListViewController {
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.settings_voice
        sections = [
            
        ]
    }
}
