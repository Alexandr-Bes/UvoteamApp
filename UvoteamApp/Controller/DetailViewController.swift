//
//  DetailViewController.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/11/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!

    // MARK: - Properties
    var descriptionNews: String?


    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        descriptionTextView.text = descriptionNews
        UserDefaults.standard.set(self.title, forKey: "Title")
    }

}
