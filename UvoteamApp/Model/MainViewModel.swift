//
//  MainViewModel.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/11/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import Foundation

struct MainViewModel {
    let title: String
    let description: String?

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }

}


