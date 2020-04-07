//
//  Connection.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 7.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import Foundation
import Alamofire

public class Connection {
    static let shared = Connection()
    private init() {}
    
    // MARK: -- Async Request
    func request(url: String, method: HTTPMethod = .post, resource: Resource, parameters: [String: AnyObject], completionHandler: @escaping(NSDictionary)->()) {

        var token: String = ""
        
        // get token from cache
        if let resourceToken = Authentication.shared.getCachedToken(resource: resource) {
            token = resourceToken
        }
        
        let defaultHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        //set parameter encoding
        //defaut: JSONEncoding.default
        var encoding: ParameterEncoding = JSONEncoding.default
        if method == .get {
            encoding = URLEncoding.default
        }
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: defaultHeaders).responseData { (response) in
            if let rawData = response.data {
                do {
                    //serialize raw data
                    if let data = try JSONSerialization.jsonObject(with: rawData, options: .allowFragments) as? NSDictionary {
                        completionHandler(data)
                    }
                }catch let err as NSError {
                    print(err.debugDescription)
                    completionHandler(["error": true])
                }
            }
        }
    }
}
