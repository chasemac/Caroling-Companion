//
//  ForgotPasswordVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class ForgotPasswordVC: LoginFlow {
    
    var signup: Bool = true
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectLoginMethodVC" {
            let detailVC = segue.destination.contents as! SelectLoginMethodVC
            detailVC.signup = sender as! Bool
            print(self.signup)
        }
    }
    
    @IBAction func createOneBtnPressed(_ sender: Any) {
        signup = true
        performSegue(withIdentifier: "SelectLoginMethodVC", sender: signup)
        print("tried to unwind")
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
