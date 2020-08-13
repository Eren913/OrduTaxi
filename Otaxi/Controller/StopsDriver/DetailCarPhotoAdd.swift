//
//  DetailCarPhotoAdd.swift
//  Otaxi
//
//  Created by lil ero on 13.08.2020.
//

import UIKit
import Firebase
import SDWebImage

protocol DetailCarPhotoAddDelegate {
    func dissmisButtonPressed()
}

class DetailCarPhotoAdd: UIViewController{
    //MARK:-Properties
    
    var user: User!
    let db = Firestore.firestore().collection(USER_FREF)
    

    
    var CarPhoto : CarPhotoM!
    var CarPhotoMArray : [CarPhotoM] = []
    
    var imagePicker = UIImagePickerController()
    var selectedView: UIView!
    
    
    let imageView1: UIImageView = {
        return UIImageView().profileUploadImage()
    }()
    let imageView2: UIImageView = {
        return UIImageView().profileUploadImage()
    }()
    let imageView3: UIImageView = {
        return UIImageView().profileUploadImage()
    }()
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ekle", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(addedClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    //MARK:-LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        getUser()
        getSnapsFromFirebase()
    }
    override func viewDidLayoutSubviews() {
        addButton.layer.insertSublayer(CALayer.gradientLayer(frame: addButton.bounds), at: 0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK:-Api
    fileprivate func getUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        _ = Service.shared.fetchUserData(uid: uid, completion: { (us) in
            self.user = us
        })
    }
    
    
    //MARK:-HelperFuncs
    fileprivate func configureUI(){
        configureNavigation(title: "Fotoğraf Ekle")
        configureGesture()
        
        view.addSubview(imageView1)
        imageView1.layer.cornerRadius = 10
        imageView1.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: view.bounds.width, height: view.bounds.height / 5)
        
        let stack = UIStackView(arrangedSubviews: [imageView2,imageView3])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 10
        view.addSubview(stack)
        stack.anchor(top: imageView1.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, width: view.bounds.width, height: view.bounds.height / 5)
        
        view.addSubview(addButton)
        addButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
    }
    fileprivate func pickerFunctions(sourceType: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    fileprivate func configureGesture(){
        [imageView1,imageView2,imageView3].forEach {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
        }
    }
    
    func getSnapsFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.document(uid).collection(CARPHOTOS_FREF).document(uid).getDocument() { (document, error) in
          if let document = document {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("DEBUG:Cached document data: \(dataDescription)")
          } else {
            print("DEBUG:Document does not exist in cache")
          }
        }
    }
    //MARK:-Selectors
    @objc fileprivate func addedClicked(){
        print("DEBUG: Veriler Kaydediliyor")
        guard let uid = Auth.auth().currentUser?.uid else{return}
        print("DEBUG: q-- \(String(describing:  CarPhoto?.goruntuURL1 ))")
        let veriler : [String :  Any] = [
            "KullaniciID"  : uid,
            "Goruntu_URL"  : CarPhoto?.goruntuURL1 ??  "veri yok" ,
            "Goruntu_URL2" : CarPhoto?.goruntuURL2 ?? "veri yok" ,
            "Goruntu_URL3" : CarPhoto?.goruntuURL3 ?? "veri yok" ,
        ]
        db.document(uid).collection(CARPHOTOS_FREF).document(uid).setData(veriler) { (error) in
            if let hata = error{
                print("DEBUG: Kullanıcı Bilgilerini kayıt Ederken hata meydana geldi \(hata.localizedDescription)")
            }
            self.dismiss(animated: true)
        }
        
    }
    @objc func chooseImage(_ gesture: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerFunctions(sourceType: .photoLibrary)
            selectedView = gesture.view
            present(imagePicker, animated: true)
        }
    }
    
}
extension DetailCarPhotoAdd: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        (selectedView as? UIImageView)?.image = info[.originalImage] as? UIImage
        dismiss(animated: true) {
            uploadImage()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }
        
        func uploadImage(){
            let goruntuAdi = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/CarPhoto/\(goruntuAdi)")
            guard let veri = (selectedView as? UIImageView)?.image?.jpegData(compressionQuality: 0.5) else {return}
            ref.putData(veri, metadata: nil) { (nil, error) in
                if let error = error{
                    print("DEBUG: Goruntu yüklenirken hata meydana geldi\(error.localizedDescription)")
                    return
                }
                ref.downloadURL { (url, error) in
                    if let error = error{
                        print("DEBUG: Goruntu Url Alınamadı \(error.localizedDescription)");return
                    }
                    guard let urlstring = url?.absoluteString else {return}
                    if self.selectedView == self.imageView1 {
                        self.CarPhoto?.goruntuURL1 = urlstring
                         print("DEBUG: url1 \(String(describing: self.CarPhoto?.goruntuURL1))")
                    } else if  self.selectedView == self.imageView2{
                        self.CarPhoto?.goruntuURL2 = urlstring
                    } else if self.selectedView == self.imageView3{
                        self.CarPhoto?.goruntuURL3 = urlstring
                    }
                }
            }
        }
    }
}
