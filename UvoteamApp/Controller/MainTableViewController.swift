//
//  MainViewController.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/10/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    // MARK: - Properties
    private var modelArray: [MainViewModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    private var timer: Timer?
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
        return formatter
    }()
    var titleLabel: String?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - Private Methods
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Main Info"

        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(getTime),
                                     userInfo: nil,
                                     repeats: true)

        let firstInfo = MainViewModel(title: "Your name", description: "Alexander")
        let secondInfo = MainViewModel(title: "Title", description: titleLabel ?? "")
        modelArray = [firstInfo, secondInfo]
    }

    @objc private func getTime(section: Int) {
        tableView.reloadData()
    }
}


// MARK: - Table View Data Source Methods
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! GeneralInfoCell
        cell.titleLabel.text = modelArray[indexPath.row].title
        cell.descriptionLabel.text = modelArray[indexPath.row].description
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "General Information"
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return formatter.string(from: Date())
    }

}
