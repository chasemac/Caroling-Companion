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

//typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void
//
//func handleFirebaseError(error: NSError, onComplete: Completion?, VC: UIViewController?) {
//    print(error.debugDescription)
//    if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
//        switch (errorCode) {
//        case .errorCodeInvalidEmail:
//            onComplete?("Invalid email address", nil)
//        case .errorCodeWrongPassword:
//            onComplete?("Invalid password", nil)
//        case .errrorCodeAccountExistsWithDifferentCredential, .errorCodeEmailAlreadyInUse:
//            onComplete?("Could not create account. Email already in use", nil)
//        case .errorCodeNetworkError:
//            print("network error")
//            
//            // WORK IN PROGRESS
//            
//            setupDefaultAlert(title: "", message: "Unable to connect to the internet!", actionTitle: "Ok", VC: VC!)
//        default:
//            onComplete?("There was a problem authenticating, Try again", nil)
//        }
//    }
//}
