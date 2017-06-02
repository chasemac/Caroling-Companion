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
    
    var playlistF: FIRDataSnapshot?
    
    var createdPlaylistKey: String?
    
    var playlistRef: FIRDatabaseReference?
    
    override func viewDidLoad() {
        if playlistF != nil {
            let playlist = playlistF!.value as! [String:Any]
            navigationItem.title = playlist[DBPlaylistString.title] as? String ?? ""
            
        } else {
            createPlaylist()
        }
        super.viewDidLoad()
    }
    
    func createPlaylist() {
        let newPlaylist : Dictionary<String, Any> = [
            DBPlaylistString.user : FIRAuth.auth()?.currentUser?.uid as AnyObject,
            DBPlaylistString.postedDate : FIRServerValue.timestamp() as AnyObject
        ]
        let firebasePlaylist = DataService.ds.REF_PLAYLISTS.childByAutoId()
        createdPlaylistKey = firebasePlaylist.key
        firebasePlaylist.setValue(newPlaylist)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! PlaylistSongCellF
        
        
        let snapshot = songsF[indexPath.row]
        print("the snap one!! ----->>>> \(snapshot)")
        if playlistF != nil {
            cell.configureCell(snapshot, indexPath: indexPath as NSIndexPath, playlistKey: playlistF!.key)
        } else {
            cell.configureCell(snapshot, indexPath: indexPath as NSIndexPath, playlistKey: createdPlaylistKey)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let song = songsF[indexPath.row]
        if playlistF != nil {
            self.playlistRef = DataService.ds.REF_PLAYLISTS.child(self.playlistF!.key).child(DBPlaylistString.songs).child(song.key)
        } else {
            self.playlistRef = DataService.ds.REF_PLAYLISTS.child(self.createdPlaylistKey!).child(DBPlaylistString.songs).child(song.key)
        }
        
        playlistRef!.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.playlistRef!.setValue(true)
            } else {
                self.playlistRef!.removeValue()
            }
            
            tableView.reloadRows(at: [indexPath], with: .fade)
        })
        return
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let playlist = playlistF!.value as! [String:Any]
        let playlistTitle = playlist[DBPlaylistString.title] as? String ?? ""
        if playlistTitle != "" {
            self.dismiss(animated: true, completion: nil)
        } else {
            savePlaylistName()
        }
    }
    
    private func savePlaylistName() {
        
        if playlistF != nil {
            let alert = UIAlertController(title: "Name the Playlist", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                let titleRef = DataService.ds.REF_PLAYLISTS.child(self.playlistF!.key).child(DBPlaylistString.title)
                
                let title = alert.textFields?.first?.text
                
                titleRef.setValue(title)
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addTextField { (textField) in
                textField.keyboardType = .default
                textField.autocorrectionType = .default
                textField.clearButtonMode = .whileEditing
                textField.placeholder = "Example: Best Songs"
                textField.autocapitalizationType = .words
            }
            present(alert, animated: true)
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        if playlistF != nil {
            dismiss(animated: true, completion: nil)
        } else {
            DataService.ds.REF_PLAYLISTS.child(createdPlaylistKey!).removeValue()
            dismiss(animated: true, completion: nil)
            print("tried to dismiss")
        }

    }
    
}
