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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureTableView()
        configureNavigation(title: navigationTitle)
    }
    
    func configureTableView(){
        tableView.frame = view.bounds
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

