//
//  NeedAccountVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/15/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class NeedAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "logIn" {
//            let detailVC = segue.destination.contents as! SelectLoginMethodVC
//            //    detailVC.signup = false
//            detailVC.signup = sender as! Bool
//        } else if segue.identifier == "signUp" {
//            let detailVC = segue.destination.contents as! SelectLoginMethodVC
//            //    detailVC.signup = true
//            detailVC.signup = sender as! Bool
//        }
//    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let signup = true
        performSegue(withIdentifier: "logIn", sender: signup)
    }
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        let signup = false
        performSegue(withIdentifier: "signUp", sender: signup)
    }


}
