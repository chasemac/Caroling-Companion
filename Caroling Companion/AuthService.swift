//
//  AuthService.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/13/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKCoreKit
import GoogleSignIn

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func loginAnonymous(onComplete: Completion?) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if error == nil {
                print("CHASE: Anonymous User authenticated with Firebase")
                DataService.ds.createFirebaseDBUser(provider: PROVIDER_ANONYMOUS_DB_STRING, user: user, error: error)
                onComplete!(nil, user)
            } else {
                if error != nil {
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
                }
            }
        })
    }
    
    func firebaseFacebookLogin(_ credential: FIRAuthCredential, onComplete: Completion?) {
        guard FIRAuth.auth()?.currentUser?.isAnonymous != true else {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("attenpting to merge \(String(describing: FIRAuth.auth()?.currentUser?.uid)) with Facebook")
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                    // Handle Errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
                } else {
                    user?.link(with: credential, completion: { (user, error) in
                        print("CHASE: Attempted Link with Firebase")
                        if user != nil {
                            DataService.ds.createFirebaseDBUser(provider: PROVIDER_FACEBOOK_DB_STRING, user: user, error: error)
                            onComplete!(nil, user)
                        } else {
                            onComplete!(error as? String, nil)
                            print("error saving user")
                            print(error!)
                        }
                        
                    })
                }
            })
            return
        }
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                // Handle Errors
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
            } else if user != nil {
                print("CHASE: Succesffully authenticated with Firebase")
                DataService.ds.createFirebaseDBUser(provider: PROVIDER_FACEBOOK_DB_STRING, user: user, error: error)
                onComplete!(nil, user)
            }
        })
    }
    
    func firebaseGoogleLogin(_ credential: FIRAuthCredential, onComplete: Completion?) {
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                // Handle Errors
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
            } else if user != nil {
                print("CHASE: Succesffully authenticated with Firebase")
                DataService.ds.createFirebaseDBUser(provider: PROVIDER_GOOGLE_DB_STRING, user: user, error: error)
                onComplete!(nil, user)
            }
            
        }
    }
    
    func createFirebaseUserWithEmail(email: String, password: String, onComplete: Completion?) {
        guard FIRAuth.auth()?.currentUser?.isAnonymous != true else {
            print("merger")
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            FIRAuth.auth()?.currentUser!.link(with: credential, completion: { (user, error) in
                DataService.ds.createFirebaseDBUser(provider: PROVIDER_EMAIL_DB_STRING, user: user, error: error)
                onComplete!(nil, user)
            })
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            DataService.ds.createFirebaseDBUser(provider: PROVIDER_EMAIL_DB_STRING, user: user, error: error)
            onComplete!(nil, user)
        })
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
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email)
                
            } else {
                // successfully logged in
                print("successfully logged in")
                onComplete?(nil, user)
            }
        })
    }
    
    func resetPassword(email: String, onComplete: Completion?) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email)
            }
        })
    }
    
    
    func handleFirebaseError(error: NSError, onComplete: Completion?, email: String?) {
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
