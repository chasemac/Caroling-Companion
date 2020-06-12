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
    @IBOutlet weak var createAccountBtn: OutlineBtn!
    var darkShade: CGFloat = 0.8
    var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView = UILabel(frame: self.view.frame)
        labelView.text = "Loading..."
        labelView.textAlignment = .center
        labelView.font = UIFont(name: "BrandonGrotesque-Black", size: 40)
        labelView.textColor = christmasWhite
        labelView.backgroundColor = UIColor.black
        labelView.alpha = 0
        navigationController?.view.addSubview(labelView)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
        guard activationCodeField.text != nil else {
            return
        }
        self.createAccountBtn.isEnabled = false
        self.labelView.alpha = darkShade

        AuthService.instance.loginwithPhoneNumber(verificationCode: activationCodeField.text!) { (errMsg, user) in
            if user != nil {
                self.performSegue(withIdentifier: "SongListVC", sender: nil)
                self.createAccountBtn.isEnabled = true
                self.labelView.alpha = 0
            }
        }
    
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
