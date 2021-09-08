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
