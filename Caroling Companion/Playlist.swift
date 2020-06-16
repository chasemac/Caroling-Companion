//
//  Playlist.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/17/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//
// Testing something in Git


import Foundation
import Firebase

class Playlist {
    var songKeys: [String]!
    var songKeysDict: [String: Bool]
    var title: String!
    var id: String!
    
    init(data: DataSnapshot) {
        var songs: [String] = []
        self.id = data.key
        let playlist = data.value as! NSDictionary
        let name = playlist[DBSongString.title] as? String ?? "No Title"
        let songList = playlist[DBPlaylistString.songs] as? [String: Any] ?? [:]
        var songKeysDict: [String: Bool] = [:]
        for (key, _) in songList {
            songs.append(key)
            songKeysDict[key] = true
        }
        self.songKeysDict = songKeysDict
        self.title = name
        self.songKeys = songs
    }
    
}


