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
        
    // MARK: FIREBASE STUFF
    private var ref: DatabaseReference!
    
    private var playlists: [Playlist] = []
    
    private var newPlaylist: Playlist?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureDatabase()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.ref.removeAllObservers()
    }
    
    func configureDatabase() {
        ref = DataService.ds.REF_PLAYLISTS
        // listen for new messages in the firebase database
        ref.observe(.value) { (snapshot: DataSnapshot) in
            self.playlists = []
            for snap in snapshot.children {
                let playlistSnap = snap as! DataSnapshot
                let playlist = Playlist(data: playlistSnap)
                self.playlists.append(playlist)
            }
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistNameCell", for: indexPath) as! PlaylistNameCellF
        let playlist = playlists[indexPath.row]
        let name = playlist.title!
        cell.configurePlaylistNameCell(playlistName: name)
        let backgroundView = UIView()
        backgroundView.backgroundColor = softGreen
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        self.performSegue(withIdentifier: "showPlaylist", sender: playlist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPlaylist" {
            let detailVC = segue.destination.contents as! ShowPlaylistVC
            detailVC.playlist = sender as? Playlist
        } else if segue.identifier == "CreatePlaylist" {
            
            let detailVC = segue.destination.contents as! CreatePlaylistVCF
            let playlist : Dictionary<String, Any> = [
                DBPlaylistString.user : Auth.auth().currentUser?.uid as AnyObject,
                DBPlaylistString.postedDate : ServerValue.timestamp() as AnyObject
            ]
            let firebasePlaylist = DataService.ds.REF_PLAYLISTS.childByAutoId()
            firebasePlaylist.setValue(playlist)
            if firebasePlaylist.key != nil {
                newPlaylist = Playlist(id: firebasePlaylist.key!)
                detailVC.playlist = newPlaylist
            }
        }
    }
    
    @IBAction func createPlaylist(_ sender: Any) {
        if newPlaylist != nil {
            performSegue(withIdentifier: "CreatePlaylist", sender: newPlaylist)
        }
    }
}
