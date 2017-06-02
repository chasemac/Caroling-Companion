//
//  CreatePlaylistVCF.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/1/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase

class CreatePlaylistVCF: SongListTVC {

    var playlistF: FIRDataSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! PlaylistSongCellF
        
        
        let snapshot = songsF[indexPath.row]
        print("the snap one!! ----->>>> \(snapshot)")
        cell.configureCell(snapshot, indexPath: indexPath as NSIndexPath, playlistKey: playlistF.key)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let song = songsF[indexPath.row]
                let playlistRef = DataService.ds.REF_PLAYLISTS.child(self.playlistF.key).child(DBPlaylistString.songs).child(song.key)
                playlistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNull {
                        playlistRef.setValue(true)
                    } else {
                        playlistRef.removeValue()
                    }
        
                    tableView.reloadRows(at: [indexPath], with: .fade)
                })
                return
    }
    
}
