//
//  FavoriteTaxi.swift
//  Otaxi
//
//  Created by lil ero on 4.08.2020.
//

let identifer = "FavoriteTaxiID"

import UIKit

class FavoriteTaxi: UIViewController{
    //MARK:-Properties
    let selectedFavoriteTaxi: Rating? = nil
    
    
    
    let tableView = UITableView()
    //MARK:- Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        
    }
    //MARK:-Helper Functions
    fileprivate func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(FavoriteTaxiCell.self, forCellReuseIdentifier: identifer)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    //MARK:-Api
    func fetchAllUserData() {
        USER_FSREF.whereField(FAVORITE_TAXI, isEqualTo: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG: Error favori Drivers -- \(error.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    //self.drivers = Rating.fetchRating(snapshot: snapshot)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK:-Selectors
}
extension FavoriteTaxi: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! FavoriteTaxiCell
        
        return cell
    }
    
    
}
