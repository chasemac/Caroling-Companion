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
    
    var playlistF: DataSnapshot?
    var playlistRef: DatabaseReference?
    var createdPlaylistKey: String?
    
    override func viewDidLoad() {
        if playlistF != nil {
            let playlist = playlistF!.value as! [String:Any]
            let navTitle = playlist[DBPlaylistString.title] as? String ?? ""
            navigationItem.title = navTitle.uppercased()
        } else {
            createPlaylist()
        }
        super.viewDidLoad()
    }
    
    func createPlaylist() {
        let newPlaylist : Dictionary<String, Any> = [
            DBPlaylistString.user : Auth.auth().currentUser?.uid as AnyObject,
            DBPlaylistString.postedDate : ServerValue.timestamp() as AnyObject
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
        guard createdPlaylistKey == nil else {
            savePlaylistName(playlistKey: createdPlaylistKey!)
        
            print("Tried to save name")
            
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func savePlaylistName(playlistKey: String) {
        
            let alert = UIAlertController(title: "Name the Playlist", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                let titleRef = DataService.ds.REF_PLAYLISTS.child(playlistKey).child(DBPlaylistString.title)
                
                let title = alert.textFields?.first?.text
                
                titleRef.setValue(title)
                self.navigationController?.popViewController(animated: true)
               
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
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        if playlistF != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            DataService.ds.REF_PLAYLISTS.child(createdPlaylistKey!).removeValue()
            self.navigationController?.popViewController(animated: true)
            print("tried to dismiss")
        }

    }
    
}
