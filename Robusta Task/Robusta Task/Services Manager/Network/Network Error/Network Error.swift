//
//  APIErrorManager.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import Foundation

// MARK: - Network Errors

enum NetworkError: Error {
    case invalidRequest
    case response
    case statusCode(Int)
    case data
}

class  NetworkErrorManager {
    
    static let shared = NetworkErrorManager()
    
    func checkForErrors(in response: URLResponse?, error: Error?) -> Error? {
        if let error = error {
            return error
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.response
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            return NetworkError.statusCode(httpResponse.statusCode)
        }
        
        return nil
    }
}
