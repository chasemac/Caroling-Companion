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
