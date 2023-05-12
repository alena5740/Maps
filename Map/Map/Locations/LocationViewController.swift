//
//  LocationViewController.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

final class LocationViewController: UIViewController {

    private let tableView = UITableView()
    private let presenter: LocationPresenterProtocol

    init(presenter: LocationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getWeather(completion: {
            self.tableView.reloadData()
        })
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }

    private func setupUI() {
        setupScreen()
        setupNavigation()
        setupTableView()
    }

    private func setupScreen() {
        view.backgroundColor = .white
    }

    private func setupNavigation() {
        self.navigationItem.title = "Локации"
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.reuseIdentifier)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getWeatherCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.reuseIdentifier, for: indexPath) as! InfoCell
        cell.configure(model: presenter.getWeatherCount(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
