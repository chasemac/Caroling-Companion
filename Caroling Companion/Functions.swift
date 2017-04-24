//
//  Functions.swift
//  SocialApp
//
//  Created by Chase McElroy on 4/5/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

import Firebase

func setupDefaultAlert(title: String, message: String, actionTitle: String, VC: UIViewController) {
    let successfulEmailSentAlertConroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let alrighty = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
        
    })
    successfulEmailSentAlertConroller.addAction(alrighty)
    VC.present(successfulEmailSentAlertConroller, animated: true, completion: nil)
}
/*
func completeSignIn(_ id: String, userData: Dictionary<String, String>, VC: UIViewController, usernameExistsSegue: String, userNameDNESegue: String) {
    DataService.ds.createFirebaseDBUser(id, userData: userData)
    
    // Check if Username exist
    DataService.ds.REF_USERS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(USERNAME_DB_STRING) {
            VC.performSegue(withIdentifier: usernameExistsSegue, sender: nil)
        } else {
            print("username doesn't exist")
            VC.performSegue(withIdentifier: userNameDNESegue, sender: nil)
        }
    })
}


func singInTest(emailField: String?, pwd: String?, VC: UIViewController) {
    if let email = emailField, let pwd = pwd {
        guard FIRAuth.auth()?.currentUser?.isAnonymous == false else {
            print("merger")
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: pwd)
            FIRAuth.auth()?.currentUser!.link(with: credential, completion: { (user, error) in
                if error == nil {
                    print("CHASE: EMAIL User authenticated with Firebase")
                    if let user = user {
                        let userData = [PROVIDER_DB_STRING: user.providerID,
                                        EMAIL_DB_STRING: email]
                        completeSignIn(user.uid, userData: userData, VC: VC, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                    }
                } else {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            setupDefaultAlert(title: "", message: "\(email) does not exist", actionTitle: "Ok", VC: VC)
                            print("invalid email")
                        case .errorCodeUserNotFound:
                            // CREATE USER
                            let alertController = UIAlertController(title: "Create New User?", message: "\(email) user account does not exist", preferredStyle: UIAlertControllerStyle.alert)
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
                                            completeSignIn(user.uid, userData: userData, VC: VC, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
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
                            VC.present(alertController, animated: true, completion: nil)
                            
                        case .errorCodeTooManyRequests:
                            setupDefaultAlert(title: "", message: "Too many requests", actionTitle: "Ok", VC: VC)
                            print("too many email attemps")
                        case .errorCodeAppNotAuthorized:
                            print("app not authorized")
                        case .errorCodeNetworkError:
                            print("network error")
                            setupDefaultAlert(title: "", message: "Unable to connect to the internet!", actionTitle: "Ok", VC: VC)
                        default:
                            print("Create User Error: \(error!)")
                        }
                    }
                }
            })
            return
        }
        
        
        // SIGN IN USER
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
            if error == nil {
                print("CHASE: EMAIL User authenticated with Firebase")
                if let user = user {
                    
                    
                    
                    let userData = [PROVIDER_DB_STRING: user.providerID,
                                    EMAIL_DB_STRING: email]
                    completeSignIn(user.uid, userData: userData, VC: VC, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
                }
            } else {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        setupDefaultAlert(title: "", message: "\(email) does not exist", actionTitle: "Ok", VC: VC)
                        print("invalid email")
                    case .errorCodeUserNotFound:
                        // CREATE USER
                        let alertController = UIAlertController(title: "Create New User?", message: "\(email) user account does not exist", preferredStyle: UIAlertControllerStyle.alert)
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
                                        completeSignIn(user.uid, userData: userData, VC: VC, usernameExistsSegue: "SongListVC", userNameDNESegue: "SongListVC")
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
                        VC.present(alertController, animated: true, completion: nil)
                        
                    case .errorCodeTooManyRequests:
                        setupDefaultAlert(title: "", message: "Too many requests", actionTitle: "Ok", VC: VC)
                        print("too many email attemps")
                    case .errorCodeAppNotAuthorized:
                        print("app not authorized")
                    case .errorCodeNetworkError:
                        print("network error")
                        setupDefaultAlert(title: "", message: "Unable to connect to the internet!", actionTitle: "Ok", VC: VC)
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
            }
        })
    }
    
}

*/
