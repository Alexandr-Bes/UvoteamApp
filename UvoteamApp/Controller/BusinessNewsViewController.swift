//
//  BusinessNewsViewController.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/12/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

final class BusinessNewsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var businessNewsTableView: UITableView!

    // MARK: - Private Properties

    private struct Constants {
        static let detailVC = "DetailViewController"
        static let detailSegue = "detailSegue"
    }
    private var businessNews: [BasicModel]?
    private var titleForHeader = "Business News"

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        businessNewsTableView.dataSource = self
        businessNewsTableView.delegate = self
        businessNewsTableView.rowHeight = 130
        businessNewsTableView.register(UINib(nibName: NewsCell.identifier, bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        fetchData()
    }

    private func fetchData() {
        let newsParser = NewsParser()
        newsParser.parseFeed(url: NetworkEndpoints.businessNews!) { [weak self] (items) in
            guard let self = self else { return }
            self.businessNews = items
            DispatchQueue.main.async {
                self.businessNewsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
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

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.businessNewsTableView.indexPathForSelectedRow else { return }
        guard let destVC = segue.destination as? DetailViewController else { return }
        let title = businessNews![indexPath.row].title
        destVC.title = title
        destVC.descriptionNews = formatDescription(str: businessNews![indexPath.row].description)
    }

}


// MARK: - Table View Data Source Methods

extension BusinessNewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = businessNews else {
            return 0
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }

        if let item = businessNews?[indexPath.item] {
            cell.item = item
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader
    }

}


// MARK: - Table View Delegate Methods

extension BusinessNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
