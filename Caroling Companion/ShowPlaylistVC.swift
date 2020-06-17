//
//  ShowPlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class ShowPlaylistVC: UITableViewController {
    private var query: DatabaseQuery?
    private var ref: DatabaseReference!
    var playlist: Playlist!
    
    private var songsArray: [Song] = []
    
    var playListSongKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }
    
    func configureDatabase() {
        let navTitle = playlist.title!
        navigationItem.title = navTitle.uppercased()
        
        for (key, _) in playlist.songKeysDict {
            self.loadSongs(key: key)
        }
    }
    
    func loadSongs(key: String) {
        let songRef = DataService.ds.REF_SONGS
        songRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            let song = Song(data: snapshot)
            self.songsArray.append(song)
            self.tableView.insertRows(at: [IndexPath(row: self.songsArray.count-1, section: 0)], with: .automatic)
        })
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlaylist" {
            let detailVC = segue.destination.contents as! CreatePlaylistVCF
            detailVC.playlist = sender as? Playlist
        }
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! SongLyricsVC
            detailVC.song = sender as? Song
        }
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "EditPlaylist", sender: playlist)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songsArray[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: song)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCellF
        let backgroundView = UIView()
        backgroundView.backgroundColor = softGreen
        cell.selectedBackgroundView = backgroundView
        
        let song = songsArray[indexPath.row]
        cell.configureSongNameCell(song: song)
        
        return cell
    }
    
    
    

}
