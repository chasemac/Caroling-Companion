//
//  PhoneLoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class PhoneLoginVC: LoginFlow {
    var signup: Bool = true

    @IBOutlet weak var phoneNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PhoneLoginCodeVC", sender: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
