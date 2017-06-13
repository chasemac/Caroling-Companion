//
//  AuthService.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/13/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import FirebaseAuth
//import FBSDKCoreKit
import FBSDKLoginKit
//import Google
//import GoogleSignIn

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func loginAnonymous(onComplete: Completion?) {
        Auth.auth().signInAnonymously(completion: { (user, error) in
            if error == nil {
                print("CHASE: Anonymous User authenticated with Firebase")
                DataService.ds.createFirebaseDBUser(provider: DBProviderString.anonymous, user: user, error: error)
                onComplete!(nil, user)
            } else {
                if error != nil {
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
                }
            }
        })
    }
    
    func firebaseFacebookLogin(_ credential: AuthCredential, onComplete: Completion?) {
        guard Auth.auth().currentUser?.isAnonymous != true else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("attenpting to merge \(String(describing: Auth.auth().currentUser?.uid)) with Facebook")
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                    // Handle Errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
                } else {
                    user?.link(with: credential, completion: { (user, error) in
                        print("CHASE: Attempted Link with Firebase")
                        if user != nil {
                            DataService.ds.createFirebaseDBUser(provider: DBProviderString.facebook, user: user, error: error)
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
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
                // Handle Errors
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
            } else if user != nil {
                print("CHASE: Succesffully authenticated with Firebase")
                DataService.ds.createFirebaseDBUser(provider: DBProviderString.facebook, user: user, error: error)
                onComplete!(nil, user)
            }
        })
    }

//    func firebaseGoogleLogin(user: GIDGoogleUser!, error: Error!, onComplete: Completion?) {
////        let userId = user.userID                  // For client-side use only!
////        let idToken = user.authentication.idToken // Safe to send to the server
////        let fullName = user.profile.name
////        let givenName = user.profile.givenName
////        let familyName = user.profile.familyName
////        let email = user.profile.email
//        
//        guard Auth.auth().currentUser?.isAnonymous != true else {
//            guard let authentication = user.authentication else { return }
//            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                              accessToken: authentication.accessToken)
//            print("user connected with google --> Credential: \(credential)")
//            Auth.auth().currentUser!.link(with: credential, completion: { (user, error) in
//                DataService.ds.createFirebaseDBUser(provider: DBProviderString.google, user: user, error: error)
//            })
//            return
//        }
//        if let error = error {
//            print(error)
//            return
//        }
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                          accessToken: authentication.accessToken)
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if error != nil {
//                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
//                // Handle Errors
//                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
//            } else if user != nil {
//                print("CHASE: Succesffully authenticated with Firebase")
//                DataService.ds.createFirebaseDBUser(provider: DBProviderString.google, user: user, error: error)
//                onComplete!(nil, user)
//            }
//            
//        }
//
//    }

    
    func createFirebaseUserWithEmail(email: String, password: String, onComplete: Completion?) {
        guard Auth.auth().currentUser?.isAnonymous != true else {
            print("merger")
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            Auth.auth().currentUser!.link(with: credential, completion: { (user, error) in
                DataService.ds.createFirebaseDBUser(provider: DBProviderString.email, user: user, error: error)
                onComplete!(nil, user)
            })
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            DataService.ds.createFirebaseDBUser(provider: DBProviderString.email, user: user, error: error)
            onComplete!(nil, user)
        })

    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email)
            } else {
                print("successfully logged in")
                onComplete?(nil, user)
            }
        })
    }
    
    func resetPassword(email: String, onComplete: Completion?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: email)
            }
        })
    }
    
    
    func handleFirebaseError(error: NSError, onComplete: Completion?, email: String?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch (errorCode) {
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
            case .wrongPassword:
                onComplete?("Invalid password", nil)
            case .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
            case .userNotFound:
                onComplete?(USER_DOES_NOT_EXIST, nil)
            case .emailAlreadyInUse:
                onComplete?("An account was previously created with your Facebook's email address, please click the email button and sign in using your email address and password", nil)
                print("in use")
            case .tooManyRequests:
                onComplete?("Too many requests", nil)
                print("too many email attemps")
            case .appNotAuthorized:
                onComplete?("Account not Authorized", nil)
                print("app not authorized")
            case .networkError:
                onComplete?("Unable to connect to the internet!", nil)
                print("network error")
            default:
                onComplete?("There was a problem authenticating, Try again", nil)
            }
        }
    }
}
