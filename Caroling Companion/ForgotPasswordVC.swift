//
//  ForgotPasswordVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class ForgotPasswordVC: LoginFlow {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createOneBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func ForgotPasswordBtnPressed(_ sender: Any) {
        forgotPassword()
    }
    
    func forgotPassword() {
        emailField.resignFirstResponder()
        let email = emailField.text
        if email != nil || email != "" {
            AuthService.instance.resetPassword(email: email!, onComplete: { (errMsg, user) in
                if errMsg != nil {
                    setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                }
            })
        } else {
            setupDefaultAlert(title: "", message: "Type valid email address in email field", actionTitle: "Ok", VC: self)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
