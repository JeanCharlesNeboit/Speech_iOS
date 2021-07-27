//
//  MarkdownViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 22/04/2021.
//

//import UIKit
//import WebKit
//import RxSwift
//import Ink
//import TinyConstraints
//
//class MarkdownViewController: AbstractViewController {
//    // MARK: - Properties
//    private let markdownPrivacyPolicyPath = Bundle.main.path(forResource: "privacy_policy", ofType: "md")
//    private lazy var markdown: String? = {
//        guard let path = markdownPrivacyPolicyPath else { return nil }
//        return FileManager.default.contents(atPath: path)
//    }()
//    
//    private let htmlPrivacyPolicyPath = Bundle.main.path(forResource: "privacy_policy", ofType: "html")
//    private lazy var html: String? = {
//        guard let markdown = markdown,
//              let path = htmlPrivacyPolicyPath else { return nil }
//        let content = parser.html(from: markdown)
//        print("HTML: \(content)")
//        return FileManager.default.contents(atPath: path)?.replacingOccurrences(of: "$CONTENT", with: content)
//    }()
//    
//    private lazy var webView: WKWebView = {
//        let webView = WKWebView()
//        webView.backgroundColor = .clear
//        webView.isOpaque = false
//        return webView
//    }()
//    
//    private var parser = MarkdownParser()
//    
//    // MARK: - Initialization
//    override func sharedInit() {
//        super.sharedInit()
//        title = SwiftyAssets.Strings.settings_privacy_policy
//        addWebViewAsSubView()
//        loadHTML()
//    }
//    
//    // MARK: - Configure
//    override func configure() {
//        NotificationCenter.default.rx
//            .notification(UIContentSizeCategory.didChangeNotification)
//            .subscribe(onNext: { [weak self] _ in
//                self?.webView.reload()
//            }).disposed(by: disposeBag)
//    }
//    
//    private func addWebViewAsSubView() {
//        view.addSubview(webView)
//        webView.edgesToSuperview()
//    }
//    
//    private func loadHTML() {
//        if let html = html {
//            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
//        }
//        
// //       if let url = Bundle.main.url(forResource: "privacy_policy", withExtension: "html") {
// //           webView.loadFileURL(url, allowingReadAccessTo: url)
// //       }
//    }
//}

//extension FileManager {
//    func contents(atPath: String) -> String? {
//        guard let data: Data = contents(atPath: atPath) else { return nil }
//        return String(decoding: data, as: UTF8.self)
//    }
//}
