//
//  ViewController.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.
//

import UIKit

class SongListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    var songs: [String] = Array(songsDict.keys).sort { $0 < $1 }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
//    override func viewDidAppear(animated: Bool) {
//        tableView.reloadData()
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as? SongCell {
            let songName = songs[indexPath.row]
            cell.configureCell(songName)
            return cell
        } else {
            print("error")
           return SongCell()
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let songLyrics = songsDict[self.songs[indexPath.row]]
        self.performSegueWithIdentifier("detailSegue", sender: songLyrics)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as! SongLyricsVC
        detailVC.song = sender as! String
        
    }

}

