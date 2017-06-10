//
//  SelectLoginMethod.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class SelectLoginMethod: UIViewController {
    
    @IBOutlet weak var instructionLbl: UILabel!
    var signup: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var text = ""
        if signup == true {
            text = "Sign Up"
        } else {
            text = "Log In"
        }
        instructionLbl.text = "Please select your \(text) method"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailLoginVC" {
            let detailVC = segue.destination.contents as! EmailLoginVC
            detailVC.signup = sender as! Bool
        } else if segue.identifier == "PhoneLoginVC" {
            let detailVC = segue.destination.contents as! PhoneLoginVC
            detailVC.signup = sender as! Bool
        }
    }
    
    @IBAction func emailBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "EmailLoginVC", sender: signup)
    }
    
    @IBAction func phoneBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PhoneLoginVC", sender: signup)
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
