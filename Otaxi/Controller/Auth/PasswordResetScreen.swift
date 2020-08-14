//
//  PasswordResetScreen.swift
//  Otaxi
//
//  Created by lil ero on 14.08.2020.
//

import UIKit
import FirebaseAuth

class PasswordResetScreen: UIViewController{
    //MARK:-Properties
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "OTaksi"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    private lazy var emailcontainerView : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_mail_outline_white_2x.png"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let emailTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    private let resetButton: UIButton = {
        return UIButton().configButton(title: "Reset", selector: #selector(resetToPassword))
    }()
    private let backbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backToVc), for: .touchUpInside)
        return button
    }()
    //MARK:-Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK:-HelperFunctions
    fileprivate func configureUI(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .backgroundColor
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        view.addSubview(backbutton)
        backbutton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 20,paddingLeft: 20)
        
        let stack = UIStackView(arrangedSubviews: [emailcontainerView,
                                                   resetButton])
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: titleLabel.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 60,
                     paddingLeft: 16,
                     paddingRight: 16)
    }
    override func viewWillLayoutSubviews() {
        self.resetButton.addHorizontalGradientLayer()
    }
    //MARK:-Api
    @objc fileprivate func resetToPassword(){
        self.shouldPresentLoadingView(true, message: "Yükleniyor")
        guard let email = emailTextField.text else {return}
        if email != ""{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error{
                    self.shouldPresentLoadingView(false)
                    self.presentAlertController(withTitle: "Hata Meydana Geldi", message: "Şifre Sıfırlanamadı \(error.localizedDescription)") { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.shouldPresentLoadingView(false)
                    self.presentAlertController(withTitle: "Başarılı", message: "Şifre Sıfırlama İşleminiz Başarıyla Gerçekleşmiştir Posta Kutunuzu Kontrol Edin") { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else{
            self.presentAlertController(withTitle: "Hata", message: "Alan Boş Bırakılamaz")
        }
    }
    //MARK:-Selectors
    @objc fileprivate func backToVc(){
        navigationController?.popViewController(animated: true)
    }
}
