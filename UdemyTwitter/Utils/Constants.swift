//
//  Constants.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 17.09.2021.
//

import Firebase

let DB = Database.database(url: "https://udemytwitter-f8e08-default-rtdb.europe-west1.firebasedatabase.app").reference()
let STORAGE = Storage.storage().reference()

let USERS_REF = DB.child("users")
let STORAGE_PROFILE_IMAGES = STORAGE.child("profile_images")
