//
//  PlaylistVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 5/15/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase


class PlaylistVC: UITableViewController {

    var playlists = [Playlist]()
 //   var sendingPlaylist = Playlist(playlistKey: "", playlistData: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        DataService.ds.REF_PLAYLISTS.observe(.value, with: { (snapshot) in
            self.playlists = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let playlistDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let playlist = Playlist(playlistKey: key, playlistData: playlistDict)
                        self.playlists.insert(playlist, at: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
      //      print(self.playlists[0].title)
            print(self.playlists.count)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playlists[indexPath.row]
        // Dequeue cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistNameCell", for: indexPath) as? PlaylistNameCell {
            cell.configureCell(playlist, indexPath: indexPath as NSIndexPath)
            return cell
        } else {
            print("error")
            return PlaylistSongCell()
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        self.performSegue(withIdentifier: "showPlaylist", sender: playlist)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPlaylist" {
            let detailVC = segue.destination.contents as! CreatePlaylistVC
            detailVC.playlist = sender as! Playlist
 //           detailVC.playlistKey =
 //           detailVC.playlistExists = true
 //           detailVC.title =
        }
//        else if segue.identifier == "CreatePlaylist" {
//            let playlist : Dictionary<String, Any> = [
//                DBPlaylistString.user : FIRAuth.auth()?.currentUser?.uid as AnyObject,
//                DBPlaylistString.postedDate : FIRServerValue.timestamp() as AnyObject
//            ]
//            let firebasePlaylist = DataService.ds.REF_PLAYLISTS.childByAutoId()
//            firebasePlaylist.setValue(playlist)
//            let playlistKey = firebasePlaylist.key
//            
//            
//            DataService.ds.REF_PLAYLISTS.child(playlistKey).observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    for snap in snapshot {
//            
//                        if let playlistDict = snap.value as? Dictionary<String, AnyObject> {
//                            let key = snap.key
//                            let playlist = Playlist(playlistKey: key, playlistData: playlistDict)
//                            let detailVC = segue.destination.contents as! CreatePlaylistVC
//                            detailVC.playlist = playlist
//                            self.sendingPlaylist = playlist
//                        }
//                    }
//                }
//                
//
//            })
//        }
    }
    
    @IBAction func createPlaylist(_ sender: Any) {
        
//        performSegue(withIdentifier: "CreatePlaylist", sender: sendingPlaylist)
    }

    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

