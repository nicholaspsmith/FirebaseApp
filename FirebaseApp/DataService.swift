//
//  DataService.swift
//  FirebaseApp
//
//  Created by Nick on 2/18/16.
//  Copyright © 2016 Nicholas Smith. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://ios-firebaseapp.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
//    func createPost(uid: String, post: Dictionary<String, String>) {
//        // something like dat
//        REF_POSTS.childByAutoId().setValue(post)
//    }
}