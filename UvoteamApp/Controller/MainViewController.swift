//
//  MainViewController.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/10/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Main Info"
    }
}
