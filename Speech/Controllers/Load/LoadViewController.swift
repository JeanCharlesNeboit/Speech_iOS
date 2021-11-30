//
//  LoadViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/09/2021.
//

import UIKit

class LoadViewController: AbstractViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !DefaultsStorage.coreDataMigrationDone {
            RealmService.default.performCoreDataToRealmMigration()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIWindow.currentWindow?.set(rootViewController: UIViewController.main)
        }
    }
}

// MARK: - Previews
#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 15, *)
struct LoadViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadViewController().asPreview()
                .previewDevice("iPhone 13")
            LoadViewController().asPreview()
                .previewDevice("iPad Pro (9.7-inch)")
            LoadViewController().asPreview()
                .previewDevice("iPad Pro (9.7-inch)")
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
#endif
