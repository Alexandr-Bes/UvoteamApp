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

    // MARK: - Properties
    private let newsTitle = "Hello"
    private let desc = "My name is blalala"

    private var businessNews: [BusinessModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.newsTableView.reloadData()
            }
        }
    }
    private var elementName: String = String()
    var businessTitle = String()
    var businessDisc = String()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {

        let path = URL(string: "http://feeds.reuters.com/reuters/businessNews")
        if let parser = XMLParser(contentsOf: path!) {
            parser.delegate = self
            parser.parse()
        }

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.register(UINib(nibName: NewsCell.identifier, bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
    }

}


// MARK: - Table View Data Source Methods
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessNews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        let news = businessNews[indexPath.row]
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        return cell
    }

}


// MARK: - Table View Delegate Methods
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsViewController: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            businessTitle = String()
            businessDisc = String()
        }
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let news = BusinessModel(title: businessTitle, description: businessDisc)
            businessNews.append(news)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                businessTitle += data
            } else if self.elementName == "description" {
                businessDisc += data
            }
        }
    }
}
