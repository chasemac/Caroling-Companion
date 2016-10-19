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
    @IBOutlet weak var searchBar: UISearchBar!
    
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
            
            cell.configureCell(capTitle!, indexPath: indexPath as NSIndexPath, count: songsF.count)
            


            
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
        let detailVC = segue.destination as! SongLyricsVC
        detailVC.song = (sender as! NSDictionary) as! [AnyHashable : Any] as! [String : String]
    }
    
}





