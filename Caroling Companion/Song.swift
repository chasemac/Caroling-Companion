//
//  Song.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 7/13/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.

//
//import UIKit
//import Firebase
//
//class Song: NSObject {
//     var title: String!
//     var lyrics: String!
//     var videoUrl: String!
//    let ref: FIRDatabaseReference?
//
//    init(title: String, lyrics: String, videoUrl: String) {
//        self.title = title
//        self.lyrics = lyrics
//        self.videoUrl = videoUrl
//        self.ref = nil
//    }
//    
//    init(snapshot: FIRDataSnapshot) {
//        title = snapshot.value!["title"] as! String
//        lyrics = snapshot.value!["lyrics"] as! String
//        videoUrl = snapshot.value!["video"] as! String
//        ref = snapshot.ref
//    }
//    
//    convenience override init() {
//        self.init(title: "", lyrics: "", videoUrl: "")
//    }
//    
//}
