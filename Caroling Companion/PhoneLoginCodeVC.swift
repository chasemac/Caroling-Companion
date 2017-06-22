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
    
    @IBOutlet weak var activationCodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
        guard activationCodeField.text != nil else {
            return
        }

        AuthService.instance.loginwithPhoneNumber(verificationCode: activationCodeField.text!) { (errMsg, user) in
            if user != nil {
                self.performSegue(withIdentifier: "SongListVC", sender: nil)
             

            }
        }
    
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

}
