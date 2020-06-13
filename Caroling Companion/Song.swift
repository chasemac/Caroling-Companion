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
    fileprivate var _lyrics: String!
    fileprivate var _title: String!
    fileprivate var _songKey: String!
    fileprivate var _songRef: DatabaseReference!
    fileprivate var _userUID: String!
    fileprivate var _postedDate: String!
    
    var lyrics: String {
        return _lyrics
    }
    
    var title: String {
        return _title
    }
    
    var songKey: String {
        return _songKey
    }
    
    var userUID: String {
        return _userUID
    }
    
    var postedDate: String {
        return _postedDate
    }
    
    init(songKey: String) {
        self._songKey = songKey
    }
    
    
    init(lyrics: String, title: String, userUID: String, postedDate: String) {
        self._lyrics = lyrics
        self._title = title
        self._userUID = userUID
        self._postedDate = postedDate
    }
    
    init(songKey: String, songData: Dictionary<String, AnyObject>) {
        self._songKey = songKey
        
        if let lyrics = songData[DBSongString.lyrics] as? String {
            self._lyrics = lyrics
        }
        
        if let title = songData[DBSongString.title] as? String {
            self._title = title
        }
    
        
        if let userUID = songData[DBSongString.user] as? String {
            self._userUID = userUID
        }
        
        if let postedDate = songData[DBSongString.postedDate] as? String {
            self._postedDate = postedDate
        }
        
        
        _songRef = DataService.ds.REF_SONGS.child(_songKey)
    }
    
}
