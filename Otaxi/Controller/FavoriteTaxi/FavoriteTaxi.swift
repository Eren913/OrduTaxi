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
    var selectedFavoriteTaxi: [Rating] = []
    var favoritesUid = [String]()
    let db = Firestore.firestore()
    
    fileprivate let tableView = UITableView()
    //MARK:- Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigation(title: "Favori Taksiciler")
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchUser()
        fetchAllUserData()
        fetchingFavorites()
    }
    //MARK:-Helper Functions
    fileprivate func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(FavoriteTaxiCell.self, forCellReuseIdentifier: identifer)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    fileprivate func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
    }
    //MARK:-Api
    fileprivate func fetchAllUserData() {
        self.favoritesUid.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let way = db.collection(USER_FREF).document(uid).collection(FAVORITES_TAXI_FSREF)
        way.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.favoritesUid.append(document.documentID)
                }
            }
        }
    }
    fileprivate func fetchUser(){
        USER_FSREF.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG: Error Stop Drivers -- \(error.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.selectedFavoriteTaxi = Rating.fetchRating(snapshot: snapshot)
                    self.tableView.reloadData()
                }
            }
        }
    }
    fileprivate func fetchingFavorites(){
        USER_FSREF.whereField(favoritesUid[0], isEqualTo: selectedFavoriteTaxi[0].uid).getDocuments { (snapshot, error) in
            if let error = error {
                print("DEBUG: error getting facorite taxi documents \(error.localizedDescription)")
                return
            }
            for snap in snapshot!.documents{
                print("DEBUG: ıd \(snap.documentID)")
            }
        }
    }
    
    
    //MARK:-Selectors
}
extension FavoriteTaxi: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! FavoriteTaxiCell
        
        return cell
    }
    
    
}
