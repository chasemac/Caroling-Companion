//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongLyricsVC: UIViewController {
    
    @IBOutlet weak var songListBtn: UIButton!
    
    var song = Song(lyrics: "", title: "", favorites: 0, userUID: "", postedDate: "")
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var songTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initText()
        
        let title = self.song.title
        let lyrics = self.song.lyrics
        
        let lyricsSwift = lyrics.replacingOccurrences(of: "<br>", with: "\n")
        
        txtView.text = lyricsSwift
        songTitle.text = title
        
//        let video = song[Constants.SongFields.videoUrl] as String!
//        let youtubeURL = YOUTUBE_URL + video!
//        videoView.allowsInlineMediaPlayback = true
//        videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(youtubeURL)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
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
}
