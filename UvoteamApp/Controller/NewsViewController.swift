//
//  NewsViewController.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/10/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var chooseNewsSegmentedControl: UISegmentedControl!
    
    // MARK: - Private Properties

    private struct Constants {
        static let detailVC = "DetailViewController"
        static let detailSegue = "detailSegue"
        static let businessNewsVC = "BusinessNewsViewController"
        static let othersNewsVC = "OthersNewsViewController"
        static let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    private lazy var businessNewsVC: BusinessNewsViewController = {

        var viewController = Constants.mainStoryboard.instantiateViewController(withIdentifier: Constants.businessNewsVC) as! BusinessNewsViewController

        // Adding View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var othersNewsVC: OthersNewsViewController = {

        var viewController = Constants.mainStoryboard.instantiateViewController(withIdentifier: Constants.othersNewsVC) as! OthersNewsViewController

        // Adding View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()


    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
        setupSegmentedControl()
        updateView()
    }

    private func setupSegmentedControl() {
        // Configure Segmented Control
        chooseNewsSegmentedControl.removeAllSegments()
        chooseNewsSegmentedControl.insertSegment(withTitle: "Business", at: 0, animated: false)
        chooseNewsSegmentedControl.insertSegment(withTitle: "Others", at: 1, animated: false)
        chooseNewsSegmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        chooseNewsSegmentedControl.selectedSegmentIndex = 0
    }

    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func updateView() {
        if chooseNewsSegmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: othersNewsVC)
            add(asChildViewController: businessNewsVC)
        } else {
            remove(asChildViewController: businessNewsVC)
            add(asChildViewController: othersNewsVC)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }


    // MARK: - Actions

//    @IBAction func changeNewsSegmentedControl(_ sender: UISegmentedControl) {
//        let index = sender.selectedSegmentIndex
//    }

}


