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

    @IBOutlet weak var newsTableView: UITableView!

    // MARK: - Private Properties

    private struct Constants {
        static let detailVC = "DetailViewController"
        static let detailSegue = "detailSegue"
    }
    private var businessNews: [BasicModel]?
    private var entertainmentNews: [BasicModel]?
    private var environmentNews: [BasicModel]?
    private var titleForHeader = "Business News"

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.rowHeight = 130
        newsTableView.register(UINib(nibName: NewsCell.identifier, bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        fetchData(businessNews: true)
    }

    private func fetchData(businessNews: Bool) {
        let newsParser = NewsParser()
        if businessNews {
            newsParser.parseFeed(url: NetworkEndpoints.businessNews!) { [weak self] (items) in
                guard let self = self else { return }
                self.businessNews = items
                DispatchQueue.main.async {
                    self.newsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            }
        } else {
            newsParser.parseFeed(url: NetworkEndpoints.entertainmentNews!) { [weak self] (items) in
                guard let self = self else { return }
                self.entertainmentNews = items
                DispatchQueue.main.async {
                    self.newsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            }
            newsParser.parseFeed(url: NetworkEndpoints.environmentNews!) { [weak self] (items) in
                guard let self = self else { return }
                self.environmentNews = items
                DispatchQueue.main.async {
                    self.newsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
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

    // MARK: - Actions

    @IBAction func changeNewsSegmentedControl(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 1 {
            fetchData(businessNews: false)
        } else {
            fetchData(businessNews: true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.newsTableView.indexPathForSelectedRow else { return }
        guard let destVC = segue.destination as? DetailViewController else { return }
        let title = businessNews![indexPath.row].title
        destVC.title = title
        destVC.descriptionNews = formatDescription(str: businessNews![indexPath.row].description)
    }

}


// MARK: - Table View Data Source Methods

extension NewsViewController: UITableViewDataSource {

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

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

