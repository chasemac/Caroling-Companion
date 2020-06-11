//
//  AuthService.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/13/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import FirebaseAuth
//import FBSDKLoginKit


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
//                DataService.ds.createFirebaseDBUser(provider: DBProviderString.anonymous, user: user, error: error)
                onComplete!(nil, user)
            } else {
                if error != nil {
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
                }
            }
        })
    }
    
    func loginwithPhoneNumber(verificationCode: String, onComplete: Completion?) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                self.handleFirebaseError(error: error as NSError, onComplete: onComplete, email: "")
                print(error)
                return
            }
            // User is signed in
//            DataService.ds.createFirebaseDBUser(provider: DBProviderString.phoneNumber, user: user, error: error)
//            print("We signed in!!!! ----> UID: \(user!.uid)")
            onComplete!(nil, user)
        }
    }
    
    func firebaseFacebookLogin(_ credential: AuthCredential, onComplete: Completion?) {
//        guard Auth.auth().currentUser?.isAnonymous != true else {
//            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//            print("attenpting to merge \(String(describing: Auth.auth().currentUser?.uid)) with Facebook")
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if error != nil {
//                    print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
//                    // Handle Errors
//                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
//                } else {
//                    user?.link(with: credential, completion: { (user, error) in
//                        print("CHASE: Attempted Link with Firebase")
//                        if user != nil {
//                            DataService.ds.createFirebaseDBUser(provider: DBProviderString.facebook, user: user, error: error)
//                            onComplete!(nil, user)
//                        } else {
//                            onComplete!(error as? String, nil)
//                            print("error saving user")
//                            print(error!)
//                        }
//
//                    })
//                }
//            })
//            return
//        }
//
//        Auth.auth().signIn(with: credential, completion: { (user, error) in
//            if error != nil {
//                print("CHASE: Unable to auth with Firebase - \(String(describing: error))")
//                // Handle Errors
//                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete, email: "")
//            } else if user != nil {
//                print("CHASE: Succesffully authenticated with Firebase")
//                DataService.ds.createFirebaseDBUser(provider: DBProviderString.facebook, user: user, error: error)
//                onComplete!(nil, user)
//            }
//        })
    }
    
//    func createFirebaseUserWithEmail(email: String, password: String, onComplete: Completion?) {
//        guard Auth.auth().currentUser?.isAnonymous != true else {
//            print("merger")
//            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//            Auth.auth().currentUser!.link(with: credential, completion: { (user, error) in
//                DataService.ds.createFirebaseDBUser(provider: DBProviderString.email, user: user, error: error)
//                onComplete!(nil, user)
//            })
//            return
//        }
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//            DataService.ds.createFirebaseDBUser(provider: DBProviderString.email, user: user, error: error)
//            onComplete!(nil, user)
//        })
//
//    }
    
    
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
            case .missingPhoneNumber:
                onComplete?("Please enter your phone number", nil)
                print("Please enter your phone number")
            case .invalidPhoneNumber:
                onComplete?("Please enter a valid phone number", nil)
                print("Please enter a valid phone number")
            case .quotaExceeded:
                onComplete?("Unable to sign in at this time, please try again later", nil)
                print("Thrown if the SMS quota for the Firebase project has been exceeded.")
            case .userDisabled:
                onComplete?("Your user account has been disabled", nil)
                print("Thrown if the user corresponding to the given phone number has been disabled.")
            case .missingVerificationCode:
                onComplete?("Error: Please close app and try the login process again.", nil)
                print("Thrown if the verification code is missing.")
            case .missingVerificationID:
                onComplete?("Error: Please close app and try the login process again.", nil)
                print("Thrown if the verification ID is missing.")
                
            default:
                onComplete?("There was a problem authenticating, Try again", nil)
            }
        }
    }
}
