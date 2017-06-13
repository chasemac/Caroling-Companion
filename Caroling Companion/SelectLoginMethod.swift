//
//  SelectLoginMethod.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class SelectLoginMethod: UIViewController {
    
    @IBOutlet weak var instructionLbl: UILabel!
    var signup: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var text = ""
        if signup == true {
            text = "Sign Up"
        } else {
            text = "Log In"
        }
        instructionLbl.text = "Select \(text) Method"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailLoginVC" {
            let detailVC = segue.destination.contents as! EmailLoginVC
            detailVC.signup = sender as! Bool
        } else if segue.identifier == "PhoneLoginVC" {
            let detailVC = segue.destination.contents as! PhoneLoginVC
            detailVC.signup = sender as! Bool
        }
    }
    
    @IBAction func emailBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "EmailLoginVC", sender: signup)
    }
    
    @IBAction func phoneBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PhoneLoginVC", sender: signup)
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        loginWithFacebook()
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
                            self.performSegue(withIdentifier: SongListVC, sender: nil)
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
                        self.performSegue(withIdentifier: SongListVC, sender: nil)
                    }
                })
            }
        }
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
