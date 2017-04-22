//
//  AuthService.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/13/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound {
                        // Alerts user to create new user on LoginVC
                        onComplete?(USER_DOES_NOT_EXIST,nil)
                    }
                }
                // Handle all other errors
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email, password: password)
                
            } else {
                // successfully logged in
                print("successfully logged in")
                onComplete?(nil, user)
            }
        })
    }
    
    func firebaseFacebookLogin(_ credential: FIRAuthCredential, onComplete: Completion?) {
        guard FIRAuth.auth()?.currentUser?.isAnonymous == false else {
            print("attenpting to merge anonymous with Facebook")
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                    // Handle Errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "", password: "")
                } else {
                    user?.link(with: credential, completion: { (user, error) in
                        print("CHASE: Linked Succesffully authenticated with Firebase")
                        self.createFirebaseUserWithFacebook(credential: credential, user: user, error: error)
                    })
                }
            })
            return
        }
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                // Handle Errors
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "", password: "")
            } else {
                print("CHASE: Succesffully authenticated with Firebase")
                self.createFirebaseUserWithFacebook(credential: credential, user: user, error: error)
            }
        })
    }
    
    func createFirebaseUserWithEmail(email: String, password: String, onComplete: Completion?) {
        guard FIRAuth.auth()?.currentUser?.isAnonymous == false else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                self.createFirebaseUser(email: email, password: password, onComplete: onComplete, user: user, error: error)
            })
            return
        }
        print("merger")
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
        FIRAuth.auth()?.currentUser!.link(with: credential, completion: { (user, error) in
            self.createFirebaseUser(email: email, password: password, onComplete: onComplete, user: user, error: error)
        })
        
        
    }
    
    func createFirebaseUserWithFacebook(credential: FIRAuthCredential, user: FIRUser?, error: Error?) {
        if let user = user {
            if user.photoURL != nil {
                let userData = [PROVIDER_DB_STRING: credential.provider,
                                EMAIL_DB_STRING: user.email!,
                                NAME_DB_STRING: user.displayName!,
                                FACEBOOK_PROFILE_IMAGEURL_DB_STRING: user.photoURL!.absoluteString as String
                ]
                DataService.ds.createFirebaseDBUser(user.uid, userData: userData)
            } else {
                let userData = [PROVIDER_DB_STRING: credential.provider,
                                EMAIL_DB_STRING: user.email!,
                                ]
                DataService.ds.createFirebaseDBUser(user.uid, userData: userData)
            }
        }
    }
    
    func createFirebaseUser(email: String, password: String, onComplete: Completion?, user: FIRUser?, error: Error?) {
        if error != nil {
            //Show error to user
            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email, password: password)
        } else {
            if user?.uid != nil {
                let userData = [PROVIDER_DB_STRING: user?.providerID,
                                EMAIL_DB_STRING: email]
                DataService.ds.createFirebaseDBUser(user!.uid, userData: userData as! Dictionary<String, String>)
                // Sign in
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email, password: password)
                    } else {
                        // we have successfully logged in
                        onComplete?(nil, user)
                    }
                })
            }
        }
    }
    
    
    func handleFirebaseError(error: NSError, onComplete: Completion?, email: String?, password: String?) {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            switch (errorCode) {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
            case .errrorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
            case .errorCodeUserNotFound:
                onComplete?("User does not exist", nil)
            case .errorCodeEmailAlreadyInUse:
                onComplete?("An account was previously created with your Facebook's email address, please click the email button and sign in using your email address and password", nil)
                print("in use")
            case .errorCodeTooManyRequests:
                onComplete?("Too many requests", nil)
                print("too many email attemps")
            case .errorCodeAppNotAuthorized:
                onComplete?("Account not Authorized", nil)
                print("app not authorized")
            case .errorCodeNetworkError:
                onComplete?("Unable to connect to the internet!", nil)
                print("network error")
            default:
                onComplete?("There was a problem authenticating, Try again", nil)
            }
        }
    }
}
