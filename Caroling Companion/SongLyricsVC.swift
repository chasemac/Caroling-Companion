//
//  SongLyricsVC.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 12/20/15.
//  Copyright © 2015 Chase McElroy. All rights reserved.
//

import UIKit
import Firebase




class SongLyricsVC: UIViewController {
    
    var song = [:]
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var titleTxtView: UITextView!
    @IBOutlet weak var videoView: UIWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       initText()
        
       txtView.text = song[Constants.SongFields.lyrics] as! String!
        titleTxtView.text = song[Constants.SongFields.title] as! String!

        
        let youtubeURL = song[Constants.SongFields.videoUrl] as! String!
        
        videoView.allowsInlineMediaPlayback = true
        
        videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(youtubeURL)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
        

    }
    

    
    func initText() {
        txtView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SongLyricsVC.preferredContentSizeChanged(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        // this bug still exists in iOS 9 --- I don't know if it's still a bug but there's a bug preventing all of this from working right now....
//        txtView.scrollEnabled = false
//        txtView.scrollEnabled = true
//        txtView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    }
    
    func preferredContentSizeChanged(notification: NSNotification) {
        txtView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
    }
  
    
}
