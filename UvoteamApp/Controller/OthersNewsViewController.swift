//
//  OthersNewsViewController.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/12/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

final class OthersNewsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var othersNewsTableView: UITableView!

    // MARK: - Private Properties

    private struct Constants {
        static let detailVC = "DetailViewController"
        static let detailSegue = "detailSegue"
    }
    private var entertainmentNews: [BasicModel]?
    private var environmentNews: [BasicModel]?
    private var titleForHeader = "Entertainment News"

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupIU()
    }

    // MARK: - Private Methods

    private func setupIU() {
        othersNewsTableView.dataSource = self
        othersNewsTableView.delegate = self
        othersNewsTableView.rowHeight = 130
        othersNewsTableView.register(UINib(nibName: NewsCell.identifier, bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        fetchData()
    }

    private func fetchData() {
        let entertainmentParser = NewsParser()
        entertainmentParser.parseFeed(url: NetworkEndpoints.entertainmentNews!) { [weak self] (items) in
            guard let self = self else { return }
            self.entertainmentNews = items
            OperationQueue.main.addOperation {
                self.othersNewsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        let environmentParser = NewsParser()
        environmentParser.parseFeed(url: NetworkEndpoints.environmentNews!) { [weak self] (items) in
            guard let self = self else { return }
            self.environmentNews = items
            OperationQueue.main.addOperation {
                self.othersNewsTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
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
        guard let indexPath = self.othersNewsTableView.indexPathForSelectedRow else { return }
        guard let destVC = segue.destination as? DetailViewController else { return }

        // TODO: - not only entertainmentNews
        switch indexPath.section {
        case 0:
            destVC.title = entertainmentNews![indexPath.row].title
            destVC.descriptionNews = formatDescription(str: entertainmentNews![indexPath.row].description)
        case 1:
            destVC.title = environmentNews![indexPath.row].title
            destVC.descriptionNews = formatDescription(str: environmentNews![indexPath.row].description)
        default:
            break
        }
    }

}


// MARK: - Table View Data Source Methods

extension OthersNewsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            guard let items = entertainmentNews else {
                return 0
            }
            return items.count
        case 1:
            guard let items = environmentNews else {
                return 0
            }
            return items.count
        default:
            break
        }
        return section
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            if let item = entertainmentNews?[indexPath.item] {
                cell.item = item
            }
            return cell
        default:
            break
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        if let item = environmentNews?[indexPath.item] {
            cell.item = item
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return titleForHeader
        case 1:
            return "Environment News"
        default:
            return ""
        }
    }

}


// MARK: - Table View Delegate Methods

extension OthersNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
