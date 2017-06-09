//
//  LandingVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/8/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

class LandingVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func loginAnonymously() {
        guard Auth.auth().currentUser == nil else {
            performSegue(withIdentifier: "SongListVC", sender: nil)
            return
        }
        AuthService.instance.loginAnonymous { (errMsg, user) in
            print("are we here?")
            self.performSegue(withIdentifier: "SongListVC", sender: nil)
            if errMsg != nil {
                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                return
            }
            print("here we go")
            if user != nil {
                print("we got here")
                self.performSegue(withIdentifier: "SongListVC", sender: nil)
            }
        }
        
    }
    @IBAction func skipBtnPressed(_ sender: Any) {
        loginAnonymously()
    }
    
}
