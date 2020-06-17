//
//  CreatePlaylistVCF.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/1/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class CreatePlaylistVCF: UITableViewController {
    
    private var ref: DatabaseReference!
    var playlistRef: DatabaseReference?
    private var songsArray: [Song] = []
    var playlist: Playlist!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }
    
    func configureDatabase() {
        let navTitle = playlist!.title!
        navigationItem.title = navTitle.uppercased()
        
        self.ref = DataService.ds.REF_SONGS
        let query = ref.queryOrdered(byChild: DBSongString.title)
        query.observe(.value, with: { (snapshot) in
            for snap in snapshot.children {
                let songSnap = snap as! DataSnapshot
                let song = Song(data: songSnap)
                if self.playlist!.songKeysDict[song.id] != nil {
                    song.inPlaylist = true
                }
                self.songsArray.append(song)
                self.tableView.insertRows(at: [IndexPath(row: self.songsArray.count-1, section: 0)], with: .automatic)
            }
            query.removeAllObservers()
        })
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! PlaylistSongCellF
        let song = songsArray[indexPath.row]
        cell.configureCreatePlaylistSongNameCell(song: song)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songsArray[indexPath.row]
        if playlist!.songKeysDict[song.id!] != nil {
            print("removing: ",song.id!)

            playlist!.songKeysDict[song.id!] = nil
            songsArray[indexPath.row].inPlaylist = false
            tableView.reloadData()
        } else {
            print("adding: ",song.id!)
            playlist!.songKeysDict[song.id!] = true
            songsArray[indexPath.row].inPlaylist = true
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        return
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsArray.count
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let playlistId = playlist!.id!
        guard playlist!.title != NewPlaylistName else {
            savePlaylistName(playlistKey: playlistId)
            return
        }
        let playlistRef = DataService.ds.REF_PLAYLISTS.child(playlistId)
        let songsRef = playlistRef.child(DBPlaylistString.songs)
        songsRef.setValue(self.playlist!.songKeysDict)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func savePlaylistName(playlistKey: String) {
        
            let alert = UIAlertController(title: "Name the Playlist", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                let playlistRef = DataService.ds.REF_PLAYLISTS.child(playlistKey)
                let titleRef = playlistRef.child(DBPlaylistString.title)
                let songsRef = playlistRef.child(DBPlaylistString.songs)
                let title = alert.textFields?.first?.text
                songsRef.setValue(self.playlist!.songKeysDict)
                titleRef.setValue(title)
                self.playlist!.title = title
                self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        if playlist.title != NewPlaylistName {
            self.navigationController?.popViewController(animated: true)
        } else {
            DataService.ds.REF_PLAYLISTS.child(playlist!.id!).removeValue()
            self.navigationController?.popViewController(animated: true)
            print("tried to dismiss")
        }
    }
    
}
