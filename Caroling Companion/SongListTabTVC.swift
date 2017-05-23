//
//  SongListTabTVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class SongListTabTVC: SongListTVC {

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
}
