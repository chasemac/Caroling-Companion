//
//  LandingLogin.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/18/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LandingLoginVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserSignedInStatus()
    }
    
    func checkUserSignedInStatus() {
        guard Auth.auth().currentUser != nil else {
            print("NO USER: Need to CREATE ACCOUNT!!!!!!!!!")
            return
        }
        guard Auth.auth().currentUser?.isAnonymous != true else {
            print("USER ANONYMOUS: Need to CREATE ACCOUNT!!!!!!!!!")
            return
        }
        
        print("Account Exists")
        print(Auth.auth().currentUser!.uid)
        self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
        
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
    
    
    func loginAnonymously() {
        guard Auth.auth().currentUser == nil else {
            print("A current user exists")
            performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            return
        }
        AuthService.instance.loginAnonymous { (errMsg, user) in
            print("are we here?")
            self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            if errMsg != nil {
                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                return
            }
            print("here we go")
            if user != nil {
                print("we got here")
                self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            }
        }
    }
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        loginAnonymously()
    }
    
    @IBAction func phoneBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PhoneLoginVC", sender: nil)
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        loginWithFacebook()
    }
    
}
