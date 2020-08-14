//
//  SignUpController.swift
//  OrduTaxi
//
//  Created by lil ero on 17.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpController : UIViewController{
    
    //MARK: Properties
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "OTaksi"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    private let linkingView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let emailTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private lazy var emailContainer : UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x.png"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let fullNameTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "İsim Soyisim", isSecureTextEntry: false)
    }()
    private lazy var fullNameContainer : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_account_box_white_2x.png") , textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Şifre", isSecureTextEntry: true)
    }()
    private lazy var passwordContainer : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x.png") , textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let passwordTextField1 : UITextField = {
        return UITextField().textField(withPlaceholder: "Şifreyi Onayla", isSecureTextEntry: true)
    }()
    private lazy var passwordContainer1: UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x.png") , textField: passwordTextField1)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let telNoTextField : UITextField = {
        return UITextField().phoneTextField(withPlaceholder: "Telefon Numarası")
    }()
    
    private lazy var telNoContainer : UIView = {
        let view = UIView().inputContainerView(image: (UIImage(systemName: "phone.fill")!.withTintColor(.white)), textField: telNoTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let signUpButton  :UIButton = {
        return UIButton().configButton(title: "Kayıt Ol", selector: #selector(signUpClicked))
    }()
    private let alreadyHaveAccountButton : UIButton  = {
        return UIButton().stringButton(title: "Hesabınız Varmı ? ", buttonTitle: "Giriş Yap", selector: #selector(handleShowSignIn))
    }()
    private let alreadyHaveADriver : UIButton  = {
        return UIButton().stringButton(title: "Taksicimisiniz ? ", buttonTitle: "Kayıt Ol", selector: #selector(handleDriverSignUp))
    }()
    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        signUpButton.layer.insertSublayer(CALayer.gradientLayer(frame: signUpButton.bounds), at: 0)
    }
    fileprivate func configureUI() {
        view.backgroundColor = .backgroundColor
        self.hideKeyboard()
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let sv = UIStackView(arrangedSubviews: [emailContainer,
                                                fullNameContainer,
                                                telNoContainer,
                                                passwordContainer,
                                                passwordContainer1,
                                                signUpButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 24
        view.addSubview(sv)
        sv.centerX(inView: view)
        sv.anchor(top: titleLabel.bottomAnchor,
                  left: view.leftAnchor,
                  right: view.rightAnchor,
                  paddingTop: 40,
                  paddingLeft: 16,
                  paddingRight: 16)
        
        view.addSubview(linkingView)
        linkingView.centerX(inView: view)
        linkingView.anchor(top:sv.bottomAnchor,
                           paddingTop: 70,
                           width: view.bounds.width / 1,height: 0.5)
        
        view.addSubview(alreadyHaveADriver)
        alreadyHaveADriver.anchor(bottom: linkingView.topAnchor,right: view.rightAnchor,paddingBottom: 10,paddingRight: 20)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    //MARK:- Selectors
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc fileprivate func handleShowSignIn(){
        navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func handleDriverSignUp(){
        let dri = DriverSignUp()
        navigationController?.pushViewController(dri, animated: true)
    }
    @objc fileprivate func signUpClicked(){
        guard let emailtext = emailTextField.text else {return}
        guard let passwordtext = passwordTextField.text else {return}
        guard let passwordtext1 = passwordTextField1.text else {return}
        guard let fullnameText = fullNameTextField.text else {return}
        guard let telNoText = telNoTextField.text else {return}
        
        if emailTextField.text != "" && passwordTextField.text != "" && fullNameTextField.text != "" && telNoTextField.text != "" {
            if passwordtext == passwordtext1{
                Auth.auth().createUser(withEmail: emailtext, password: passwordtext) { [self] (result, error) in
                    if let error = error {
                        self.presentAlertController(withTitle: "Kayıt Olurken Hata Meydana Geldi", message: error.localizedDescription)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    let values = [EMAİL_FREF:emailtext,
                                  FULLNAME_FREF:fullnameText,
                                  TEL_NO_FREF:telNoText,
                                  ACCOUNT_TYPE_FREF: 0,
                                  USER_ID_FREF : uid] as [String : Any]
                    self.updateValues(uid: uid, values: values)
                    
                    let container = ContainerController()
                    container.configure()
                    self.navigationController?.pushViewController(container, animated: true)
                    self.navigationController?.modalPresentationStyle = .fullScreen
                }
            }else{
                presentAlertController(withTitle: "Hata Meydana Geldi", message: "Şifre Alanları Uyuşmuyor")
            }
        }else{
            self.presentAlertController(withTitle: "Boş Alan Bırakılamaz", message: "Lütfen Tüm Alanları Doldurunuz")
            return
        }
    }
    //MARK:-HelperFunctions
    fileprivate func updateValues(uid: String, values: [String : Any] ){
        Firestore.firestore().collection("Users").document(uid).setData(values) { (error) in
            if let error = error{
                debugPrint("DEBUG: FireStore Updata Data Error -- \(error.localizedDescription)")
            }
        }
        USER_REF.child(uid).updateChildValues(values) { (error, ref) in
            if let error = error{
                debugPrint("DEBUG: RealtimeDatabase Updata Data Error -- \(error.localizedDescription)")
            }
        }
    }
}
