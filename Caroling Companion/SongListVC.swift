//
//  ViewController.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ref: FIRDatabaseReference!
    private var _refHandle: FIRDatabaseHandle!
    var songsF: [FIRDataSnapshot]! = []
    var songList = [Song]()
    var filteredSongs  = [Song]()
    var inSearchMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        ref = FIRDatabase.database().reference()
        loadSongs()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
    }
    
    func loadSongs() {
        
        self.songsF.removeAll()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("songs").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            

            self.songsF.append(snapshot)
            let songSnapshot: FIRDataSnapshot! = songsF[Song]
            
            for s in self.songsF {
                let song = songSnapshot.value as! Dictionary<String, String>
                
                let title = Song(title: title, lyrics: <#T##String#>, videoUrl: <#T##String#>)
                let lyrics = song[Constants.SongFields.lyrics] as String!
                let video = song[Constants.SongFields.videoUrl] as String!
                self.songList.append(title)
                self.songList.append(lyrics)
                self.songList.append(video)
            }
            
            for _ in snapshot.children{
                let song = Song(snapshot: snapshot)
                self.songList.append(song)
            }
            print(self.songList)

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
        if inSearchMode {
            return filteredSongs.count
        }
        return self.songsF.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        if let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as? SongCell {
            // Unpack message from Firebase DataSnapshot
            
            let songSnapshot: FIRDataSnapshot! = songsF[indexPath.row]
            
//            if inSearchMode {
//                songSnapshot = songsF[indexPath.row]
//            } else {
//                songSnapshot = filteredSongs[indexPath.row]
//            }

            
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text == nil || searchBar.text == "" {
//            inSearchMode = false
//            view.endEditing(true)
//            tableView.reloadData()
//        } else {
//            inSearchMode = true
//
//            let lower = searchBar.text!.lowercaseString
//            filteredSongs = songsF.filter({$0..rangeOfString(lower) != nil})
//            tableView.reloadData()
//        }
//    }
}





