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
    var path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader: String]?
    
    init(method: HTTPMethod, path: String, queryItems: [URLQueryItem]? = nil, headers: [HTTPHeader: String]? = nil) {
        self.httpMethod = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
    }
    
    var url: URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    var urlRequest: URLRequest? {
        return makeUrlRequest()
    }
    
    var allHttpHeaders : [String: String]? {
        var allHeaders : [String: String] = [:]
        guard let headersList = headers else {
            return nil
        }
        
        for header in headersList {
            allHeaders[header.key.rawValue] = header.value
        }
        
        return allHeaders
        
    }
    
    func makeUrlRequest() -> URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = allHttpHeaders
        
        return request
    }
}

// MARK: - HTTP Methods

enum HTTPMethod : String {
    
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    
}

enum HTTPHeader: String {
    case accept = "accept"
}
