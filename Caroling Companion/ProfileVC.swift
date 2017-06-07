//
//  ProfileVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/23/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase
import GoogleToolboxForMac
//import GoogleSignIn

class ProfileVC: UIViewController {

    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid != nil {
            print("Logged in user UID ------> \(String(describing: Auth.auth().currentUser!.uid))")
            uidLabel.text = Auth.auth().currentUser!.uid
        } else {
            print("no current user")
        }
        
        if Auth.auth().currentUser?.displayName != nil {
            print("displayName ------> \(String(describing: Auth.auth().currentUser!.displayName!))")
            nameLabel.text = Auth.auth().currentUser!.displayName!
        } else {
            print("no current name")
        }
        
        if Auth.auth().currentUser?.email != nil {
            print("email ------> \(String(describing: Auth.auth().currentUser!.email!))")
            emailLabel.text = Auth.auth().currentUser!.email!
        } else {
            print("no current email")
        }
        
        if Auth.auth().currentUser?.providerID != nil {
            print("providerID ------> \(String(describing: Auth.auth().currentUser!.providerID))")
            providerLabel.text = Auth.auth().currentUser!.providerID
        } else {
            print("no current email")
        }

        
    }


    
    @IBAction func unlinkBtnTapped(_ sender: Any) {
        
    print(Auth.auth().currentUser?.providerData.count as Any)
        
        print(Auth.auth().currentUser?.providerID as Any)
    
        let providerID = "facebook.com"
    //    let providerID = FIRAuth.auth()?.currentUser?.providerID
    
        Auth.auth().currentUser?.unlink(fromProvider: providerID) { (user, error) in
            if error != nil {
                print("success")
                print(Auth.auth().currentUser?.providerData.count as Any)
            }
        }
    }
    
    func singOut() {
        self.performSegue(withIdentifier: "LoginVC", sender: nil)
    }

    
    @IBAction func logoutTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        let destructiveAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            print("Signed Out")
            self.singOut()
        }
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alertController.addAction(destructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        do {
            try  Auth.auth().signOut()
            print("Logged Out")
        } catch {
            print("failed"  )
        }
        
        do {
            try  Auth.auth().signOut()
        } catch {
            print("failed"  )
        }
        

    }
//    @IBAction func diconnectGoogleTapped(_ sender: Any) {
//        GIDSignIn.sharedInstance().disconnect()
//    }
}
