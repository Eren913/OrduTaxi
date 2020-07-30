//
//  BestTaxi.swift
//  Otaxi
//
//  Created by lil ero on 28.07.2020.
//

import UIKit
import FirebaseDatabase
let tableViewIdentifer = "id"

class BestTaxi: UIViewController{
    //MARK: - Properties
    let tableView = UITableView()
    var navigationTitle : String = ""
    var user: User?{
        didSet{
            
        }
    }
    var us = [User]()
    var er = [String]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureTableView()
        configureNavigation(title: navigationTitle)
        fetchAllUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("DEBUG: -- \(er)")
    }
    func fetchAllUserData() {
        let ref = Database.database().reference()
        ref.child("Users").observe(.value) { (snapshot) in
            let post = snapshot.value as? [String:Any]
            if let actualPost = post{
                print("DEBUG: eren -- \(actualPost)")
            }
        }
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifer, for: indexPath) as! BestTaxiCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeDetail = BestTaxiDetail()
        present(homeDetail, animated: true, completion: nil)
    }
    
    

}

