//
//  ProfileTabVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/14/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileTabVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImg: CircleView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserSignedInStatus()
    }
    
    
    func checkUserSignedInStatus() {
        if let user = Auth.auth().currentUser {
            if user.email == nil && user.phoneNumber == nil {
                print("Anonymous")
                self.performSegue(withIdentifier: "NeedAccountVC", sender: nil)
            } else {
                print("Account Exists")
                
            }
        } else {
            print("need to create account")
            self.performSegue(withIdentifier: "NeedAccountVC", sender: nil)
        }
    }
    
    func signOut() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        let destructiveAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            //MARK: TODO FIX THIS 
            self.dismiss(animated: true, completion: nil)
        //    self.performSegue(withIdentifier: "LandingVC", sender: nil)
            print("Signed Out")
        }
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alertController.addAction(destructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true) { 
//            DispatchQueue.main.sync {
//                self.performSegue(withIdentifier: "NeedAccountVC", sender: nil)
//            }
        }
        
        do {
            try  Auth.auth().signOut()
            print("Logged Out")
            
        } catch {
            print("failed"  )
        }
    }

    
    @IBAction func editEmailBtnTapped(_ sender: Any) {
    }

    @IBAction func editPasswordBtnTapped(_ sender: Any) {
    }
    @IBAction func logOutBtnTapped(_ sender: Any) {
        signOut()
    }
    @IBAction func AboutBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "AboutVC", sender: nil)
    }


}
