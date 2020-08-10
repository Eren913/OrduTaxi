//
//  HighHPDrivers.swift
//  Otaxi
//
//  Created by lil ero on 1.08.2020.
//
let healtyTaxiTableViewIdentifier = "id"

import UIKit
import Cosmos
import FirebaseFirestore

class HighHPDrivers: UIViewController{
    
    //MARK: - Properties
    let tableView = UITableView()
    var drivers : [Rating] = []
    
    private let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureTableView()
        if self.modalPresentationStyle == .custom{
            configureUI()
            view.backgroundColor = .white
            tableView.frame = CGRect(x: 0, y: +120, width: view.bounds.width, height: view.bounds.height)
        }
        configureNavigation(title: "Sağlıklı Taksiciler")
        fetchAllUserData()
        
    }
    //MARK:-Helper Functions
    fileprivate func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(HighHPDriversCell.self, forCellReuseIdentifier: healtyTaxiTableViewIdentifier)
        view.addSubview(tableView)
    }
    func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    fileprivate func configureUI(){
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor ,
                             left: view.leftAnchor,
                             paddingTop: 16,
                             paddingLeft: 20,
                             width: 50,
                             height: 50)
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
    @objc fileprivate func handleDismissal(){
        if self.modalPresentationStyle == .custom {
            dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
}
//MARK:- Extensions
extension HighHPDrivers: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: healtyTaxiTableViewIdentifier, for: indexPath) as! HighHPDriversCell
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
