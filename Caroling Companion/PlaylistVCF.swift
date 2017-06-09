//
//  PlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/15/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PlaylistVCF: UITableViewController {
    
    // MARK: NEW FIREBASE STUFF
    var ref: DatabaseReference!
    var playlistsF: [DataSnapshot]! = []
    fileprivate var playlistF : DataSnapshot!
    fileprivate var _refHandle: DatabaseHandle!
    
    
    override func viewDidLoad() {
        configureDatabase()
        super.viewDidLoad()

    }
    
    func configureDatabase() {
        ref = DataService.ds.REF_PLAYLISTS
        // listen for new messages in the firebase database
        _refHandle = ref.observe(.childAdded) { (snapshot: DataSnapshot)in
            self.playlistsF.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.playlistsF.count-1, section: 0)], with: .automatic)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlistsF.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistNameCell", for: indexPath) as! PlaylistNameCellF
        // unpack message from firebase data snapshot
        let snapshot = playlistsF[indexPath.row]
        let playlist = snapshot.value as! [String: AnyObject]
        let name = playlist[DBPlaylistString.title] ?? "title" as AnyObject
        cell.configureCell(name as AnyObject, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let playlist = playlistsF[indexPath.row]
        print("playlistF ============ \(playlist)")
               self.performSegue(withIdentifier: "showPlaylist", sender: playlist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPlaylist" {
            let detailVC = segue.destination.contents as! ShowPlaylistVC
            detailVC.playlistF = sender as? DataSnapshot
            
            
        } else if segue.identifier == "CreatePlaylist" {
         //   let detailVC = segue.destination.contents as! CreatePlaylistVCF
          //  detailVC.playlistExists = false
        }
    }
    
    @IBAction func createPlaylist(_ sender: Any) {
        
        performSegue(withIdentifier: "CreatePlaylist", sender: nil)
    }
    
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

