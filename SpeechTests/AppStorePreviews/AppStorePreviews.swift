//
//  AppStorePreviews.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 31/08/2021.
//
// xcrun simctl status_bar booted override --time 9:41 --operatorName ' ' --cellularMode active --cellularBar 4 --wifiBars 3 --batteryState charged --batteryLevel 100

import XCTest
import SwiftyKit
import KIF
@testable import Speech

class AppStorePreviews: AbstractTestViewController<UIViewController> {
    // MARK: - Properties
    private let previewsFolder = URL(fileURLWithPath: #file)
             .pathComponents
             .dropLast(3)
             .joined(separator: "/")
             .dropFirst()
             .appending("/AppStorePreviews")
         
     private lazy var previewsFolderURL = {
         URL(string: previewsFolder)!
     }()
    
    private var mainVC: UIViewController!
    
    override func setUp() {
        super.setUp()
        
        DefaultsStorage.onboardingDone = true
        DefaultsStorage.showFrequentlyUsedMessages = false
        DefaultsStorage.preferredMessageDisplayMode = .list
        
        SwiftyUIView.DefaultCornerRadius = 10
        mainVC = UIViewController.main
    }
    
    override func tearDown() {
        super.tearDown()
        
        DefaultsStorage.showFrequentlyUsedMessages = true
        DefaultsStorage.saveMessagesQuickly = true
        
        mainVC = nil
    }
    
    // MARK: - Previews
    private func takeScreenshot(name: String) {
        XCUIScreen.main.screenshot().saveScreenshot(folder: previewsFolderURL, forName: name)
        
//        let screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
//        UIGraphicsBeginImageContext(screen.bounds.size)
//        screen.drawHierarchy(in: screen.bounds, afterScreenUpdates: false)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        image?.save(folder: previewsFolderURL, forName: name)
    }
    
    private func showMainViewController() {
        show(viewController: mainVC, inNav: UIDevice.current.userInterfaceIdiom != .pad)
    }
    
    private func getMainNavigationViewController(from main: UIViewController, index: Int) -> NavigationController {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let splitVC = main as! SplitViewController
            return splitVC.viewControllers[index] as! NavigationController
        } else {
            return main as! NavigationController
        }
    }
    
    private func getEditorAreaViewController(from main: UIViewController) -> EditorAreaViewController {
        let nav = getMainNavigationViewController(from: main, index: 1)
        return nav.visibleViewController as! EditorAreaViewController
    }
    
    private func getMessageListViewController(from main: UIViewController) -> MessageListViewController {
        let nav = getMainNavigationViewController(from: main, index: 0)
        return nav.visibleViewController as! MessageListViewController
    }
    
    func testEditorAreaPreview() {
        // Given
        let editorVC = getEditorAreaViewController(from: mainVC)
        editorVC.viewModel.text = SwiftyAssets.Strings.preview_hello
        sut = editorVC
        
        // When
        showMainViewController()
        
        // Then
        takeScreenshot(name: "editor_area")
    }
    
    func testNewMessagePreview() {
        // Given
        DefaultsStorage.saveMessagesQuickly = false
        
        let editorVC = getEditorAreaViewController(from: mainVC)
        editorVC.toolbar.saveButton.accessibilityIdentifier = "save"
        editorVC.viewModel.text = SwiftyAssets.Strings.preview_hello
        sut = editorVC
        
        // When
        showMainViewController()
        viewTester().usingIdentifier("save").tap()
        wait(forSeconds: 1)
        
        // Then
        takeScreenshot(name: "new_message")
    }
    
    private func addRealmData() {
        let category = Speech.Category(name: "Apple", emoji: "🍎")
        let messages = [
            ("💻", "Mac", category),
            ("📱", "iPad", category),
            ("📱", "iPhone", category),
            ("⌚️", "Watch", category),
            ("🎧", "AirPods", category),
            ("🏡", "TV & Home", category)
        ].map { Message(emoji: $0.0, text: $0.1, category: $0.2) }
        
        realmService.addObject(category)
        realmService.addObjects(messages)
    }
    
    private func sharedTestMessages() {
        // Given
        addRealmData()
        
        let editorVC = getEditorAreaViewController(from: mainVC)
        editorVC.messageBarButtonItem.accessibilityIdentifier = "messages"
        sut = editorVC
        
        // When
        showMainViewController()
        if UIDevice.current.userInterfaceIdiom == .phone {
            viewTester().usingIdentifier("messages").tap()
        }
        wait(forSeconds: 1)
    }
    
    func testMessagesListPreview() {
        // Given
        sharedTestMessages()
        
        // Then
        takeScreenshot(name: "messages_list")
    }
    
    func testMessagesGridPreview() {
        // Given
        sharedTestMessages()
        
        // When
        let messagesVC = getMessageListViewController(from: mainVC)
        messagesVC.layoutModeBarButtonItem.accessibilityIdentifier = "layout_mode"
        viewTester().usingIdentifier("layout_mode").tap()
        
        wait(forSeconds: 2)
        
        // Then
        takeScreenshot(name: "message_grid")
    }
    
    func testSettingsPreview() {
        // Given
        let editorVC = getEditorAreaViewController(from: mainVC)
        editorVC.settingsBarButtonItem.accessibilityIdentifier = "settings"
        sut = editorVC
        
        // When
        showMainViewController()
        viewTester().usingIdentifier("settings").tap()
        
        wait(forSeconds: 1)
        
        viewTester().tapRowInTableView(at: IndexPath(row: 0, section: 0))
        
        wait(forSeconds: 1)
        
        // Then
        takeScreenshot(name: "settings")
    }
}
