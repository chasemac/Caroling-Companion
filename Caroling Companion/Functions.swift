//
//  Functions.swift
//  SocialApp
//
//  Created by Chase McElroy on 4/5/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

func printCurrentUser() {
    if Auth.auth().currentUser?.uid != nil {
        print("Logged in user UID ------> \(Auth.auth().currentUser!.uid as Any)")
    } else {
        print("no current user")
    }
}
func setupDefaultAlert(title: String, message: String, actionTitle: String, VC: UIViewController) {
    let successfulEmailSentAlertConroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let alrighty = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        
    })
    successfulEmailSentAlertConroller.addAction(alrighty)
    VC.present(successfulEmailSentAlertConroller, animated: true, completion: nil)
}
