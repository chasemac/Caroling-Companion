//
//  SongListTVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class SongListTVC: UITableViewController {
    
    // MARK: NEW FIREBASE STUFF
    fileprivate var ref: DatabaseReference!
    var favRef: DatabaseReference!
    var songsF: [DataSnapshot]! = []
    fileprivate var query: DatabaseQuery?
    
    override func viewDidLoad() {
        configureDatabase()
        
        super.viewDidLoad()
        print("Logged in user UID ------> \(Auth.auth().currentUser!.uid as Any)")
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func configureDatabase() {
        songsF = []
        // not lowercasing
        self.ref = DataService.ds.REF_SONGS
            
        self.query = ref.queryOrdered(byChild: DBSongString.title)
        
        self.query?.observe(.value, with: { (snapshot) in
            
            for snap in snapshot.children {
                let song = snap as! DataSnapshot
                self.songsF.append(song)
                self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
            }
            self.query?.removeAllObservers()
            
        })
        tableView.reloadData()
        
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
        let backgroundView = UIView()
        backgroundView.backgroundColor = softGreen
        cell.selectedBackgroundView = backgroundView
        
        let snapshot = songsF[indexPath.row]
        print("the snap one!! ----->>>> \(snapshot)")
        cell.configureCell(snapshot, indexPath: indexPath as NSIndexPath, playlistKey: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        let song = songsF[indexPath.row]
        print("the 1 one!! ----->>>> \(song)")
        performSegue(withIdentifier: "detailSegue", sender: song)
        //      self.performSegue(withIdentifier: "detailSegue", sender: song)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
            let detailVC = segue.destination as! SongLyricsVC
            detailVC.songF = sender as? DataSnapshot
            
            print("the detail one!! ----->>>> \(String(describing: detailVC.songF))")
        }
    }
    
    
    @IBAction func editingChange(_ sender: Any) {
        configureDatabase()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


