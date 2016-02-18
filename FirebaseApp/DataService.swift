//
//  DataService.swift
//  FirebaseApp
//
//  Created by Nick on 2/18/16.
//  Copyright © 2016 Nicholas Smith. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://ios-firebaseapp.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}