//
//  Constants.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 17.09.2021.
//

import Firebase

// MARK:- Storage

let STORAGE = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE.child("profile_images")

// MARK:- Database

let DB = Database.database(url: "https://udemytwitter-f8e08-default-rtdb.europe-west1.firebasedatabase.app").reference()
let USERS_REF = DB.child("users")

let TWEETS_REF = DB.child("tweets")
let USER_TWEETS_REF = DB.child("user-tweets")
let USER_FOLLOWERS_REF = DB.child("user-followers")
let USER_FOLLOWING_REF = DB.child("user-following")
let TWEET_REPLIES_REF = DB.child("tweet-replies")


