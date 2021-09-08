//
//  LandingLogin.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/18/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

class LandingLoginVC: UIViewController {
    
    @IBOutlet weak var skipBtn: OutlineBtn!
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserSignedInStatus()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
    }

    
    
    func checkUserSignedInStatus() {
        guard Auth.auth().currentUser != nil else {
            print("NO USER: Need to CREATE ACCOUNT!!!!!!!!!")
            return
        }
        guard Auth.auth().currentUser?.isAnonymous != true else {
            print("USER ANONYMOUS: Need to CREATE ACCOUNT!!!!!!!!!")
            return
        }
        
        print("Account Exists")
        print(Auth.auth().currentUser!.uid)
        self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
        
    }
    
    
    func loginAnonymously() {
        guard Auth.auth().currentUser == nil else {
            print("A current user exists")
            performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            skipBtn.isEnabled = true
            labelView.alpha = 0.0
            return
        }
        AuthService.instance.loginAnonymous { (errMsg, user) in
            print("are we here?")
            self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
            self.skipBtn.isEnabled = true
            self.labelView.alpha = 0.0
            if errMsg != nil {
                setupDefaultAlert(title: "", message: errMsg!, actionTitle: "Ok", VC: self)
                self.skipBtn.isEnabled = true
                self.labelView.alpha = 0.0
                return
            }
            print("here we go")
            if user != nil {
                print("we got here")
                self.performSegue(withIdentifier: SegueToSongListVC, sender: nil)
                self.skipBtn.isEnabled = true
                self.labelView.alpha = 0.0
            }
        }
    }
    
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        skipBtn.isEnabled = false
        labelView.alpha = darkShade
        loginAnonymously()
    }
    

    
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
