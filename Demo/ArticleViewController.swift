//
//  ArticleViewController.swift
//  Demo
//
//  Created by Thibaut LE LEVIER on 08/12/2017.
//  Copyright © 2017 ViewPay. All rights reserved.
//

import UIKit
import ViewPay

class ArticleViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView?
    
    @IBOutlet var payView: UIView?
    @IBOutlet var viewPayButton: UIButton?
    @IBOutlet var loader: UIActivityIndicatorView?
    
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewPayButton?.titleLabel?.numberOfLines = 0
        self.viewPayButton?.titleLabel?.textAlignment = .center
        self.viewPayButton?.isHidden = true
        
        self.loader?.startAnimating()
        
        ViewPay.checkVideo(withContentCategory: "sample") { (success) in
            if (success) {
                self.viewPayButton?.isHidden = false
                self.loader?.stopAnimating()
            }
        }
        
        if let string = self.urlString, let url = URL(string: string) {
            self.webView?.loadRequest(URLRequest(url: url))
        }
    }
    
    @IBAction func payAction(sender :AnyObject) {
        let alertController = UIAlertController(title: "Confirm Your In-App Purchase", message: "Do you want to buy one article product for $0.99?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func payWithViewPayAction(sender :AnyObject) {
        ViewPay.presentAd { (status) in
            if (status == .success) {
                var frame = self.payView!.frame
                frame.origin.y = self.view.frame.height
                UIView.animate(withDuration: 0.2, animations: {
                    self.payView?.frame = frame
                }, completion: { (complete) in
                    self.payView?.removeFromSuperview()
                })
            }
        }
    }
    
    
}
