//
//  BestTaxiDetail.swift
//  Otaxi
//
//  Created by lil ero on 30.07.2020.
//

import UIKit

private let reuseIdentifier = "SettingsCell"

class BestTaxiDetail: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: DetailInfoHeader!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        let frame = CGRect(x: 0, y: 100, width: tableView.frame.width, height: 100)
        userInfoHeader = DetailInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.canCancelContentTouches = true
        tableView.tableFooterView = UIView()
        
    }
    
    func configureUI() {
        configureTableView()
        configureNavigation(title: "Eren Celık")
    }
    func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
    }
    
}

extension BestTaxiDetail: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        if indexPath.row == 0 {
        }
        return cell
    }
    
    
}

