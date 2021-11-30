//
//  UIViewControllerExtension+Preview.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/11/2021.
//

#if canImport(SwiftUI)
import UIKit
import SwiftUI

extension UIViewController {
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        var viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController,
                                    context: Context) {
            // No-op
        }
    }

    @available(iOS 13, *)
    func asPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
