//
//  SettingsController.swift
//  UberTutorial
//
//  Created by Stephen Dowless on 9/23/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

private let reuseIdentifier = "LocationCell"

protocol SettingsControllerDelegate: class {
    func updateUser(_ controller: SettingsController)
}

enum LocationType: Int, CaseIterable, CustomStringConvertible {
    case home
    case work
    
    var description: String {
        switch self {
        case .home: return "Ev"
        case .work: return "İş"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home: return "Ev Adressi Ekle"
        case .work: return "İş Adressi Ekle"
        }
    }
}

class SettingsController: UITableViewController {
    
    // MARK: - Properties
    
    var user: User
    var profilPhoto = [ProfilPhoto]()
    
    //var pp: ProfilPhoto?
    
    let db = Firestore.firestore().collection(USER_FREF)
    
    private let locationManager = LocationHandler.shared.locationManager
    weak var delegate: SettingsControllerDelegate?
    var userInfoUpdated = false
    
    private lazy var infoHeader: UserInfoHeader = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let view = UserInfoHeader(user: user, frame: frame)
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
        configureNavigationBar()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        infoHeader.uploadImageView.addGestureRecognizer(gestureRecognizer)
        getProfilePhoto()
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        if userInfoUpdated {
            delegate?.updateUser(self)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleedit(){
        //infoHeader.configureInitalLabel.isHidden = true
    }
    
    // MARK: - Helper Functions
    func getProfilePhoto(){
        let ref = db.document(self.user.uid).collection("ProfilePhoto")
        ref.addSnapshotListener { (snapshot, error) in
            if snapshot?.isEmpty == false && snapshot != nil {
                self.profilPhoto = ProfilPhoto.fetchProfilephoto(snapshot: snapshot)
                if self.profilPhoto.count > 0 {
                    self.profilPhoto.forEach { (profil) in
                        self.infoHeader.uploadImageView.sd_setImage(with: URL(string: profil.imageUrl))
                    }
                }
            }
        }
    }
    
    func locationText(forType type: LocationType) -> String {
        switch type {
        case .home:
            return user.homeLocation ?? type.subtitle
        case .work:
            return user.workLocation ?? type.subtitle
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = 60
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.tableHeaderView = infoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Ayarlar"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Düzenle", style: .done, target: self, action: #selector(handleedit))
    }
}

// MARK: - UITableViewDelegate/DataSource

extension SettingsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationType.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .white
        title.text = "Favori Adress Ekle"
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 16)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        guard let type = LocationType(rawValue: indexPath.row) else { return cell }
        cell.titlelabel.text = type.description
        cell.adressLabel.text = locationText(forType: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = LocationType(rawValue: indexPath.row) else { return }
        guard let location = locationManager?.location else { return }
        let controller = AddLocationController(type: type, location: location)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - AddLocationControllerDelegate

extension SettingsController: AddLocationControllerDelegate {
    func updateLocation(locationString: String, type: LocationType) {
        Service.shared.saveLocation(locationString: locationString, type: type) { (err, ref) in
            self.dismiss(animated: true, completion: nil)
            self.userInfoUpdated = true
            switch type {
            case .home:
                self.user.homeLocation = locationString
            case .work:
                self.user.workLocation = locationString
            }
            self.tableView.reloadData()
        }
        Service.shared.saveLocationFS(locationString: locationString, type: type) { (error) in
            self.dismiss(animated: true, completion: nil)
            self.userInfoUpdated = true
            switch type {
            case .home:
                self.user.homeLocation = locationString
            case .work:
                self.user.workLocation = locationString
            }
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
}
//MARK:- UIImagePickerControllerDelegate,UIImagePickerControllerDelegate
extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func choosePicture() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        infoHeader.uploadImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true) {
            self.uploadImage()
        }
    }
    func uploadImage(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageReference = Storage.storage().reference()
        let mediaFolder = storageReference.child("Media")
        if let data = infoHeader.uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.presentAlertController(withTitle: "Fotoraf Yüklenirken Hata Meydana Geldi", message: error.localizedDescription)
                    return
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            //Firestore
                            self.db.whereField(self.user.uid, isEqualTo: uid).getDocuments { (snapshot, error) in
                                if let error = error {
                                    print("DEBUG: Error get document \(error.localizedDescription)")
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            if var imageUrlArray = document.get(IMAGEURL_REF_FS) as? String {
                                                imageUrlArray.append(imageUrl!)
                                                let additionalDictionary = [IMAGEURL_REF_FS : imageUrlArray] as [String : Any]
                                                self.db.document(self.user.uid).setData(additionalDictionary, merge: true) { (error) in
                                                    if let error = error {
                                                        print("DEBUG: Error setting Data \(error.localizedDescription)")
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        let Dictionary = [IMAGEURL_REF_FS : imageUrl!, "FotoSahibi" : self.user.uid] as [String : Any]
                                        self.db.document(uid).collection(PROFILEPHOTO_REF).document(uid).setData(Dictionary, merge: true) { (error) in
                                            if let error = error  {
                                                print("DEBUG: Error setting profile Photo Data -- \(error.localizedDescription)")
                                            }
                                        }
                                        USER_REF.child(uid).updateChildValues(Dictionary) { (error, ref) in
                                            if let error = error{
                                                debugPrint("DEBUG: RealtimeDatabase Update photo Data Error -- \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

