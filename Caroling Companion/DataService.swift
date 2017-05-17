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
    fileprivate var _REF_SONGS = DB_BASE.child(DBTopLevel.songs)
    fileprivate var _REF_USERS = DB_BASE.child(DBTopLevel.users)
    fileprivate var _REF_PLYLISTS = DB_BASE.child(DBTopLevel.playlists)
    
    
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
    
    var REF_PLAYLISTS: FIRDatabaseReference {
        return _REF_PLYLISTS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    
    
    func createFirebaseDBUser(provider: String, user: FIRUser?, error: Error?) {
        guard user != nil else {
            print("User does not exist, error saving user")
            return
        }
        
        if user!.photoURL != nil {
            print(user!.providerID)
            print(provider)
            
            let userData = [DBUserString.provider: provider,
                            DBUserString.email: user!.email!,
                            DBUserString.name: user!.displayName!,
                            DBUserString.providerProfileImageURL: user!.photoURL!.absoluteString as String]
            REF_USERS.child(user!.uid).updateChildValues(userData)
        } else if user!.email != nil, user?.displayName != nil {
            let userData = [DBUserString.provider: provider,
                            DBUserString.name: user!.displayName!,
                            DBUserString.email: user!.email!]
            REF_USERS.child(user!.uid).updateChildValues(userData)
        } else if user!.email != nil {
            let userData = [DBUserString.provider: provider,
                            DBUserString.email: user!.email!]
            REF_USERS.child(user!.uid).updateChildValues(userData)
            
        } else {
            let userData = [DBUserString.provider: provider]
            REF_USERS.child(user!.uid).updateChildValues(userData)
        }
    }
    
//    func setTextFieldToDataBaseText(_ DBRef: String, textField: UITextField) {
//        REF_USER_CURRENT.child(DBRef).observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.value != nil {
//                textField.text = snapshot.value! as? String
//            }
//        })
//    }
    
}
