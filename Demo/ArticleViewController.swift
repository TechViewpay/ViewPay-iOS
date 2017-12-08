//
//  ArticleViewController.swift
//  Demo
//
//  Created by Thibaut LE LEVIER on 08/12/2017.
//  Copyright © 2017 ViewPay. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView?
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let string = self.urlString, let url = URL(string: string) {
            self.webView?.loadRequest(URLRequest(url: url))
        }
    }
}
