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
    // MARK: - Properties
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textContainerInset = .uniform(16)
        return textView
    }()
    
    override var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
        .never
    }
    
    override var prefersLargeTitles: Bool {
        false
    }
        
    // MARK: - Initialization
    init(markdown: String) {
        super.init()
        textView.attributedText = MarkdownParser(font: UIFont.getFont(style: .body), color: UIColor.text).parse(markdown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor._systemBackground
        view.addSubview(textView)
        textView.edgesToSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.setContentOffset(.zero, animated: true)
    }
}
