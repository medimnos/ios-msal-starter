//
//  AuthViewController.swift
//  iOS-MSAL-Starter
//
//  Created by Uğur Uğurlu on 8.04.2020.
//  Copyright © 2020 Ugur Ugurlu. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginDelegate(_ sender: UIButton) {
        Authentication.shared.getToken(resource: .Graph, viewController: self) { (isAuth) in
            if isAuth {
                let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.setViewControllers([view], animated: true)
            }
        }
    }
    
}
