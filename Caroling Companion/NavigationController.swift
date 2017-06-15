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
            NSForegroundColorAttributeName: christmasWhite,
            NSFontAttributeName: UIFont(name: "BrandonGrotesque-Black", size: 18)!,
            
            
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
//        UINavigationBar.appearance().backgroundColor = UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0)
//        UINavigationBar.appearance().tintColor = UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0)
//        UINavigationBar.appearance().alpha = 1.0
    }
}
