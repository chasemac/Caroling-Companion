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
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName: UIFont(name: "BigJohn", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs

    }
}
