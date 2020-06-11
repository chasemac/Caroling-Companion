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
        checkUserSignedInStatus()
        super.viewDidAppear(true)
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
    
    func createNameChangeRequest(name: String) {
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { (error) in
            if error != nil {
                print(error!)
                setupDefaultAlert(title: "", message: error as! String, actionTitle: "Ok", VC: self)
            }
            print("New Name: \(Auth.auth().currentUser!.displayName!)")
            DataService.ds.REF_USER_CURRENT.child(DBUserString.name).setValue(name)
            self.loadUserInfo()
    })
    }
    
    func checkUserSignedInStatus() {
        guard Auth.auth().currentUser?.isAnonymous != true else {
            performSegue(withIdentifier: "NeedAccountVC", sender: nil)
            return
        }
        print("Account Exists")
    }
    
    func logOut() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)
        let destructiveAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
            (result : UIAlertAction) -> Void in
            //MARK: TODO FIX THIS
            self.dismiss(animated: true, completion: nil)
            //    self.performSegue(withIdentifier: "LandingVC", sender: nil)
            print("Logged Out")
        }
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
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
        saveEdits(textToEdit: "Name", DBUserStringLocal: DBUserString.name)
    }
    
    func saveEdits(textToEdit: String, DBUserStringLocal: String) {

        let alertController = UIAlertController(title: "What is your \(textToEdit)", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { (result: UIAlertAction) in
            let title = alertController.textFields?.first?.text
            if DBUserStringLocal == DBUserString.name {
                self.createNameChangeRequest(name: title!)
            } else {
               DataService.ds.REF_USER_CURRENT.child(DBUserStringLocal).setValue(title)
            }
            self.loadUserInfo()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.addTextField { (textField) in
            if DBUserStringLocal == DBUserString.name {
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            } else if DBUserStringLocal == DBUserString.email {
                textField.keyboardType = .emailAddress
                textField.autocorrectionType = .no
            } else if DBUserStringLocal == DBUserString.phoneNumber {
                textField.keyboardType = .phonePad
            }
            textField.clearButtonMode = .whileEditing
            textField.placeholder = textToEdit
            textField.autocapitalizationType = .words
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func editEmailBtnTapped(_ sender: Any) {
        saveEdits(textToEdit: "Email", DBUserStringLocal: DBUserString.email)
    }
    
    @IBAction func editPhoneNumberTapped(_ sender: Any) {
       saveEdits(textToEdit: "Phone Number", DBUserStringLocal: DBUserString.phoneNumber)
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        logOut()
    }
    @IBAction func AboutBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "AboutVC", sender: nil)
    }
    
    
}
