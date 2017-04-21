//
//  DataService.swift
//
//
//  Created by Chase McElroy on 3/23/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import Firebase
// import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB References
    fileprivate var _REF_BASE = DB_BASE
    fileprivate var _REF_POSTS = DB_BASE.child(POSTS_DB_STRING)
    fileprivate var _REF_USERS = DB_BASE.child(USERS_DB_STRING)
    
    
    // Storage References
    fileprivate var _REF_POST_IMAGES = STORAGE_BASE.child(POST_PICS_STORAGE_STRING)
    fileprivate var _REF_PROFILE_IMAGES = STORAGE_BASE.child(PROFILE_PICS_STORAGE_STRING)
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
//    var REF_USER_CURRENT: FIRDatabaseReference {
////        let uid = KeychainWrapper.stringForKey(KEY_UID)
////        // ------> Fix this later! don't force unwrap
////        let user = REF_USERS.child(uid!)
////        return user
//    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }

    
    func createFirebaseDBUser(_ uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
//    func setTextFieldToDataBaseText(_ DBRef: String, textField: UITextField) {
//        REF_USER_CURRENT.child(DBRef).observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.value != nil {
//                textField.text = snapshot.value! as? String
//            }
//        })
//    }
    
}
