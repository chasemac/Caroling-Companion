//
//  CreatePlaylistListCell.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/16/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlaylistSongCell: UITableViewCell {
    
    var song: Song!
    var playlistRef: FIRDatabaseReference!
    var favoriteRef: FIRDatabaseReference!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var playlistCheckBox: UIImageView!
    
    func configurePlaylistSongCell(_ song: Song, indexPath: NSIndexPath, playlistKey: String) {
        self.song = song
        
        songNameLabel.text = song.title
        
        if indexPath.row % 3 == 0 {
            self.backgroundColor = softGreen
        } else if
            indexPath.row % 2 == 0 {
            self.backgroundColor = darkRed
        }
        else {
            self.backgroundColor = softRed
        }
        
        addedToPlaylist(playlistKey: playlistKey)
        setFavorite()
    }
    
    func addedToPlaylist(playlistKey: String) {
        playlistRef = DataService.ds.REF_PLAYLISTS.child(playlistKey).child(DBPlaylistString.songs).child(song.songKey)
        playlistRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.playlistCheckBox.image = UIImage(named: "checkbox-empty")
            } else {
                self.playlistCheckBox.image = UIImage(named: "checkbox-filled")
            }
            
        })
    }
    
    func setFavorite() {
        favoriteRef = DataService.ds.REF_USER_CURRENT.child(DBSongString.favorites).child(song.songKey)
        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.starImage.image = UIImage(named: "star-empty")
            } else {
                self.starImage.image = UIImage(named: "star-filled")
            }
        })
    }
}
