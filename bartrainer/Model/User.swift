//
//  User.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 24/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

struct User: Codable {
    
    public static var currentUser: User?

    var id_user: Int
    var username: String
    var weight: Int
    var height: Int
    var weight_goal: Int
    var exercise_goal: String
    var gender: String
    var friend: Int

    var id_facebook: String
    var img_profile: String
    var password: String
    var email: String
    
    static func save() throws {
        if let currentUser = User.currentUser {
            let encoder = JSONEncoder()
            let userJSON = try encoder.encode(currentUser)
            
            UserDefaults.standard.set(userJSON, forKey: "CURRENT_USER")
        }
    }
    
    static func load() throws {
        if let userJSON = UserDefaults.standard.value(forKey: "CURRENT_USER") as? Foundation.Data {
            let decoder = JSONDecoder()
            
            let user = try decoder.decode(User.self, from: userJSON)
            
            User.currentUser = user
        }
    }

    
}
