//
//  NewsCell.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/11/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 3
        }
    }

    var item: BasicModel! {
        didSet {
            titleLabel.text = item.title
            descriptionLabel.text = formatDescription(str: item.description)
        }
    }

    private func formatDescription(str: String) -> String {
        var newStr = String()
        for char in str {
            if char == "<" {
                break
            }
            newStr.append(char)
        }
        return newStr
    }
    
}
