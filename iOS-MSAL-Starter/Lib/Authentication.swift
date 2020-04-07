//
//  Authentication.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 8.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import Foundation
import MSAL

public class Authentication {
    static let shared = Authentication()
    private init() {}
    
    var scopes: [Resource: [String]] = [
        .Graph: [
            "User.ReadWrite",
            "User.ReadBasic.All"
        ],
        .SharePoint: [
            "{0}/User.Read.All",
            "{0}/User.ReadWrite.All",
            "{0}/AllSites.Read",
            "{0}/AllSites.Write"
        ]
    ]
    
    private var authority: String = "https://login.microsoftonline.com/common"
    private var clientId: String = ""
    private var tokenDict = [Resource: String]()
    
    var applicationContext: MSALPublicClientApplication?
    
    // MARK: -- Get Token
    // params: Resource => SharePoint | Graph
    // completionHandler => status: Bool
    func getToken(resource: Resource, completionHandler: @escaping(Bool)->()) {
        
    }
    
    // MARK: -- Get Token From Cache
    func getCachedToken(resource: Resource) -> String? {
        return self.tokenDict[resource]
    }
}
