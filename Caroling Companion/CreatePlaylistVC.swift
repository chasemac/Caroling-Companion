//
//  CreatePlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/15/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class CreatePlaylistVC: UITableViewController {
    
    var songs = [Song]()
    var playlist: Playlist?
    var playlistExists: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if playlistExists != true {
            createPlaylist()
            loadSongs()
        } else {
            loadSongs()
            if playlist!.title != nil {
                navigationItem.title = playlist!.title
            }
        }
    }
    
    func loadSongs() {
        DataService.ds.REF_SONGS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let songDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let song = Song(songKey: key, songData: songDict)
                        
                        self.songs.insert(song, at: 0)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        let playlistRef = DataService.ds.REF_PLAYLISTS.child(self.playlist!.playlistKey).child(DBPlaylistString.songs).child(song.songKey)
        
        playlistRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                playlistRef.setValue(true)
            } else {
                playlistRef.removeValue()
            }
            
            tableView.reloadRows(at: [indexPath], with: .fade)
        })
        return
    }
    
    
    
    func createPlaylist() {
        let newPlaylist : Dictionary<String, Any> = [
            DBPlaylistString.user : FIRAuth.auth()?.currentUser?.uid as AnyObject,
            DBPlaylistString.postedDate : FIRServerValue.timestamp() as AnyObject
        ]
        let firebasePlaylist = DataService.ds.REF_PLAYLISTS.childByAutoId()
        firebasePlaylist.setValue(newPlaylist)
        self.playlist = Playlist(playlistKey: firebasePlaylist.key)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        // Dequeue cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistSongCell", for: indexPath) as? PlaylistSongCell {
            cell.configurePlaylistSongCell(song, indexPath: indexPath as NSIndexPath, playlistKey: self.playlist!.playlistKey)
            return cell
        } else {
            print("error")
            return PlaylistSongCell()
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if playlist?.title != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
           savePlaylistName()
        }
    }
    
    private func savePlaylistName() {
        
        let alert = UIAlertController(title: "Name the Playlist", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let titleRef = DataService.ds.REF_PLAYLISTS.child(self.playlist!.playlistKey).child(DBPlaylistString.title)

            let title = alert.textFields?.first?.text
            
            titleRef.setValue(title)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addTextField { (textField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.clearButtonMode = .whileEditing
            textField.placeholder = "Example: Best Songs"
            textField.autocapitalizationType = .words
        }
        present(alert, animated: true)
        
    }

    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        let playlistRef = DataService.ds.REF_PLAYLISTS.child(self.playlist!.playlistKey).child(DBPlaylistString.title)
        
        playlistRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                DataService.ds.REF_PLAYLISTS.child(self.playlist!.playlistKey).removeValue()
            }
        })
        dismiss(animated: true, completion: nil)
        print("tried to dismiss")
    }
    
}
