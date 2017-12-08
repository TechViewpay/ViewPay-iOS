//
//  ArticleTableViewCell.swift
//  Demo
//
//  Created by Thibaut LE LEVIER on 07/12/2017.
//  Copyright © 2017 ViewPay. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var articleImageView: UIImageView?
    @IBOutlet var articleTitleLabel: UILabel?
    var imageURLString: String? {
        didSet {
            if let string = imageURLString, let url = URL(string: string) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, networkError) in
                    if let d = data {
                        
                        DispatchQueue.main.async {
                            self.articleImageView?.image = UIImage(data: d)
                        }
                        
                    }
                }
                
                task.resume()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.articleImageView?.image = nil
        self.articleTitleLabel?.text = nil
    }

}
