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
    
    private let tenant: String = "https://\(Globals.tenant).sharepoint.com"
    private var authority: String = "https://login.microsoftonline.com/\(Globals.tenant).onmicrosoft.com"
    private var tokenDict = [Resource: String]()
    private var accountIdentifier: String!
    
    var applicationContext: MSALPublicClientApplication?
    
    // get scope for resource name
    private func getScopeList(resource: Resource) -> [String] {
        var scopeList = [String]()
        
        if let list = self.scopes[resource] {
            for item in list {
                let result = item.replacingOccurrences(of: "{0}", with: "\(self.tenant)")
                scopeList.append(result)
            }
        }
        
        return scopeList
    }
    
    // MARK: -- Get Token
    // params: Resource => SharePoint | Graph
    // completionHandler => status: Bool
    func getToken(resource: Resource, viewController: UIViewController, completionHandler: @escaping(Bool)->()) {
        if let application = self.createApplication() {
            let webviewParameters = MSALWebviewParameters.init(parentViewController: viewController)
            let interactiveParameters = MSALInteractiveTokenParameters(scopes: self.getScopeList(resource: resource), webviewParameters: webviewParameters)
            interactiveParameters.promptType = .selectAccount
            
            do {
                interactiveParameters.authority = try MSALAuthority(url: URL(string: authority)!)
                if try application.allAccounts().isEmpty {
                    throw NSError.init(domain: "MSALErrorDomain", code: MSALError.interactionRequired.rawValue, userInfo: nil)
                } else {
                    if let identifier = self.accountIdentifier {
                        
                        // get account from cache
                        guard let account = try? application.account(forIdentifier: identifier) else {return}
                        
                        // create silent token parameters
                        let silentTokenParameters = MSALSilentTokenParameters(scopes: self.getScopeList(resource: resource), account: account)
                        silentTokenParameters.authority = try MSALAuthority(url: URL(string: self.authority)!)
                        
                        application.acquireTokenSilent(with: silentTokenParameters) { (result, error) in
                            if error == nil {
                                self.processMSALResult(result: result, error: error, resource: resource, completionHandler: completionHandler)
                            } else {
                                interactiveParameters.promptType = .login
                                self.login(application: application, interactiveParameters: interactiveParameters, resource: resource, completionHandler: completionHandler)
                            }
                        }
                    }else {
                        self.login(application: application, interactiveParameters: interactiveParameters, resource: resource, completionHandler: completionHandler)
                    }
                }
            }  catch let error as NSError {
                if error.code == MSALError.interactionRequired.rawValue {
                    self.login(application: application, interactiveParameters: interactiveParameters, resource: resource, completionHandler: completionHandler)
                }
            } catch {
                print("error")
            }
        }
    }
    
    // MARK: -- Login
    private func login(application: MSALPublicClientApplication, interactiveParameters: MSALInteractiveTokenParameters, resource: Resource, completionHandler: @escaping(_ isAuth: Bool)->()) {
        application.acquireToken(with: interactiveParameters) { (result, error) in
            if error == nil {
                self.processMSALResult(result: result, error: error, resource: resource, completionHandler: completionHandler)
            }else {
                completionHandler(false)
            }
        }
    }
    
    // MARK: -- Process MSAL Result
    private func processMSALResult(result: MSALResult?, error: Error?, resource: Resource, completionHandler: @escaping(Bool)->()) {
        
        guard let _ = result, error == nil else {
            print(error!.localizedDescription)
            completionHandler(false)
            return
        }
        
        if let accessToken = result?.accessToken {
            self.tokenDict[resource] = accessToken
            
            print("Resource: \(resource)")
            print("AccessToken: \(accessToken)")
        }
        
        self.accountIdentifier = result?.account.identifier
        UserDefaults.standard.setValue(result?.account.identifier, forKey: "ACCOUNT_IDENTIFIER")

        completionHandler(true)
    }
    
    // MARK: -- Get Token From Cache
    func getCachedToken(resource: Resource) -> String? {
        return self.tokenDict[resource]
    }
    
    private func createApplication() -> MSALPublicClientApplication? {
        if self.applicationContext == nil {
            let config = MSALPublicClientApplicationConfig(clientId: Globals.clientId)
            if let application = try? MSALPublicClientApplication(configuration: config) {
                self.applicationContext = application
            }
            
            if let identifier = UserDefaults.standard.object(forKey: "ACCOUNT_IDENTIFIER") as? String {
                self.accountIdentifier = identifier
            }
        }
        
        return self.applicationContext
    }
}
