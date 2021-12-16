//
//  XCTestCaseExtension.swift
//  SpeechTests
//
//  Created by Jean-Charles Neboit on 16/12/2021.
//

import Foundation
import KIF

extension XCTestCase {
    func viewTester(_ file: String = #file, _ line: Int = #line) -> KIFUIViewTestActor {
        return KIFUIViewTestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(_ file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}
