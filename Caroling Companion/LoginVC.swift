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
                self.firebaseAuth(credential)
            }
        }

        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        
                    case .errorCodeUserNotFound:
                        setupDefaultAlert(title: "", message: " does not exist", actionTitle: "Ok", VC: self)
                    case .errorCodeEmailAlreadyInUse:
                        setupDefaultAlert(title: "", message: "An account was previously created with your Facebook's email address, please click the email button and sign in using your email address and password", actionTitle: "Ok", VC: self)
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
                print("CHASE: Succesffully authenticated with Firebase")
                if let user = user {
                    if user.photoURL != nil {
                        let userData = [PROVIDER_DB_STRING: credential.provider,
                                        EMAIL_DB_STRING: user.email!,
                                        NAME_DB_STRING: user.displayName!,
                                        FACEBOOK_PROFILE_IMAGEURL_DB_STRING: user.photoURL!.absoluteString as String
                        ]
                        completeSignIn(user.uid, userData: userData, VC: self, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                    } else {
                        let userData = [PROVIDER_DB_STRING: credential.provider,
                                        EMAIL_DB_STRING: user.email!,
                                        ]
                        completeSignIn(user.uid, userData: userData, VC: self, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                    }
                }
            }
        })
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            // SIGN IN USER
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("CHASE: EMAIL User authenticated with Firebase")
                    if let user = user {
                        let userData = [PROVIDER_DB_STRING: user.providerID,
                                        EMAIL_DB_STRING: email]
                        completeSignIn(user.uid, userData: userData, VC: self, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                    }
                } else {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            setupDefaultAlert(title: "", message: "\(self.emailField.text!) does not exist", actionTitle: "Ok", VC: self)
                            print("invalid email")
                        case .errorCodeUserNotFound:
                            // CREATE USER
                            let alertController = UIAlertController(title: "Create New User?", message: "\(self.emailField.text!) user account does not exist", preferredStyle: UIAlertControllerStyle.alert)
                            let destructiveAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.destructive) {
                                (result : UIAlertAction) -> Void in
                                
                                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                                    if error != nil {
                                        print("CHASE: unable to authenticate with Firebase user email \(String(describing: error))!")
                                    } else {
                                        print("CHASE: Succesffully authentitcated with Firebase email")
                                        print("New User Created")
                                        if let user = user {
                                            let userData = ["provider": user.providerID,
                                                            EMAIL_DB_STRING: email]
                                            completeSignIn(user.uid, userData: userData, VC: self, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                                        }
                                    }
                                })
                            }
                            let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                                (result : UIAlertAction) -> Void in
                                print("Cancel")
                            }
                            alertController.addAction(destructiveAction)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                            
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
                }
            })
        }

    }
    
    @IBAction func forgotPwdBtnPressed(_ sender: Any) {
        emailField.resignFirstResponder()
        //      textFieldDidEndEditing(pwdField)
        if emailField.text != nil {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
                
                if error != nil {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            setupDefaultAlert(title: "", message: "\(self.emailField.text!) does not exist", actionTitle: "Ok", VC: self)
                            print("invalid email")
                        case .errorCodeUserNotFound:
                            setupDefaultAlert(title: "", message: "\(self.emailField.text!) does not exist", actionTitle: "Ok", VC: self)
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
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Keyboard is hidden
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
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
