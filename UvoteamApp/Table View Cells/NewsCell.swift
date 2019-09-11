//
//  NewsCell.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/11/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var item: BusinessModel! {
        didSet {
            titleLabel.text = item.title
            descriptionLabel.text = item.description
        }
    }
    
}
