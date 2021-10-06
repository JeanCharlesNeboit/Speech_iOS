//
//  MarkdownViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 22/04/2021.
//

import UIKit
import RxSwift
import MarkdownKit
import TinyConstraints
import SwiftUI

class MarkdownViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    private let markdown: String
    
    override var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
        .never
    }
    
    override var prefersLargeTitles: Bool {
        false
    }
        
    // MARK: - Initialization
    init(markdown: String) {
        self.markdown = markdown
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.attributedText = MarkdownParser(font: UIFont.getFont(style: .body), color: UIColor.text).parse(markdown)
        textView.isEditable = false
        textView.textContainerInset = .uniform(16)
        textView.contentOffset.y = view.safeAreaInsets.top
    }
}
