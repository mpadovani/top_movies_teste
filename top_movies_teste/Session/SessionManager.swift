//
//  SessionManager.swift
//  top_games
//
//  Created by Mateus Padovani on 10/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

let session = SessionManager.shared

class SessionManager {
    
    static let shared = SessionManager()
    
    private var userDefaults = UserDefaults.standard

    var totalPage: Int {
        set {
            userDefaults.set(newValue, forKey: "totalPage")
        }
        get {
            return userDefaults.integer(forKey: "totalPage")
        }
    }
}
