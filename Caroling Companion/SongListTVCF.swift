////
////  SongListTVC.swift
////  Caroling Companion
////
////  Created by Chase McElroy on 5/22/17.
////  Copyright © 2017 Chase McElroy. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class SongListTVCF: UITableViewController {
//    
//        fileprivate var _favorites: Int!
//    
//    // MARK: NEW FIREBASE STUFF
//    var ref: FIRDatabaseReference!
//    var songsF: [FIRDataSnapshot]! = []
//    fileprivate var songF : FIRDataSnapshot!
//    fileprivate var _refHandle: FIRDatabaseHandle!
//    fileprivate var query: FIRDatabaseQuery?
//    
//    var favorites: [String] = []
//    
//    var songsLoaded: Bool = false
//    
//    override func viewDidLoad() {
//        configureDatabase()
//        guard FIRAuth.auth()?.currentUser != nil else {
//            performSegue(withIdentifier: "LoginVC", sender: nil)
//            return
//        }
//        super.viewDidLoad()
//        
//        if FIRAuth.auth()?.currentUser?.uid != nil {
//            print("Logged in user UID ------> \(FIRAuth.auth()?.currentUser!.uid as Any)")
//        } else {
//            print("no current user")
//        }
//
//        
//       // loadFavoriteSongKeys()
//    }
//    
//    func loadFavoriteSongKeys() {
//        DataService.ds.REF_USER_CURRENT.child(DBUserString.favorites).observe(.value, with: { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshot {
//                    let key = snap.key
//                    self.favorites.append(key)
//                    
//                }
//                print("------------------\(self.favorites)")
//            }
//            
//        })
//    }
//    
//    func configureDatabase() {
//        ref = DataService.ds.REF_SONGS
//        
//  //      self.query = self.ref.qu
//        
//        // listen for new messages in the firebase database
////        _refHandle = ref.observe(.childAdded) { (snapshot: FIRDataSnapshot)in
////            self.songsF.append(snapshot)
////            self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
////        }
//        let text = "a"
//        DataService.ds.REF_SONGS.queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observe(.value, with: { (snapshot) in
//            print(snapshot)
//            self.songsF.append(snapshot)
//            self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
//        })
//    }
//
//
//    
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.songsF.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Dequeue cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCellF
//        // unpack message from firebase data snapshot
//        let snapshot = songsF[indexPath.row]
//        let song = snapshot.value as! [String: AnyObject]
//        let name = song[DBSongString.title] ?? "no title" as AnyObject
//        cell.configureCell(name as! FIRDataSnapshot, indexPath: indexPath as NSIndexPath)
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let songF = songsF[indexPath.row]
//        
//        self.performSegue(withIdentifier: "detailSegue", sender: songF)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailSegue" {
//            let detailVC = segue.destination as! SongLyricsVC
//            detailVC.songF = sender as? FIRDataSnapshot
//        }
//    }
//    
////    func adjustFavorite(indexPath: IndexPath) {
////        
////        let song = songsF[indexPath.row]
////        let favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.key)
////        
////        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
////            if let _ = snapshot.value as? NSNull {
////                
////                favoriteRef.setValue(true)
////                
////                self.adjustFavorites(true)
////                self.tableView.reloadRows(at: [indexPath], with: .automatic)
////            } else {
////                favoriteRef.removeValue()
////                
////                self.adjustFavorites(false)
////                self.tableView.reloadRows(at: [indexPath], with: .automatic)
////            }
////            
////        })
////    }
//    
////    func adjustFavorites(_ addFavorite: Bool) {
////        if addFavorite {
////            _favorites = _favorites + 1
////        } else {
////            _favorites = _favorites - 1
////        }
////        _refHandle.child(DBSongString.favorites).setValue(_favorites)
////        
////        
////    }
//    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let song = songsF[indexPath.row]
//        let favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.key)
//        
//        
//        
//
//        
//        
//        
//        
//        let favorite = UITableViewRowAction(style: .normal, title: "+ \n Favorite") { action, index in
////            self.adjustFavorite(indexPath: indexPath)
//            
////            favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
////                if let _ = snapshot.value as? NSNull {
////                    favoriteRef.setValue(true)
////                    
////                    song.adjustFavorites(true)
////                    //     favoriteRef.database.persistenceEnabled = true
////                }
//// //               tableView.reloadRows(at: [indexPath], with: .left)
////            })
//        }
//        favorite.backgroundColor = .gray
//        
//        let removeFavorite = UITableViewRowAction(style: .normal, title: "- \n Favorite") { action, index in
//            favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let _ = snapshot.value as? NSNull {
//                    return
//                } else {
//                    favoriteRef.removeValue()
//                    
////                    song.adjustFavorites(false)
//                }
//self.tableView.reloadRows(at: [indexPath], with: .automatic)
//            })
//        }
//        return [favorite, removeFavorite]
//    }
//    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//
//}
