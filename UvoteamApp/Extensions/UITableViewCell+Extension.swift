//
//  UITableViewCell+Extension.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/11/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
