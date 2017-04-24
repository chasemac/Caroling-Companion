//
//  ProfileVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/23/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("Logged in user UID ------> \(String(describing: FIRAuth.auth()?.currentUser!.uid))")
            uidLabel.text = FIRAuth.auth()?.currentUser!.uid
        } else {
            print("no current user")
        }
        
        if FIRAuth.auth()?.currentUser?.displayName != nil {
            print("displayName ------> \(String(describing: FIRAuth.auth()?.currentUser!.displayName!))")
            nameLabel.text = FIRAuth.auth()?.currentUser!.displayName!
        } else {
            print("no current name")
        }
        
        if FIRAuth.auth()?.currentUser?.email != nil {
            print("email ------> \(String(describing: FIRAuth.auth()?.currentUser!.email!))")
            emailLabel.text = FIRAuth.auth()?.currentUser!.email!
        } else {
            print("no current email")
        }
        
        if FIRAuth.auth()?.currentUser?.providerID != nil {
            print("providerID ------> \(String(describing: FIRAuth.auth()?.currentUser!.providerID))")
            providerLabel.text = FIRAuth.auth()?.currentUser!.providerID
        } else {
            print("no current email")
        }

        
    }


    
    @IBAction func unlinkBtnTapped(_ sender: Any) {
        
    print(FIRAuth.auth()?.currentUser?.providerData.count as Any)
        
        print(FIRAuth.auth()?.currentUser?.providerID as Any)
        
        let providerID = "facebook.com"
    //    let providerID = FIRAuth.auth()?.currentUser?.providerID
    
        FIRAuth.auth()?.currentUser?.unlink(fromProvider: providerID) { (user, error) in
            if error != nil {
                print("success")
                print(FIRAuth.auth()?.currentUser?.providerData.count)
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try  FIRAuth.auth()?.signOut()
            print("Logged Out")
        } catch {
            print("failed"  )
        }
    }
}
