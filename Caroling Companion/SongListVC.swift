//
//  ViewController.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var songsF: [FIRDataSnapshot]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ref = FIRDatabase.database().reference()
        loadSongs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard FIRAuth.auth()?.currentUser != nil else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let attrs = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName: UIFont(name: "BigJohn", size: 24)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    func loadSongs() {
        
        self.songsF.removeAll()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("songs").observe(.childAdded, with: { (snapshot) -> Void in
            self.songsF.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: _refHandle)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsF.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell {
            // Unpack message from Firebase DataSnapshot
            let songSnapshot: FIRDataSnapshot! = self.songsF[(indexPath as NSIndexPath).row]
            let song = songSnapshot.value as! Dictionary<String, String>
            
            let title = song[Constants.SongFields.title] as String!
            let capTitle = title?.uppercased()
            
            cell.configureCell(capTitle!, indexPath: indexPath as NSIndexPath)
            
            return cell
        } else {
            print("error")
            return SongCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Unpack message from Firebase DataSnapshot
        let songSnapshot: FIRDataSnapshot! = self.songsF[(indexPath as NSIndexPath).row]
        let song = songSnapshot.value as! Dictionary<String, String>
        
        self.performSegue(withIdentifier: "detailSegue", sender: song)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! SongLyricsVC
            detailVC.song = (sender as! NSDictionary) as! [AnyHashable : Any] as! [String : String]
        }

    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
            
        
        }
        favorite.backgroundColor = .lightGray
        
//        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
//            print("more button tapped")
//        }
//        more.backgroundColor = .lightGray
//        
//        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
//            print("share button tapped")
//        }
//        share.backgroundColor = .blue
//        
//        return [share, favorite, more]
        
        return [favorite]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func singOut() {
        self.performSegue(withIdentifier: "LoginVC", sender: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
           try  FIRAuth.auth()?.signOut()
        } catch {
        print("failed"  )
        }
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        let destructiveAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            print("Signed Out")
            self.singOut()
        }
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alertController.addAction(destructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    
}





