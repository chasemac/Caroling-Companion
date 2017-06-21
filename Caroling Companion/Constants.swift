//
//  Constants.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 4/28/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0
let SHADOW_GRAY: CGFloat = 120.0 / 255.0
let softGreen = UIColor(red: 0.467, green: 0.600, blue: 0.424, alpha: 1.00)
let darkRed = UIColor(red: 0.718, green: 0.310, blue: 0.310, alpha: 1.00)
let softRed = UIColor(red: 0.882, green: 0.471, blue: 0.471, alpha: 1.00)

let christmasRed = UIColor(red:0.72, green:0.31, blue:0.31, alpha:1.0)
let christmasGreen = UIColor(red:0.47, green:0.60, blue:0.42, alpha:1.0)
let christmasWhite = UIColor(red:0.99, green:0.99, blue:0.96, alpha:1.0)

let YOUTUBE_URL: String = "https://www.youtube.com/embed/"
let USER_DOES_NOT_EXIST = "User Does Not Exist"
let SegueToSongListVC = "SongListVC"

let KEY_UID = "uid"

// MARK: ENVIRONMENT
struct DBEnvironment {
    static let production = "production"
    static let staging = "staging"
}

// MARK: DATABASE
struct DBTopLevel {
    static let songs = "songs"
    static let users = "users"
    static let playlists = "playlists"
}

// Data Base Song Strings
struct DBSongString {
    static let title = "title"
    static let titleSearch = "titleSearch"
    static let lyrics = "lyrics"
    static let videoURL = "video"
    static let favorites = "favorites"
    static let user = "user"
    static let postedDate = "postedDate"
}

// Users
struct DBUserString {
    static let username = "username"
    static let name = "name"
    static let profileImageURL = "profileImageURL"
    static let providerProfileImageURL = "providerProfileImageURL"
    static let provider = "provider"
    static let email = "email"
    static let favorites = "favorites"
    static let phoneNumber = "phoneNumber"
}

// Playlist
struct DBPlaylistString {
    static let user = "user"
    static let songs = "songs"
    static let title = "title"
    static let postedDate = "postedDate"
}

struct DBProviderString {
    static let anonymous = "anonymous"
    static let facebook = "facebook.com"
    static let phoneNumber = "phoneNumber"
}


// MARK: STORAGE
let PROFILE_PICS_STORAGE_STRING = "profile-pics"
