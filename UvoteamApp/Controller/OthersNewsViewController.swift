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
    private var titleForHeader = "EntertainmentNews News"

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupIU()
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
        let newsParser = NewsParser()
        newsParser.parseFeed(url: NetworkEndpoints.entertainmentNews!) { [weak self] (items) in
            guard let self = self else { return }
            self.entertainmentNews = items
            DispatchQueue.main.async {
                self.othersNewsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
//        newsParser.parseFeed(url: NetworkEndpoints.environmentNews!) { [weak self] (items) in
//            guard let self = self else { return }
//            self.environmentNews = items
//            DispatchQueue.main.async {
//                self.othersNewsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//            }
//        }
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
        let title = entertainmentNews![indexPath.row].title
        destVC.title = title
        destVC.descriptionNews = formatDescription(str: entertainmentNews![indexPath.row].description)
    }

}


// MARK: - Table View Data Source Methods

extension OthersNewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = entertainmentNews else {
            return 0
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }

        if let item = entertainmentNews?[indexPath.item] {
            cell.item = item
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader
    }

}


// MARK: - Table View Delegate Methods

extension OthersNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
