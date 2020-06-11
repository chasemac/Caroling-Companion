//
//  NavigationController.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 10/17/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        let attrs = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): christmasWhite,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "BrandonGrotesque-Black", size: 18)!,
            
            
        ]
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(attrs)
        
//        UINavigationBar.appearance().backgroundColor = UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0)
//        UINavigationBar.appearance().tintColor = UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0)
//        UINavigationBar.appearance().alpha = 1.0
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
