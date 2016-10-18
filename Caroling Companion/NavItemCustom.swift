//
//  NavItemCustom.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 10/18/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit

class NavItemCustom: UINavigationItem {
    
     func viewWillAppear(_ animated: Bool) {
        let attrs = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 24)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
}
