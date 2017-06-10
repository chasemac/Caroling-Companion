//
//  EmailLoginVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/9/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class EmailLoginVC: LoginFlow {
    var signup: Bool = true

    @IBOutlet weak var iForgotBtn: UIButton!
    
    @IBOutlet weak var loginBtn: OutlineBtn!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
