//
//  Typography.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 07/04/2021.
//

import UIKit

@objc enum FontStyle: Int {
    /** Size 34 */
    case largeTitle = 34

    /** Size 28 */
    case title1 = 28
    
    /** Size 22 */
    case title2 = 22
    
    /** Size 20 */
    case title3 = 20
    
    /** Size 17 */
    case body = 17
    
    /** Size 16 */
    case callout = 16
    
    /** Size 15 */
    case subheadline = 15
    
    /** Size 13 */
    case footnote = 13
    
    /** Size 12 */
    case caption1 = 12
    
    /** Size 11 */
    case caption2 = 11
    
    var size: CGFloat {
        CGFloat(self())
    }
    
    var style: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title1:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption1:
            return .caption1
        case .caption2:
            return .caption2
        }
    }
}
