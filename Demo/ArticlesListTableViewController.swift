//
//  ArticlesListTableViewController.swift
//  Demo
//
//  Created by Thibaut LE LEVIER on 07/12/2017.
//  Copyright © 2017 ViewPay. All rights reserved.
//

import UIKit

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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow!
        (segue.destination as! ArticleViewController).urlString = self.articles[indexPath.row]["content_url"]
    }

}
