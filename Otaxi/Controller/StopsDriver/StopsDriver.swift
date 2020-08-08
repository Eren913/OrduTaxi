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
    var drivers : [Rating] = []
    let tableView = UITableView()
    var navigationTitle : String = ""
    var user: User?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    //MARK:-Api
    fileprivate func fetchAllUserData() {
        USER_FSREF.whereField(DURAK_ISMI_FREF, isEqualTo: navigationTitle).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG: Error Stop Drivers -- \(error.localizedDescription)")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.drivers = Rating.fetchRating(snapshot: snapshot)
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
        tableView.tableFooterView = UIView()
    }
    fileprivate func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    fileprivate func checkUserUid(){
        if user == nil{
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.isModalInPresentation = true
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            self.presentAlertController(withTitle: "Kullanıcı Veri Tabanında Hata Meydana Geldi", message: "Hesabınız Silinmiş Olabilir Tekrardan Giriş veya Kayıt Yapınız")
        }
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
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifer, for: indexPath) as! StopsDriverCell
        cell.selectionStyle = .none
        _ = Service.shared.getProfilePhotoFS(uid: drivers[indexPath.row].uid, imageView: cell.uploadImageView)
        cell.nameLabel.text = drivers[indexPath.row].fullname
        cell.initialLabel.text = drivers[indexPath.row].firstInitial
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeDetail = StopsDriverDetail()
        homeDetail.selectedDriver = drivers[indexPath.row].self
        navigationController?.pushViewController(homeDetail, animated: true)
    }
}

