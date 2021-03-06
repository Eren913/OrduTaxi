//
//  MenuController.swift
//  UberTutorial
//
//  Created by Stephen Dowless on 9/22/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

private let reuseIdentifier = "MenuCell"

enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    case favoriTaksiciler
    case bestTaxi
    case settings
    case logout
    
    var description: String {
        switch self {
        case .favoriTaksiciler: return "Favori Taksiciler"
        case .bestTaxi: return "Sağlıklı Taksiler"
        case .settings: return "Ayarlar"
        case .logout: return "Çıkış Yap"
        }
    }
}

protocol MenuControllerDelegate: class {
    func didSelect(option: MenuOptions)
}

class MenuController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    weak var delegate: MenuControllerDelegate?
    private var profilPhoto = [ProfilPhoto]()
    
    lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.view.frame.width - 80,
                           height: 140)
        let view = MenuHeader(user: user, frame: frame)
        return view
    }()
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureTableView()
        getProfilePhoto()
    }
    // MARK: - Selectors
    @objc func signOut(){
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.isModalInPresentation = true
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }catch{
            print("DEBUG: SignOut Error")
        }
    }
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
    }
    // MARK: - Api
    func getProfilePhoto(){
        profilPhoto.removeAll()
        let db = Firestore.firestore().collection(USER_FREF)
        let ref = db.document(user.uid).collection(PROFILEPHOTO_REF)
        ref.addSnapshotListener { (snapshot, error) in
            if snapshot?.isEmpty == false && snapshot != nil {
                self.profilPhoto = ProfilPhoto.fetchProfilephoto(snapshot: snapshot)
                if self.profilPhoto.count > 0 {
                    for photo in self.profilPhoto{
                        self.menuHeader.uploadImageView.sd_setImage(with: URL(string: photo.imageUrl))
                        break
                    }
                }
            }else{
                self.menuHeader.uploadImageView.image =  nil
            }
        }
    }
}

// MARK: - UITableViewDelegate/DataSource

extension MenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .backgroundColor
        cell.selectionStyle = .none
        if indexPath.row == 3{
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .red
            cell.layer.cornerRadius = 5
        }
        guard let option = MenuOptions(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.textLabel?.text = option.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else { return }
        delegate?.didSelect(option: option)
    }
}
