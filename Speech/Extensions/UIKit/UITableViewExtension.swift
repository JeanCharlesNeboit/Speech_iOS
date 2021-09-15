//
//  UITableViewExtension.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 15/09/2021.
//

import UIKit


extension UITableView {
     func dequeueReusableCell<T: UITableViewCell & CellIdentifiable>(for indexPath: IndexPath) -> T? {
         dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
     }
 }
