//
//  ShowPlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/22/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class ShowPlaylistVC: SongListTVC {
    
    var playlist: Playlist?
    
    var playListSongKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = playlist!.title
        if playlist != nil {
            loadPlaylistSongKeys()
            loadSongs()
            print(playListSongKeys)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if playlist != nil {
            loadPlaylistSongKeys()
        }
    }
    
    func loadPlaylistSongKeys() {
        DataService.ds.REF_PLAYLISTS.child(self.playlist!.playlistKey).child(DBPlaylistString.songs).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshot)
                for snap in snapshot {
                    let key = snap.key
                    self.playListSongKeys.insert(key, at: 0)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func loadSongs() {
        DataService.ds.REF_SONGS.observe(.value, with: { (snapshot) in
            for songKey in self.playListSongKeys {
                if let snapshot = snapshot.childSnapshot(forPath: songKey) as? FIRDataSnapshot {
                    if let songDict = snapshot.value as? Dictionary<String, AnyObject> {
                       let song = Song(songKey: songKey, songData: songDict)
                        self.songs.insert(song, at: 0)
                    }
                }
            }

        })
    }
    
}
