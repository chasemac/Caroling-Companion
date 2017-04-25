//
//  LoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/20/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginVC: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    @IBOutlet weak var loginBtn: FancyBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("Logged in user UID ------> \(FIRAuth.auth()?.currentUser!.uid as Any)")
        } else {
            print("no current user")
        }
        self.emailField.delegate = self
        self.pwdField.delegate = self
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("unable to authenticate with facebook \(String(describing: error))")
                if FIRAuth.auth()?.currentUser != nil {
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    AuthService.instance.firebaseFacebookLogin(credential, onComplete: { (errMsg, user) in
                        if errMsg != nil {
                            setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                            return
                        }
                        if user != nil {
                            self.performSegue(withIdentifier: "ProfileVC", sender: nil)
                        }
                    })
                }

                setupDefaultAlert(title: "", message: "Unable to authenticate with Facebook", actionTitle: "Ok", VC: self)
            } else if result?.isCancelled == true {
                print("user canceled")
            } else {
                print("successfully auth with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                AuthService.instance.firebaseFacebookLogin(credential, onComplete: { (errMsg, user) in
                    if errMsg != nil {
                        setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                        return
                    }
                    if user != nil {
                        self.performSegue(withIdentifier: "ProfileVC", sender: nil)
                    }
                })
                
            }
            
        }
        
    }
    @IBAction func googleBtnTapped(_ sender: Any) {
        
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print(error)
//            // HANDLE THIS LATER
//            return
//        }
//        
//        guard let authentication = user.authentication else { return }
//        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
//        accessToken: authentication.accessToken)
//        
//        print("user connected with google --> Credential FROM LoginVC: \(credential)")
//        // HANDLE THIS LATER
//        AuthService.instance.firebaseGoogleLogin(credential) { (errMsg, user) in
//            // THIS IS REPEATED CODE... REFACTOR IT
//            if errMsg != nil {
//                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
//                return
//            }
//            if user != nil {
//                self.performSegue(withIdentifier: "ProfileVC", sender: nil)
//            }
//        }
//        
//    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if let email = emailField.text, let password = pwdField.text, (email.characters.count > 0 && password.characters.count > 0) {
            
            // Call the login service
            AuthService.instance.login(email: email, password: password, onComplete: { (errMsg, user) in
                
                if errMsg == USER_DOES_NOT_EXIST {
                    // CREATE USER
                    let alertController = UIAlertController(title: "Create New User?", message: "\(email) user account does not exist", preferredStyle: UIAlertControllerStyle.alert)
                    let destructiveAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        
                        AuthService.instance.createFirebaseUserWithEmail(email: email, password: password, onComplete: { (otherErrMsg, user) in
                            guard otherErrMsg == nil else {
                                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                                return
                            }
                            self.performSegue(withIdentifier: "ProfileVC", sender: nil)
                        })
                    }
                    let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("Cancel")
                    }
                    alertController.addAction(destructiveAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else if errMsg != nil && errMsg != USER_DOES_NOT_EXIST {
                    setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                    return
                }
                else if user != nil {
                    self.performSegue(withIdentifier: "ProfileVC", sender: nil)
                }
            })
        } else {
            setupDefaultAlert(title: "Username & Password Required", message: "You must enter both a username & password", actionTitle: "Ok", VC: self)
        }
        return
    }
    
    @IBAction func forgotPwdBtnPressed(_ sender: Any) {
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
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        guard FIRAuth.auth()?.currentUser == nil else {
            performSegue(withIdentifier: "ProfileVC", sender: nil)
            return
        }
        AuthService.instance.loginAnonymous { (errMsg, user) in
            print("are we here?")
            self.performSegue(withIdentifier: "ProfileVC", sender: nil)
            if errMsg != nil {
                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                return
            }
            print("here we go")
            if user != nil {
                print("we got here")
                self.performSegue(withIdentifier: "ProfileVC", sender: nil)
            }
        }
    }
    
    // MARK: KEYBOARD FUNCTIONS
    // Move View
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // Keyboard shows
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -216, up: true)
    }
    
    // Keyboard is hidden
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -216, up: false)
    }
    
    //presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        pwdField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func UnlinkBtnTapped(_ sender: Any) {
        print(FIRAuth.auth()?.currentUser?.providerID as Any)
        
        let providerID = "facebook.com"
        //    let providerID = FIRAuth.auth()?.currentUser?.providerID
        
        FIRAuth.auth()?.currentUser?.unlink(fromProvider: providerID) { (user, error) in
            if error != nil {
                print("success")
                print(FIRAuth.auth()?.currentUser?.providerData.count as Any)
            }
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            if FIRAuth.auth()?.currentUser?.uid != nil {
                print("attempting to log out of \(String(describing: FIRAuth.auth()?.currentUser?.uid))")
            }
            
            try  FIRAuth.auth()?.signOut()
            print("logged out")
        } catch {
            print("failed"  )
        }
    }
    
}
