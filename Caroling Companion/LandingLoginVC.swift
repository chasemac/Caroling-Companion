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
    
    @IBOutlet weak var facebookBtn: OutlineBtn!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var phoneBtn: OutlineBtn!
    var darkShade: CGFloat = 0.8
    var screenView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView = UIImageView(frame: self.view.frame)
        screenView.backgroundColor = UIColor.black
        screenView.alpha = 0.0
        navigationController?.view.addSubview(screenView)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserSignedInStatus()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
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
                            self.facebookBtn.isEnabled = true
                            self.screenView.alpha = 0
                            setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)

                            return
                        }
                        if user != nil {
                            self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
                            self.facebookBtn.isEnabled = true
                            self.screenView.alpha = 0
                        }
                    })
                }
                self.facebookBtn.isEnabled = true
                self.screenView.alpha = 0
                setupDefaultAlert(title: "", message: "Unable to authenticate with Facebook", actionTitle: "Ok", VC: self)
            } else if result?.isCancelled == true {
                print("user canceled")
                self.facebookBtn.isEnabled = true
                self.screenView.alpha = 0
            } else {
                print("successfully auth with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                AuthService.instance.firebaseFacebookLogin(credential, onComplete: { (errMsg, user) in
                    if errMsg != nil {
                        setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                        self.facebookBtn.isEnabled = true
                        self.screenView.alpha = 0
                        return
                    }
                    if user != nil {
                        self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
                        self.facebookBtn.isEnabled = true
                        self.screenView.alpha = 0
                    }
                })
            }
        }
        
    }
    
    
    func loginAnonymously() {
        guard Auth.auth().currentUser == nil else {
            print("A current user exists")
            performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            skipBtn.isEnabled = true
            screenView.alpha = 0.0
            return
        }
        AuthService.instance.loginAnonymous { (errMsg, user) in
            print("are we here?")
            self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            self.skipBtn.isEnabled = true
            self.screenView.alpha = 0.0
            if errMsg != nil {
                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                self.skipBtn.isEnabled = true
                self.screenView.alpha = 0.0
                return
            }
            print("here we go")
            if user != nil {
                print("we got here")
                self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
                self.skipBtn.isEnabled = true
                self.screenView.alpha = 0.0
            }
        }
    }
    
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        skipBtn.isEnabled = false
        screenView.alpha = darkShade
        loginAnonymously()
    }
    
    @IBAction func phoneBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PhoneLoginVC", sender: nil)
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        facebookBtn.isEnabled = false
        screenView.alpha = darkShade

        loginWithFacebook()
    }
    
}
