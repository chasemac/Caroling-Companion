//
//  LoginFlow.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class LoginFlow: UIViewController {
    
    @IBOutlet weak var loginBtnToBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtnToBottom.constant = keyboardHeightConstraintConstant() + 3
    }

    func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    func keyboardHeightConstraintConstant() -> CGFloat {
        switch(self.screenHeight()) {
        case 568:
            return 224
            
        case 667:
            return 225
            
        case 736:
            return 236
            
        default:
            return 236
        }
    }

}