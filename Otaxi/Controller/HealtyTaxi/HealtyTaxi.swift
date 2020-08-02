//
//  HealtyTaxi.swift
//  Otaxi
//
//  Created by lil ero on 1.08.2020.
//
let healtyTaxiTableViewIdentifier = "id"

import UIKit
import Cosmos
import FirebaseFirestore

class HealtyTaxi: UIViewController{
    
    //MARK: - Properties
    let tableView = UITableView()
    var array : [Drivers] = []
    var healthScore : Double = 0
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureTableView()
        configureNavigation(title: "Sağlıklı Taksiciler")
        fetchAllUserData()
        
    }
    //MARK:-Helper Functions
    func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(HealtyTaxiCell.self, forCellReuseIdentifier: healtyTaxiTableViewIdentifier)
        view.addSubview(tableView)
    }
    func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    //MARK:-Api
    func fetchAllUserData() {
        USER_FSREF.order(by: HEALTH_SCORE_FREF, descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("DEBUG: Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.array.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        if let healt = document.get(HEALTH_SCORE_FREF) as? Double {
                            if let username = document.get(FULLNAME_FREF) as? String {
                                if let email = document.get(EMAİL_FREF) as? String {
                                    if let stop = document.get(DURAK_ISMI_FREF) as? String{
                                        let uid = document.documentID
                                        let driverInfo = Drivers(uid: uid, fullname: username, email: email, healthpoint: healt, stop: stop, accountType: nil)
                                        self.healthScore = driverInfo.healthpoint!
                                        self.array.append(driverInfo)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    //MARK:- Selectors
}
//MARK:- Extensions
extension HealtyTaxi: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: healtyTaxiTableViewIdentifier, for: indexPath) as! HealtyTaxiCell
        cell.accessoryType = .detailButton
        cell.nameLabel.text = array[indexPath.row].fullname
        cell.stopLabel.text = array[indexPath.row].stop
        cell.initialLabel.text = array[indexPath.row].firstInitial
        cell.cosmosView.rating = array[indexPath.row].healthpoint!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = StopsDriverDetail()
        //navigationController?.pushViewController(homeDetail, animated: true)
    }
    
    
}
