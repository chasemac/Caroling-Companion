//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongLyricsVC: UIViewController {
    
    var songF : DataSnapshot!
    
    @IBOutlet weak var songListBtn: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var songTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid != nil {
            print("Logged in user UID ------> \(Auth.auth().currentUser!.uid as Any)")
        } else {
            print("no current user")
        }
        initText()
        print("the almost there one!! ----->>>> \(self.songF)")
        loadSongs(song: self.songF)
        
    }
    
    func loadSongs(song: DataSnapshot) {
        if let songDict = song.value as? [String : AnyObject] {
            let title = songDict[DBSongString.title] as? String ?? "Title Unavailable"
            let lyrics = songDict[DBSongString.lyrics] as? String ?? "Lyrics Unavailable"
            let lyricsSwift = lyrics.replacingOccurrences(of: "<br>", with: "\n")
            txtView.text = lyricsSwift
            songTitle.text = title
        } else {
            txtView.text = "Unable To Load Song"
            songTitle.text = "Song Unavailable"
        }
    }
    
    func initText() {
        txtView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SongLyricsVC.preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    func preferredContentSizeChanged(_ notification: Notification) {
        txtView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func songListBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        songListBtn.backgroundColor = UIColor(red: 0.718, green: 0.310, blue: 0.310, alpha: 1.00)
    }
    
    //    func loadVideo(song: FIRDataSnapshot) {
    //        if let songDict = song.value as? [String : AnyObject] {
    //            let video = songDict[DBSongString.videoURL] as! String!
    //            let youtubeURL = YOUTUBE_URL + video!
    //            videoView.allowsInlineMediaPlayback = true
    //            videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(youtubeURL)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    //        }
    //    }
}
