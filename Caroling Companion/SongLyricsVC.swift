//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.

import UIKit
import Firebase

class SongLyricsVC: UIViewController {
    
    var song = [String:String]()
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var songTitle: UILabel!
//    @IBOutlet weak var videoView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initText()
        
        let title = song[Constants.SongFields.title] as String!
        let lyrics = song[Constants.SongFields.lyrics] as String!
        
        let lyricsSwift = lyrics?.replacingOccurrences(of: "<br>", with: "\n")
        
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
  
    
}
