//
//  PhoneLoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneLoginCodeVC: LoginFlow {
    var signup: Bool = true
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    
    @IBOutlet weak var activationCodeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
        guard activationCodeField.text != nil else {
            return
        }
        let verificationCode = activationCodeField.text

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print(error)
                return
            }
            // User is signed in
            // ...
            print("We signed in!!!! ----> UID: \(user!.uid)")
            self.performSegue(withIdentifier: "SongListVC", sender: nil)
        }
    
    
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

}
