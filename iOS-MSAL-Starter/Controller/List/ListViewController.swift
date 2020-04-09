//
//  ListViewController.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 8.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSilentToken()
    }
}

extension ListViewController {
    
    // MARK: -- Get Silent Token From Cache
    private func getSilentToken() {
        Authentication.shared.getToken(resource: .SharePoint, viewController: self) { (isAuth) in
            if isAuth {
                self.getListData()
            }
        }
    }
    
    private func getListData() {
        SharePointService.shared.getListItems(listName: "{list name}") { (result) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                self.textView.text = jsonString
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
