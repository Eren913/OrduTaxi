//
//  LoginController.swift
//  OrduTaxi
//
//  Created by lil ero on 16.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
    //MARK:- Properties
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
    private lazy var emailcontainerView : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_mail_outline_white_2x.png"), textField: emailTextField )
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let emailTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private lazy var passwordcontainerView :UIView = {
        let view =  UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Şifre", isSecureTextEntry: true)
    }()
    private let loginButton: UIButton = {
        return UIButton().configButton(title: "Giriş Yap", selector: #selector(handlesignIn))
    }()
    private let dontHaveaAccountButton: UIButton = {
        return UIButton().stringButton(title: "Hesabınız Yokmu ? ", buttonTitle: "Kayıt Ol", selector: #selector(handleShowSignUp))
    }()
    private let forgotPassword: UIButton = {
        return UIButton().stringButton(title: "", buttonTitle: "Şifemi Unuttum", selector: #selector(handleforgotPassword))
    }()
    
    //MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        loginButton.layer.insertSublayer(CALayer.gradientLayer(frame: loginButton.bounds), at: 0)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:- Selectors
    @objc func handleShowSignUp(){
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    @objc func handlesignIn(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else {return}
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
                if let error = error {
                    self.presentAlertController(withTitle: "Kullanıcı Adı Veya Şifre Yanlış", message: error.localizedDescription)
                }
                let container = ContainerController()
                container.configure()
                self.navigationController?.pushViewController(container, animated: true)
                self.navigationController?.modalPresentationStyle = .fullScreen
            }
        }else{
            self.presentAlertController(withTitle: "Boş Bıraklımaz", message: "Lütfen Tüm Alanları Doldurun")
            return
        }
    }
    @objc fileprivate func handleforgotPassword(){
        let vc = PasswordResetScreen()
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:-Helper Func
    fileprivate func configureUI() {
        configureNavigationBar()
        self.hideKeyboard()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let stack = UIStackView(arrangedSubviews: [emailcontainerView,passwordcontainerView,loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 40,
                     paddingLeft: 16,
                     paddingRight: 16)
        view.addSubview(linkingView)
        linkingView.centerX(inView: view)
        linkingView.anchor(top:stack.bottomAnchor,
                           paddingTop: 70,
                           width: view.bounds.width / 1,height: 0.5)
        
        view.addSubview(forgotPassword)
        forgotPassword.anchor(bottom: linkingView.topAnchor,right: view.rightAnchor,paddingBottom: 10,paddingRight: 20)
        
        
        view.addSubview(dontHaveaAccountButton)
        dontHaveaAccountButton.centerX(inView: view)
        dontHaveaAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,height: 32)
    }
    func configureNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
}
