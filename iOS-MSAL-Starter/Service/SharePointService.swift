//
//  SharePointService.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 7.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import Foundation
public class SharePointService {
    static let shared = SharePointService()
    private init() {}
    
    private var endPoint: String = "https://\(Globals.tenant).sharepoint.com/sites/\(Globals.siteName)/_api/web/getList('/sites/\(Globals.siteName)/lists/{0}')/Items"
    
    // MARK: Get List Items
    func getListItems(listName: String, completionHandler: @escaping(NSDictionary)->()) {
        let replacedEndpoint = self.getEndpoint(listName: listName)
        
        Connection.shared.request(url: replacedEndpoint, method: .get, resource: .SharePoint, parameters: [:]) { (dict) in
            completionHandler(dict)
        }
    }
    
    private func getEndpoint(listName: String) -> String {
        let replacedEndpoint = self.endPoint.replacingOccurrences(of: "{0}", with: listName)
        
        return replacedEndpoint
    }
}
