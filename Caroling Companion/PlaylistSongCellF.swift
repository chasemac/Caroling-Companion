//
//  PlaylistSongCellF.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/1/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class PlaylistSongCellF: SongCellF {
    
    @IBOutlet weak var playlistCheckBox: UIImageView!
    
    func configureCell(_ snapshot: DataSnapshot, indexPath: NSIndexPath, playlistKey: String?) {
        let song = snapshot.value as! NSDictionary
        let name = song[DBSongString.title] ?? "No Title" as AnyObject
        
        songNameLabel.text = name as? String
        songNameLabel.textColor = .darkGray
        
        self.backgroundColor = christmasWhite
        addedToPlaylist(playlistKey: playlistKey, snapshot: snapshot)
    }
    
    func configureCreatePlaylistSongNameCell(song: Song) {
        
        songNameLabel.text = song.title
        songNameLabel.textColor = .darkGray
        
        self.backgroundColor = christmasWhite
        self.playlistCheckBox.image = UIImage(named: song.inPlaylist ? "deleteCellBtn" : "addPlusBtn")
        
    }
    
    
    func addedToPlaylist(playlistKey: String?, snapshot: DataSnapshot) {
        if playlistKey != nil {
            let playlistRef = DataService.ds.REF_PLAYLISTS.child(playlistKey!).child(DBPlaylistString.songs).child(snapshot.key)
            playlistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.playlistCheckBox.image = UIImage(named: "addPlusBtn")
                } else {
                    self.playlistCheckBox.image = UIImage(named: "deleteCellBtn")
                }
            })
        }
    }
    
}
