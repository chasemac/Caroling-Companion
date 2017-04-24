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
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("Logged in user UID ------> \(FIRAuth.auth()?.currentUser!.uid as Any)")
        } else {
            print("no current user")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DataService.ds.REF_SONGS.observe(.value, with: { (snapshot) in
            self.songs = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let songDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let song = Song(songKey: key, postData: songDict)
                        self.songs.insert(song, at: 0)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard FIRAuth.auth()?.currentUser != nil else {
        //    performSegue(withIdentifier: "LoginVC", sender: nil)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        
        // Dequeue cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell {
            
            cell.configureCell(song, indexPath: indexPath as NSIndexPath)
            
            return cell
        } else {
            print("error")
            return SongCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let song = songs[indexPath.row]
        
        self.performSegue(withIdentifier: "detailSegue", sender: song)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! SongLyricsVC
            detailVC.song = sender as! Song
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .lightGray
        
        //        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
        //            print("share button tapped")
        //        }
        //        share.backgroundColor = .blue
        //
        //        return [share, favorite]
        
        return [favorite]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func singOut() {
        self.performSegue(withIdentifier: "LoginVC", sender: nil)
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
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





