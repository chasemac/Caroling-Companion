//
//  ViewController.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    var songsF: [FIRDataSnapshot]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        ref = FIRDatabase.database().reference()
        loadSongs()
    }
    
    func loadSongs() {
        
        self.songsF.removeAll()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("songs").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.songsF.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.songsF.count-1, inSection: 0)], withRowAnimation: .Automatic)
            
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.ref.removeObserverWithHandle(_refHandle)
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsF.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        if let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as? SongCell {
            // Unpack message from Firebase DataSnapshot
            let songSnapshot: FIRDataSnapshot! = self.songsF[indexPath.row]
            let song = songSnapshot.value as! Dictionary<String, String>

            let title = song[Constants.SongFields.title] as String!
            
            cell.configureCell(title)
            return cell
        } else {
            print("error")
           return SongCell()
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Unpack message from Firebase DataSnapshot
        let songSnapshot: FIRDataSnapshot! = self.songsF[indexPath.row]
        let song = songSnapshot.value as! Dictionary<String, String>
        
        self.performSegueWithIdentifier("detailSegue", sender: song)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as! SongLyricsVC
        detailVC.song = sender as! NSDictionary
    }
}

