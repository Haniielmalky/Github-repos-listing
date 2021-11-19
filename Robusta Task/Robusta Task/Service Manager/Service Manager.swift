//
//  Service Manager.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import Foundation

// MARK: - BaseURL Components

let scheme = "https"
let hostName  = "api.github.com"
let baseUrl  = "\(scheme)://\(hostName)/"

// MARK: - Pathes

enum Path : String {
    
    // General
    case repos = "repositories"
    
}
