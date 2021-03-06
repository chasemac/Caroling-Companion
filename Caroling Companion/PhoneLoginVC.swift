//
//  PhoneLoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneLoginVC: LoginFlow {
    var signup: Bool = true
    var phoneNumber: String?
    var darkShade: CGFloat = 0.8
    var labelView: UILabel!

    @IBOutlet weak var nextBtn: OutlineBtn!
    @IBOutlet weak var phoneNumberField: UITextField!

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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
    }
    
    @IBAction func numberPressed(_ sender: UITextField) {
        phoneNumber = sender.text!
   //     phoneNumberField.text = format(phoneNumber: phoneNumber!) ?? phoneNumber
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        nextBtn.isEnabled = false
        labelView.alpha = darkShade
//        if phoneNumber != nil {
//
//            PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumber!)", uiDelegate: ) { (verificationID, error) in
//                if let error = error {
//                    print("tried to verify and got this error --------> \(error.localizedDescription)")
//                    self.nextBtn.isEnabled = true
//                    self.labelView.alpha = 0
//                    setupDefaultAlert(title: "", message: error.localizedDescription, actionTitle: "OK", VC: self)
//
//                    return
//                }
//                // Sign in using the verificationID and the code sent to the user
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//
//                self.performSegue(withIdentifier: "PhoneLoginCodeVC", sender: nil)
//                self.nextBtn.isEnabled = true
//                self.labelView.alpha = 0
//            }
//
//        }


    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
    print("back pressed")
        self.navigationController?.popViewController(animated: true)

    }
    

}

func format(phoneNumber sourcePhoneNumber: String) -> String? {
    
    // Remove any character that is not a number
    let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let length = numbersOnly.characters.count
    let hasLeadingOne = numbersOnly.hasPrefix("1")
    
    // Check for supported phone number length
    guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
        return nil
    }
    
    let hasAreaCode = (length >= 10)
    var sourceIndex = 0
    
    // Leading 1
    var leadingOne = ""
    if hasLeadingOne {
        leadingOne = "1 "
        sourceIndex += 1
    }
    
    // Area code
    var areaCode = ""
    if hasAreaCode {
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
            return nil
        }
        areaCode = String(format: "(%@) ", areaCodeSubstring)
        sourceIndex += areaCodeLength
    }
    
    // Prefix, 3 characters
    let prefixLength = 3
    guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
        return nil
    }
    sourceIndex += prefixLength
    
    // Suffix, 4 characters
    let suffixLength = 4
    guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
        return nil
    }
    
    return leadingOne + areaCode + prefix + "-" + suffix
}

extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
