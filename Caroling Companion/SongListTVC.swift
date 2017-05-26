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
//class SongListTVC: UITableViewController {
//    
//    
//    var songs = [Song]() {
//        didSet {
//            print(songs.count)
//        }
//    }
//    var favorites: [String] = []
//    
//    var songsLoaded: Bool = false
//    
//    override func viewDidLoad() {
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
//        if songsLoaded != true {
//            print("We got here")
//            loadSongs()
//        }
//        
//        loadFavoriteSongKeys()
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
//    func loadSongs() {
//        DataService.ds.REF_SONGS.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    for snap in snapshot {
//                        if let songDict = snap.value as? Dictionary<String, AnyObject> {
//                            let key = snap.key
//                            let song = Song(songKey: key, songData: songDict)
//                            self.songs.insert(song, at: 0)
//                        }
//                    }
//                    self.songsLoaded = true
//                }
//                self.tableView.reloadData()
//        })
//        
////        DataService.ds.REF_SONGS.observe(.value, with: { (snapshot) in
////            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
////                for snap in snapshot {
////                    if let songDict = snap.value as? Dictionary<String, AnyObject> {
////                        let key = snap.key
////                        let song = Song(songKey: key, songData: songDict)
////                        self.songs.insert(song, at: 0)
////                    }
////                }
////                self.songsLoaded = true
////            }
////            self.tableView.reloadData()
////        })
//    }
//
//    
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.songs.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let song = songs[indexPath.row]
//        
//        // Dequeue cell
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell {
//            
//            cell.configureCell(song, indexPath: indexPath as NSIndexPath)
//            
//            return cell
//        } else {
//            print("error")
//            return SongCell()
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let song = songs[indexPath.row]
//        
//        self.performSegue(withIdentifier: "detailSegue", sender: song)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailSegue" {
//            let detailVC = segue.destination as! SongLyricsVC
//            detailVC.song = sender as? Song
//        }
//    }
//    
//    func adjustFavorite(indexPath: IndexPath) {
//        
//        let song = songs[indexPath.row]
//        let favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.songKey)
//        
//        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                
//                favoriteRef.setValue(true)
//                
//                song.adjustFavorites(true)
//                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//            } else {
//                favoriteRef.removeValue()
//                
//                song.adjustFavorites(false)
//                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//            
//        })
//    }
//    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let song = songs[indexPath.row]
//        let favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.songKey)
//        
//        
//        
//
//        
//        
//        
//        
//        let favorite = UITableViewRowAction(style: .normal, title: "+ \n Favorite") { action, index in
//            self.adjustFavorite(indexPath: indexPath)
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
//                    song.adjustFavorites(false)
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
