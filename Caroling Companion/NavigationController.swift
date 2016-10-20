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
    
//    override func viewdidA() {
//        super.viewDidLoad()
//        
//  //      var nav = self.navigationController?.navigationBar
//        
//   //     nav?.titleTextAttributes = UIFont.
//        
//        // Status bar white font
//        self.navigationBar.barStyle = UIBarStyle.default
//        self.navigationBar.tintColor = UIColor.white
//        
//        let attrs = [
//            NSForegroundColorAttributeName: UIColor.gray,
//            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 24)!
//        ]
//        
//        UINavigationBar.appearance().titleTextAttributes = attrs
//        
//        
//    }
}
