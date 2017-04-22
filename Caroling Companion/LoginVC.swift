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

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    @IBOutlet weak var loginBtn: FancyBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.pwdField.delegate = self
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("unable to authenticate with facebook \(String(describing: error))")
                setupDefaultAlert(title: "", message: "Unable to authenticate with Facebook", actionTitle: "Ok", VC: self)
            } else if result?.isCancelled == true {
                print("user canceled")
            } else {
                print("successfully auth with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                AuthService.instance.firebaseFacebookLogin(credential, onComplete: { (errMsg, user) in
                    if errMsg != nil {
                        let alert = UIAlertController(title: "Error Authenticating", message: errMsg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                })
                
            }
            self.performSegue(withIdentifier: "SongListVC", sender: nil)
        }
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if let email = emailField.text, let password = pwdField.text, (email.characters.count > 0 && password.characters.count > 0) {
            
            // Call the login service
            AuthService.instance.login(email: email, password: password, onComplete: { (errMsg, user) in
                
                if errMsg != nil && errMsg != USER_DOES_NOT_EXIST {
                    let alert = UIAlertController(title: "Error Authenticating", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else if errMsg == USER_DOES_NOT_EXIST {
                    
                    // CREATE USER
                    let alertController = UIAlertController(title: "Create New User?", message: "\(email) user account does not exist", preferredStyle: UIAlertControllerStyle.alert)
                    let destructiveAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.destructive) {
                        (result : UIAlertAction) -> Void in
                        
                        AuthService.instance.createFirebaseUserWithEmail(email: email, password: password, onComplete: { (otherErrMsg, user) in
                            guard otherErrMsg == nil else {
                                let alert = UIAlertController(title: "Error Authenticating", message: otherErrMsg, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                            self.performSegue(withIdentifier: "SongListVC", sender: nil)
                        })
                    }
                    let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("Cancel")
                    }
                    alertController.addAction(destructiveAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else if errMsg == nil {
                    self.performSegue(withIdentifier: "SongListVC", sender: nil)
                }
            })
            
        } else {
            setupDefaultAlert(title: "Username & Password Required", message: "You must enter both a username & password", actionTitle: "Ok", VC: self)
        }
        return
    }
    
    
    @IBAction func forgotPwdBtnPressed(_ sender: Any) {
        emailField.resignFirstResponder()
        
        if emailField.text != nil || emailField.text != "" {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
                
                if error != nil {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            setupDefaultAlert(title: "", message: "Email does not exist", actionTitle: "Ok", VC: self)
                            print("invalid email")
                        case .errorCodeUserNotFound:
                            setupDefaultAlert(title: "", message: "Email does not exist", actionTitle: "Ok", VC: self)
                        case .errorCodeEmailAlreadyInUse:
                            print("in use")
                        case .errorCodeTooManyRequests:
                            setupDefaultAlert(title: "", message: "Too many requests", actionTitle: "Ok", VC: self)
                            print("too many email attemps")
                        case .errorCodeAppNotAuthorized:
                            print("app not authorized")
                        case .errorCodeNetworkError:
                            print("network error")
                            setupDefaultAlert(title: "", message: "Unable to connect to the internet!", actionTitle: "Ok", VC: self)
                        default:
                            print("Create User Error: \(error!)")
                            
                        }
                    }
                } else {
                    if self.emailField.text != nil {
                        setupDefaultAlert(title: "", message: "Reset Email Sent!", actionTitle: "Ok", VC: self)
                    }
                }
                
            })
            
        } else {
            
            setupDefaultAlert(title: "", message: "Type valid email address in email field", actionTitle: "Ok", VC: self)
        }
        
    }
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        guard FIRAuth.auth()?.currentUser == nil else {
            performSegue(withIdentifier: "SongListVC", sender: nil)
            return
        }
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if error == nil {
                print("CHASE: EMAIL User authenticated with Firebase")
                if let user = user {
                    let userData = [PROVIDER_DB_STRING: user.providerID]
                    completeSignIn(user.uid, userData: userData, VC: self, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                }
            } else {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        
                    case .errorCodeNetworkError:
                        print("network error")
                        setupDefaultAlert(title: "", message: "Unable to connect to the internet!", actionTitle: "Ok", VC: self)
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
            }
        })
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    
}
