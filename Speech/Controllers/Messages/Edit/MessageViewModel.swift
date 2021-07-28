//
//  MessageViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 28/07/2021.
//

import Foundation

class MessageViewModel: AbstractViewModel {
    // MARK: - Properties
    @RxBehaviorSubject var emoji: String?
    @RxBehaviorSubject var message: String?
    @RxBehaviorSubject var category: Category?
    
    // MARK: -
    func onSave() {
        //        guard let text = emojiMessageView.message else { return }
        //
        //        if message.realm == nil {
        //            realmService.addObject(self.message)
        //        }
        //
        //        realmService.write {
        //            message.emoji = emojiMessageView.emoji
        //            message.text = text
        //            message.category = category
        //        } completion: { result in
        //            switch result {
        //            case .success:
        //                break
        //            case .failure:
        //                break
        //            }
        //        }
    }
}
