//
//  Repository.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import Foundation

struct Repository: Codable {
    
    let id : Int
    let name: String
    let owner: Owner
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case url
    }
}
