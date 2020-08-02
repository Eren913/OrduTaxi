//
//  StopsDriver.swift
//  Otaxi
//
//  Created by lil ero on 28.07.2020.
//

import UIKit
import FirebaseFirestore

let tableViewIdentifer = "id"

class StopsDriver: UIViewController{
    //MARK: - Properties
    var driversArray : [Drivers] = []
    let tableView = UITableView()
    var navigationTitle : String = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureTableView()
        configureNavigation(title: navigationTitle)
        fetchAllUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    func fetchAllUserData() {
        USER_FSREF.whereField(DURAK_ISMI_FREF, isEqualTo: navigationTitle).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("DEBUG: Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.driversArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        if let username = document.get(FULLNAME_FREF) as? String {
                            if let email = document.get(EMAİL_FREF) as? String {
                                let uid = document.documentID
                                let snap = Drivers(uid: uid, fullname: username, email: email,healthpoint: nil, stop: nil, accountType: nil)
                                self.driversArray.append(snap)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(StopsDriverCell.self, forCellReuseIdentifier: tableViewIdentifer)
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
extension StopsDriver: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driversArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifer, for: indexPath) as! StopsDriverCell
        cell.nameLabel.text = driversArray[indexPath.row].fullname
        cell.initialLabel.text = driversArray[indexPath.row].firstInitial
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeDetail = StopsDriverDetail()
        homeDetail.selectedDriver = driversArray[indexPath.row].self
        navigationController?.pushViewController(homeDetail, animated: true)
    }
}

