//
//  NetworkService.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 18/11/2021.
//

import Foundation

class RequestManager {
    
    static let shared = RequestManager()
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    // MARK: - API Request
    
    func request(endpoint: Endpoint, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        // Check for bad requests
        guard let request = endpoint.urlRequest else {
            DispatchQueue.main.async {
                completionHandler(nil, NetworkError.invalidRequest)
            }
            return
        }
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = NetworkErrorManager.shared.checkForErrors(in: response, error: error) {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            
            if let data = data  {
                DispatchQueue.main.async {
                    completionHandler(data, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, NetworkError.data)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Image Loader
    
    func downloadRequest(imageUrl: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        // Check for bad requests
        guard let url = URL(string: imageUrl) else {
            DispatchQueue.main.async {
                completionHandler(nil, NetworkError.invalidRequest)
            }
            return
        }
        
        let task = session.downloadTask(with: url) { ( localUrl: URL?, response: URLResponse?, error: Error? ) in
            
            if let error = NetworkErrorManager.shared.checkForErrors(in: response, error: error) {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            
            guard let localUrl = localUrl else {
                DispatchQueue.main.async {
                    completionHandler(nil, NetworkError.data)
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                DispatchQueue.main.async {
                    completionHandler(data, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            
        }
        task.resume()
    }
}
