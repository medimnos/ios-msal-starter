//
//  ProfileViewController.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 8.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getSilentToken()
    }
}

extension ProfileViewController {
    
    // MARK: -- Get Silent Token From Cache
    private func getSilentToken() {
        Authentication.shared.getToken(resource: .Graph, viewController: self) { (isAuth) in
            if isAuth {
                self.getUserProfile()
            }
        }
    }
    
    // MARK: -- Get User Profile Information
    private func getUserProfile() {
        GraphService.shared.getUserInformation { (userProfile) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: userProfile, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                self.textView.text = jsonString
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
