//
//  Playlist.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/17/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import FirebaseDatabase

//
//  Song.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/20/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation
import Firebase

class Playlist {
    
    fileprivate var _songs: String!
    fileprivate var _user: String!
    fileprivate var _title: String!
    fileprivate var _playlistKey: String!
    fileprivate var _playlistRef: FIRDatabaseReference!
    fileprivate var _userUID: String!
    fileprivate var _postedDate: String!
    
    
    var songs: String {
        return _songs
    }
    
    var user: String {
        return _user
    }
    
    var title: String {
        return _title
    }
    
    var songKey: String {
        return _playlistKey
    }
    
    var userUID: String {
        return _userUID
    }
    
    var postedDate: String {
        return _postedDate
    }
    
    
    init(lyrics: String, user: String, title: String, userUID: String, postedDate: String) {
        self._songs = lyrics
        self._user = user
        self._title = title
        self._userUID = userUID
        self._postedDate = postedDate
    }
    
    init(playlistKey: String, playlistData: Dictionary<String, AnyObject>) {
        self._playlistKey = playlistKey
        
        if let songs = playlistData[DBSongString.lyrics] as? String {
            self._songs = songs
        }
        
        if let user = playlistData[DBSongString.title] as? String {
            self._user = user
        }
        
        if let title = playlistData[DBSongString.title] as? String {
            self._title = title
        }
        
        if let userUID = playlistData[DBSongString.user] as? String {
            self._userUID = userUID
        }
        
        if let postedDate = playlistData[DBSongString.postedDate] as? String {
            self._postedDate = postedDate
        }
        
        
        _playlistRef = DataService.ds.REF_PLAYLISTS.child(_playlistKey)
    }
    
}


