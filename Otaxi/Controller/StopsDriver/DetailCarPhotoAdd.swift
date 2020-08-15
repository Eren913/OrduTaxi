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
    fileprivate let db = Firestore.firestore().collection(USER_FREF)
    
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var selectedView: UIView!
    
    
    var carPhoto : CarPhoto = CarPhoto()
    
    fileprivate let imageView1: UIImageView = {
        return UIImageView().configureImageView()
    }()
    fileprivate let imageView2: UIImageView = {
        return UIImageView().configureImageView()
    }()
    fileprivate let imageView3: UIImageView = {
        return UIImageView().configureImageView()
    }()
    fileprivate let addButton : UIButton = {
        return UIButton().configButton(title: "Ekle", selector: #selector(addedClicked))
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
        getDetailPhotoFirestore()
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
    fileprivate func getDetailPhotoFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        _ = Service.shared.getDetailCarPhoto(imageView1: imageView1, imageView2: imageView2, imageView3: imageView3, view: self, uid: uid)
    }
    
    //MARK:-HelperFuncs
    fileprivate func configureUI(){
        configureNavigation(title: "Fotoğraf Ekle", style: .default)
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
    fileprivate func uploadImage(){
        self.shouldPresentLoadingView(true, message: "Yükleniyor")
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
                if self.selectedView == self.imageView1{
                    self.carPhoto.goruntuURL1 = urlstring as NSString
                }else if self.selectedView == self.imageView2{
                    self.carPhoto.goruntuURL2 = urlstring as NSString
                }else if self.selectedView == self.imageView3{
                    self.carPhoto.goruntuURL3 = urlstring as NSString
                }
            }
             self.shouldPresentLoadingView(false, message: nil)
        }
    }
    
    //MARK:-Selectors
    @objc fileprivate func addedClicked(){
        print("DEBUG: Veriler Kaydediliyor")
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let veriler = [
            USER_ID_FREF    : uid,
            "Goruntu_URL0"  : carPhoto.goruntuURL1 ??  "veri yok" ,
            "Goruntu_URL1"  : carPhoto.goruntuURL2 ??  "veri yok" ,
            "Goruntu_URL2"  : carPhoto.goruntuURL3 ??  "veri yok"] as [String : Any]
        db.document(uid).collection(CARPHOTOS_FREF).document(uid).setData(veriler) { (error) in
            if let error = error{
                print("DEBUG: Taksici Detay Fotoğraflarını Kayıt Ederken Hata Meydana Geldi :\(error.localizedDescription)")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc fileprivate func chooseImage(_ gesture: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerFunctions(sourceType: .photoLibrary)
            selectedView = gesture.view
            present(imagePicker, animated: true)
        }
    }
    
}
//MARK:-Extension: UIImagePickerControllerDelegate
extension DetailCarPhotoAdd: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        (selectedView as? UIImageView)?.image = info[.editedImage] as? UIImage
        dismiss(animated: true) {
            self.uploadImage()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }
    }
}
