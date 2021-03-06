//
//  FavoriteTaxi.swift
//  Otaxi
//
//  Created by lil ero on 4.08.2020.
//

let identifer = "FavoriteTaxiID"

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FavoriteTaxi: UIViewController{
    //MARK:-Properties
    var favoritesDriver : [Rating] = []
    fileprivate let tableView = UITableView()
    
    //MARK:- Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigation(title: "Favori Taksiciler")
        fetchingFavorites()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.favoritesDriver.removeAll()
    }
    //MARK:-Helper Functions
    fileprivate func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(FavoriteTaxiCell.self, forCellReuseIdentifier: identifer)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    //MARK:-Api
    fileprivate func fetchingFavorites(){
        _ = Service.shared.fetchFavorites(completion: { (err, fav) in
            USER_FSREF.whereField(USER_ID_FREF, isEqualTo: fav.userID).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("DEBUG: Error favorite Taxi data -- \(error.localizedDescription)")
                } else {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        self.favoritesDriver = Rating.fetchRating(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    //MARK:-Selectors
}
extension FavoriteTaxi: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesDriver.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! FavoriteTaxiCell
        cell.selectionStyle = .none
        _ = Service.shared.getProfilePhotoFS(uid: favoritesDriver[indexPath.row].uid, imageView: cell.uploadImageView)
        cell.usernameLabel.text = favoritesDriver[indexPath.row].fullname
        cell.emailLabel.text = favoritesDriver[indexPath.row].email
        cell.initialLabel.text = favoritesDriver[indexPath.row].firstInitial
        return cell
    }
}
