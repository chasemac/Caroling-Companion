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
    fileprivate var _refHandle: FIRDatabaseHandle!
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
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func loadSongs() {
        
        self.songsF.removeAll()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("songs").observe(.childAdded, with: { (snapshot) -> Void in
            

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

            self.tableView.insertRows(at: [IndexPath(row: self.songsF.count-1, section: 0)], with: .automatic)
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: _refHandle)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredSongs.count
        }
        return self.songsF.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell {
            // Unpack message from Firebase DataSnapshot
            
            let songSnapshot: FIRDataSnapshot! = songsF[(indexPath as NSIndexPath).row]
            
//            if inSearchMode {
//                songSnapshot = songsF[indexPath.row]
//            } else {
//                songSnapshot = filteredSongs[indexPath.row]
//            }

            
            let song = songSnapshot.value as! Dictionary<String, String>

                let title = song[Constants.SongFields.title] as String!
            
            cell.configureCell(title!)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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





