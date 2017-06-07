////
////  Playlist.swift
////  Caroling Companion
////
////  Created by Chase McElroy on 5/17/17.
////  Copyright © 2017 Chase McElroy. All rights reserved.
////
// Testing something in Git

//import Foundation
//import FirebaseDatabase
//
////
////  Song.swift
////  Caroling Companion
////
////  Created by Chase McElroy on 4/20/17.
////  Copyright © 2017 Chase McElroy. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//class Playlist {
//    
//    fileprivate var _songs: String!
//    fileprivate var _user: String!
//    fileprivate var _title: String?
//    fileprivate var _playlistKey: String!
//    fileprivate var _playlistRef: FIRDatabaseReference!
//    fileprivate var _postedDate: String!
//    
//    
//    var songs: String {
//        return _songs
//    }
//    
//    var user: String {
//        return _user
//    }
//    
//    var title: String? {
//        return _title
//    }
//    
//    var playlistKey: String {
//        return _playlistKey
//    }
//    
//    
//    var postedDate: String {
//        return _postedDate
//    }
//    
//    
//    init(songs: String, user: String, title: String, postedDate: String) {
//        self._songs = songs
//        self._user = user
//        self._title = title
//        self._postedDate = postedDate
//    }
//    
//    init(playlistKey: String) {
//        self._playlistKey = playlistKey
//    }
//    
//    init(playlistKey: String, playlistData: Dictionary<String, AnyObject>) {
//        
//        self._playlistKey = playlistKey
//        
//        if let songs = playlistData[DBPlaylistString.songs] as? String {
//            self._songs = songs
//        }
//        
//        if let user = playlistData[DBPlaylistString.user] as? String {
//            self._user = user
//        }
//        
//        if let title = playlistData[DBPlaylistString.title] as? String {
//            self._title = title
//        }
//        
//        if let postedDate = playlistData[DBPlaylistString.postedDate] as? String {
//            self._postedDate = postedDate
//        }
//        
//
//        _playlistRef = DataService.ds.REF_PLAYLISTS.child(_playlistKey)
//
//        
//    }
//    
//}
//
//
