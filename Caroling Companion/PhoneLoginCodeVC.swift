//
//  PhoneLoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class PhoneLoginCodeVC: LoginFlow {
    var signup: Bool = true

    @IBOutlet weak var activationCodeField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

}
