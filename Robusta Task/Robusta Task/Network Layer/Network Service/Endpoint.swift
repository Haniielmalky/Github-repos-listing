//
//  Endpoiny.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import Foundation

// MARK: - Endpoint

struct Endpoint {
    
    var httpMethod: HTTPMethod
    var path: Path
    var queryItems: [URLQueryItem]?
    
    init(method: HTTPMethod, path: Path, queryItems: [URLQueryItem]?) {
        self.httpMethod = method
        self.path = path
        self.queryItems = queryItems
    }
    
    var url: URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path = path.rawValue
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    var urlRequest: URLRequest? {
        return makeUrlRequest()
    }
   
    func makeUrlRequest() -> URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}

// MARK: - HTTP Methods

enum HTTPMethod : String {
    
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    
}
