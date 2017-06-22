//
//  ProfileTabVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/14/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileTabVC: UIViewController {
    
    fileprivate var ref: DatabaseReference!
    fileprivate var user: DatabaseReference!
    //   fileprivate var providerInfo: String = ""
    fileprivate let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    
    @IBOutlet weak var profileImg: CircleView!
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var loginMethod: UILabel!
    //Edit Buttons
    @IBOutlet weak var loginMethodEditBtn: UIButton!
    @IBOutlet weak var emailEditBtn: UIButton!
    @IBOutlet weak var phoneNumberEditBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = ""
        ref = DataService.ds.REF_USER_CURRENT
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserSignedInStatus()
        loadUserInfo()
    }
    
    func loadUserInfo() {
        let user = Auth.auth().currentUser!
        nameLabel.text = user.displayName ?? "No Name"
        emailLabel.text = user.email ?? "No Email"
        phoneNumberLabel.text = user.phoneNumber ?? "No Phone #"
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            let userDict = snapshot.value as! NSDictionary
            let email = userDict[DBUserString.email]
            self.emailLabel.text = email as? String ?? "No Email"
            let provider = userDict[DBUserString.provider]
            self.loginMethod.text = provider as? String ?? "No Provider"
            let phone = userDict[DBUserString.phoneNumber]
            self.phoneNumberLabel.text = phone as? String ?? "No Phone #"
            self.hideLabelsAndButtons(provider: provider as! String)
        })
    }
    
    func hideLabelsAndButtons(provider: String) {
        if provider == DBProviderString.facebook {
            loginMethodEditBtn.isHidden = true
            emailEditBtn.isHidden = true
            
        } else if provider == DBProviderString.phoneNumber {
            loginMethodEditBtn.isHidden = true
            phoneNumberEditBtn.isHidden = true
            
        } else {
            print("USER SHOULDN'T GET HERE!!!!!!!!!!")
        }
        
    }
    
    enum profileEditables {
        case name
        case email
        case phoneNumber
    }
    
    func saveEditedText(editable: profileEditables, text: String) {
        let newName = text
        switch editable {
        case .name:
            changeRequest?.displayName = newName
            changeRequest?.commitChanges(completion: { (error) in
                if error != nil {
                    print(error!)
                    setupDefaultAlert(title: "", message: error as! String, actionTitle: "Ok", VC: self)
                }
                print("New Name: \(Auth.auth().currentUser!.displayName!)")
                DataService.ds.REF_USER_CURRENT.child(DBUserString.name).setValue(newName)
                self.loadUserInfo()
            })
        case .phoneNumber:
            DataService.ds.REF_USER_CURRENT.child(DBUserString.phoneNumber).setValue(newName)
        case .email:
            DataService.ds.REF_USER_CURRENT.child(DBUserString.email).setValue(newName)
        }
        self.loadUserInfo()

    }
    
    func checkUserSignedInStatus() {
        guard Auth.auth().currentUser?.isAnonymous != true else {
            performSegue(withIdentifier: "NeedAccountVC", sender: nil)
            return
        }
        print("Account Exists")
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
            
        }
        
        do {
            try  Auth.auth().signOut()
            print("Logged Out")
            
        } catch {
            print("failed"  )
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
    }
    @IBAction func editNameTapped(_ sender: Any) {
        saveEditedText(editable: .name, text: "Hello MYLOVE")
    }
    @IBAction func editEmailBtnTapped(_ sender: Any) {
        saveEditedText(editable: .email, text: "email@whatup.com")
    }
    
    @IBAction func editPhoneNumberTapped(_ sender: Any) {
        saveEditedText(editable: .phoneNumber, text: "779-845-1235")
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        signOut()
    }
    @IBAction func AboutBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "AboutVC", sender: nil)
    }
    
    
}
