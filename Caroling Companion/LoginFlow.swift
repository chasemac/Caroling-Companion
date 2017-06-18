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

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

