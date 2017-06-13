//
//  EmailLoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailLoginVC: LoginFlow {
    var signup: Bool = true
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var iForgotBtn: UIButton!
    
    @IBOutlet weak var loginBtn: OutlineBtn!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        printCurrentUser()
    }
    
    private func setupView() {
        var text = ""
        if signup == true {
            text = "SIGN UP"
            iForgotBtn.isHidden = true
        } else {
            text = "LOG IN"
        }
        loginBtn.titleLabel?.text = text
    }
    
    private func emailLogin() {
        if let email = emailField.text, let password = pwdField.text, (email.characters.count > 0 && password.characters.count > 0) {
            // Call the login service
            AuthService.instance.login(email: email, password: password, onComplete: { (errMsg, user) in
                if errMsg == USER_DOES_NOT_EXIST && self.signup == true {
                    // CREATE USER
                    AuthService.instance.createFirebaseUserWithEmail(email: email, password: password, onComplete: { (otherErrMsg, user) in
                        guard otherErrMsg == nil else {
                            setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                            return
                        }
                        self.performSegue(withIdentifier: SongListVC, sender: nil)
                    })

                } else if errMsg != nil && errMsg != USER_DOES_NOT_EXIST {
                    setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                    return
                }
                else if user != nil {
                    self.performSegue(withIdentifier: SongListVC, sender: nil)
                }
            })
        } else {
            setupDefaultAlert(title: "Username & Password Required", message: "You must enter both a username & password", actionTitle: "Ok", VC: self)
        }
        return
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        emailLogin()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
