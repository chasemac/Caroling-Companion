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
    
    override func configureCell(_ snapshot: FIRDataSnapshot, indexPath: NSIndexPath, playlistKey: String?) {
        super.configureCell(snapshot, indexPath: indexPath, playlistKey: playlistKey)
        addedToPlaylist(playlistKey: playlistKey!, snapshot: snapshot)
    }
    
    func addedToPlaylist(playlistKey: String, snapshot: FIRDataSnapshot) {
        let playlistRef = DataService.ds.REF_PLAYLISTS.child(playlistKey).child(DBPlaylistString.songs).child(snapshot.key)
        playlistRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.playlistCheckBox.image = UIImage(named: "checkbox-empty")
            } else {
                self.playlistCheckBox.image = UIImage(named: "checkbox-filled")
            }
            
        })
    }
    
}
