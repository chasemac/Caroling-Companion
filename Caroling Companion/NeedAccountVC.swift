//
//  NeedAccountVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/15/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class NeedAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loginWithFacebook() {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("unable to authenticate with facebook \(String(describing: error))")
                if Auth.auth().currentUser != nil {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    AuthService.instance.firebaseFacebookLogin(credential, onComplete: { (errMsg, user) in
                        if errMsg != nil {
                            setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                            return
                        }
                        if user != nil {
                            self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
                        }
                    })
                }
                
                setupDefaultAlert(title: "", message: "Unable to authenticate with Facebook", actionTitle: "Ok", VC: self)
            } else if result?.isCancelled == true {
                print("user canceled")
            } else {
                print("successfully auth with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                AuthService.instance.firebaseFacebookLogin(credential, onComplete: { (errMsg, user) in
                    if errMsg != nil {
                        setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                        return
                    }
                    if user != nil {
                        self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
                    }
                })
            }
        }
    }

    @IBAction func phoneBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PhoneLoginVC", sender: nil)
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        loginWithFacebook()
    }

}
