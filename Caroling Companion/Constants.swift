//
//  Constants.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/28/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit



let SHADOW_COLOR: CGFloat = 157.0 / 255.0
let YOUTUBE_URL: String = "https://www.youtube.com/embed/"


struct Constants {
    
    struct SongFields {
        static let title = "title"
        static let lyrics = "lyrics"
        static let videoUrl = "video"
    }
}

let SHADOW_GRAY: CGFloat = 120.0 / 255.0

let KEY_UID = "uid"

// MARK: DATABASE
let POSTS_DB_STRING = "posts"
let USERS_DB_STRING = "users"

// Posts
let CAPTION_DB_STRING = "caption"
let IMAGEURL_DB_STRING = "imageUrl"
let LIKES_DB_STRING = "likes"
let USER_DB_STRING = "user"
let POSTED_DATE = "postedDate"

// Users
let USERNAME_DB_STRING = "username"
let NAME_DB_STRING = "name"
let PROFILE_IMAGEURL_DB_STRING = "profileImageURL"
let FACEBOOK_PROFILE_IMAGEURL_DB_STRING = "facebookProfileImageURL"
let PROVIDER_DB_STRING = "provider"
let EMAIL_DB_STRING = "email"



// MARK: STORAGE
let PROFILE_PICS_STORAGE_STRING = "profile-pics"
let POST_PICS_STORAGE_STRING = "post-pics"
