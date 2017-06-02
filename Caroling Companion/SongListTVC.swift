//
//  SongListTVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class SongListTVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var text = ""
    var favorites: [String] = []
    
    // MARK: NEW FIREBASE STUFF
    fileprivate var ref: FIRDatabaseReference!
    var favRef: FIRDatabaseReference!
    var songsF: [FIRDataSnapshot]! = []
    fileprivate var query: FIRDatabaseQuery?
    
    override func viewDidLoad() {
        guard FIRAuth.auth()?.currentUser != nil else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        }
        configureDatabase()
        
        super.viewDidLoad()
        print("Logged in user UID ------> \(FIRAuth.auth()?.currentUser!.uid as Any)")
        
        textField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func configureDatabase() {
        favorites.removeAll()
        loadFavoriteSongKeys()
        text = textField.text!
        songsF = []
        // not lowercasing
        let lowercaseText = text
        self.ref = DataService.ds.REF_SONGS
        if text != "" {
            self.query = ref.queryOrdered(byChild: DBSongString.title).queryStarting(atValue: lowercaseText).queryEnding(atValue: lowercaseText+"\u{f8ff}")
        } else {
            self.query = ref.queryOrdered(byChild: DBSongString.title)
        }
        
        self.query?.observe(.value, with: { (snapshot) in
            
            for snap in snapshot.children {
                let song = snap as! FIRDataSnapshot
                self.songsF.append(song)
                self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
            }
            self.query?.removeAllObservers()
            
        })
        tableView.reloadData()
        
    }
    
    func loadFavoriteSongKeys() {
        favRef = DataService.ds.REF_USER_CURRENT.child(DBUserString.favorites)
        favRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    let key = snap.key
                    self.favorites.append(key)
                    
                }
                print("------------------\(self.favorites)")
            }
            self.favRef.removeAllObservers()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsF.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCellF
        
        
        let snapshot = songsF[indexPath.row]
        print("the snap one!! ----->>>> \(snapshot)")
        cell.configureCell(snapshot, indexPath: indexPath as NSIndexPath, playlistKey: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let song = songsF[indexPath.row]
        print("the 1 one!! ----->>>> \(song)")
        performSegue(withIdentifier: "detailSegue", sender: song)
        //      self.performSegue(withIdentifier: "detailSegue", sender: song)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
            let detailVC = segue.destination as! SongLyricsVC
            detailVC.songF = sender as? FIRDataSnapshot
            
            print("the detail one!! ----->>>> \(detailVC.songF)")
        }
    }
    
    
    @IBAction func editingChange(_ sender: Any) {
        text = textField.text!
        print(text)
        configureDatabase()
    }
    
    func adjustFavorite(indexPath: IndexPath) {
        
        let song = songsF[indexPath.row]
        let favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.key)
        
        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                
                favoriteRef.setValue(true)
                
                //              song.adjustFavorites(true)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                favoriteRef.removeValue()
                
                //               song.adjustFavorites(false)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        })
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let song = songsF[indexPath.row]
        let favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.key)
        
        let favorite = UITableViewRowAction(style: .normal, title: "+ \n Favorite") { action, index in
            self.adjustFavorite(indexPath: indexPath)
            
            //            favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //                if let _ = snapshot.value as? NSNull {
            //                    favoriteRef.setValue(true)
            //
            //                    song.adjustFavorites(true)
            //                    //     favoriteRef.database.persistenceEnabled = true
            //                }
            // //               tableView.reloadRows(at: [indexPath], with: .left)
            //            })
        }
        favorite.backgroundColor = .gray
        
        let removeFavorite = UITableViewRowAction(style: .normal, title: "- \n Favorite") { action, index in
            favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    return
                } else {
                    favoriteRef.removeValue()
                    
                    //            song.adjustFavorites(false)
                }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        return [favorite, removeFavorite]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: KEYBOARD FUNCTIONS
    
    //presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
