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
    private var query: DatabaseQuery?

    private var playlists: [Playlist] = []
    private var newPlaylist: Playlist?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureDatabase()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref.removeAllObservers()
        query?.removeAllObservers()
    }
    
    func configureDatabase() {
        ref = DataService.ds.REF_PLAYLISTS
        query = ref
            .queryOrdered(byChild: DBPlaylistString.user)
            .queryEqual(toValue: DataService.ds.REF_USER_CURRENT.key)
        query?.observe(.value) { (snapshot: DataSnapshot) in
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
        return playlists.isEmpty ? 1 : playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(playlists.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistNameCell", for: indexPath) as! PlaylistNameCellF
        if playlists.isEmpty {
            cell.configurePlaylistNameCell(playlistName: "Create New Playlist!")
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            return cell
        } else {
            let playlist = playlists[indexPath.row]
            let name = playlist.title!
            cell.configurePlaylistNameCell(playlistName: name)
            let backgroundView = UIView()
            backgroundView.backgroundColor = softGreen
            cell.selectedBackgroundView = backgroundView
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = playlists[indexPath.row].id {
                ref.child(id).removeValue()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
                return
            }
        deleteButton.backgroundColor = christmasRed
            return [deleteButton]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if playlists.isEmpty {
            performSegue(withIdentifier: "CreatePlaylist", sender: newPlaylist)
        } else {
            let playlist = playlists[indexPath.row]
            self.performSegue(withIdentifier: "showPlaylist", sender: playlist)
        }
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
