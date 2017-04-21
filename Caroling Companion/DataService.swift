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
    fileprivate var _REF_SONGS = DB_BASE.child(SONGS_DB_STRING)
    fileprivate var _REF_USERS = DB_BASE.child(USERS_DB_STRING)
    
    
    // Storage References
    fileprivate var _REF_PROFILE_IMAGES = STORAGE_BASE.child(PROFILE_PICS_STORAGE_STRING)
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_SONGS: FIRDatabaseReference {
        return _REF_SONGS
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
