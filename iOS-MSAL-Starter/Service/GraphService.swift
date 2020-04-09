//
//  GraphService.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 7.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import Foundation
public class GraphService {
    static let shared = GraphService()
    private init() {}
    
    private let endPoint: String = "https://graph.microsoft.com/v1.0/"
    
    // MARK: Get User Information
    func getUserInformation(user: String = "me", completionHandler: @escaping(NSDictionary)->()) {
        Connection.shared.request(url: "\(self.endPoint)/\(user)", method: .get, resource: .Graph, parameters: [:]) { (dict) in
            completionHandler(dict)
        }
    }
}
