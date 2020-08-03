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
    var drivers : [Rating] = []
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
    fileprivate func fetchAllUserData() {
        USER_FSREF.whereField(ACCOUNT_TYPE_FREF, isEqualTo: 1).order(by: HEALTH_SCORE_FREF, descending: true).limit(to: 30).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG: Error Healty Taxi fetch data -- \(error.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.drivers = Rating.fetchRating(snapshot: snapshot)
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
        return drivers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: healtyTaxiTableViewIdentifier, for: indexPath) as! HealtyTaxiCell
        //cell.accessoryType = .detailButton
        cell.nameLabel.text = drivers[indexPath.row].fullname
        cell.stopLabel.text = drivers[indexPath.row].stop
        cell.initialLabel.text = drivers[indexPath.row].firstInitial
        cell.cosmosView.rating = drivers[indexPath.row].healthpoint
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = StopsDriverDetail()
        //navigationController?.pushViewController(homeDetail, animated: true)
    }
    
    
}
