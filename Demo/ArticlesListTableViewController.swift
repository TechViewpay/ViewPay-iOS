//
//  ArticlesListTableViewController.swift
//  Demo
//
//  Created by Thibaut LE LEVIER on 07/12/2017.
//  Copyright © 2017 ViewPay. All rights reserved.
//

import UIKit
import ViewPay

class ArticlesListTableViewController: UITableViewController {
    
    var articles = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                
                self.articles = json["articles"] as! [[String:String]]
                
                self.tableView.reloadData()
            } catch {
                
            }
        }

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell

        // Configure the cell...
        cell.articleTitleLabel?.text = self.articles[indexPath.row]["title"]
        cell.imageURLString = self.articles[indexPath.row]["image_url"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewPay.presentAd(withContentCategory: "sample") { (status) in
            if (status == .success) {
                let articleController = self.storyboard?.instantiateViewController(withIdentifier: "articleController") as! ArticleViewController
                articleController.urlString = self.articles[indexPath.row]["content_url"]
                self.navigationController?.pushViewController(articleController, animated: true)
            }
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let indexPath = self.tableView.indexPathForSelectedRow!
//        (segue.destination as! ArticleViewController).urlString = self.articles[indexPath.row]["content_url"]
//    }

}
