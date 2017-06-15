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
        
        
//                guard Auth.auth().currentUser == nil else {
//                    self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
//                    return
//                }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserSignedInStatus()
    }
    
    func checkUserSignedInStatus() {
        if let user = Auth.auth().currentUser {
            if user.email == nil && user.phoneNumber == nil {
                print("Anonymous")
            } else {
                print("Account Exists")
                self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            }
        } else {
            print("need to create account")
        }
    }
    

    
    func loginAnonymously() {
        guard Auth.auth().currentUser == nil else {
            print("A current user exists")
            performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            return
        }
        AuthService.instance.loginAnonymous { (errMsg, user) in
            print("are we here?")
            self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            if errMsg != nil {
                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                return
            }
            print("here we go")
            if user != nil {
                print("we got here")
                self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logIn" {
            let detailVC = segue.destination.contents as! SelectLoginMethodVC
        //    detailVC.signup = false
            detailVC.signup = sender as! Bool
        } else if segue.identifier == "signUp" {
            let detailVC = segue.destination.contents as! SelectLoginMethodVC
        //    detailVC.signup = true
            detailVC.signup = sender as! Bool
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let signup = true
        performSegue(withIdentifier: "logIn", sender: signup)
    }
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        let signup = false
        performSegue(withIdentifier: "signUp", sender: signup)
    }
    
    

    @IBAction func skipBtnPressed(_ sender: Any) {
        loginAnonymously()
    }
    
}
