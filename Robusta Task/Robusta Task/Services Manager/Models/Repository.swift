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
    let fullName: String
    let description: String?
    let creationDate: String?
    let lastUpdateDate: String?
    let language: String?
    let forks : Int?
    let issuesCount: Int?
    let visibility: String?
    let watchers: Int?
    let starCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case fullName = "full_name"
        case creationDate = "created_at"
        case language
        case forks
        case issuesCount = "open_issues"
        case visibility
        case watchers = "subscribers_count"
        case starCount = "stargazers_count"
        case description
        case lastUpdateDate = "updated_at"
    }
}
