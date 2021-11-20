//
//  Owner.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 20/11/2021.
//

import Foundation

struct Owner: Codable {
    
    var id : Int
    var name: String
    var avatarUrl : String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }    
}
