//
//  Song.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/20/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import Firebase

class Song {
    
    //From JSON File
    var lyrics: String!
    var title: String!
    var id: String!
    var inPlaylist: Bool = false
    
    init(data: DataSnapshot) {
        let songData = data.value as! [String: Any]
        
        if let lyrics = songData[DBSongString.lyrics] as? String {
            self.lyrics = lyrics
        }
        
        if let title = songData[DBSongString.title] as? String {
            self.title = title
        }
        
        self.id = data.key
        
    }
    
    init(lyrics: String, title: String, id: String) {
        self.lyrics = lyrics
        self.title = title
        self.id = id
    }
    
}
