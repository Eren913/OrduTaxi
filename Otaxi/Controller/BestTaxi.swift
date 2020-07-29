//
//  BestTaxi.swift
//  Otaxi
//
//  Created by lil ero on 28.07.2020.
//

import UIKit
let tableViewIdentifer = "id"

class BestTaxi: UIViewController{
    //MARK: - Properties
    let tableView = UITableView()
    var navigationTitle : String = ""
     var user: User? {
        didSet {
            guard let user = user else { return }
            print("DEBUG: user is \(user.fullname)")
        }
    }
        //MARK: - Lifecycle
        override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureTableView()
        configureNavigation(title: navigationTitle)
    }
    
    func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(BestTaxiCell.self, forCellReuseIdentifier: tableViewIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    //MARK:Selectors
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
}
extension BestTaxi: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifer, for: indexPath) as! BestTaxiCell
        cell.accessoryType = .disclosureIndicator
        cell.nameLabel.text = user?.fullname
        cell.initialLabel.text = user?.firstInitial
        return cell
    }
    
    
}

