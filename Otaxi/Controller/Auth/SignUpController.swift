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
import GeoFire


class SignUpController : UIViewController{
    
    private let location = LocationHandler.shared.locationManager.location
    
    //MARK: Properties
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "ORDU"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
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
        return UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
    }()
    private lazy var fullNameContainer : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_account_box_white_2x.png") , textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    private lazy var passwordContainer : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x.png") , textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let signUpButton  :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sıgn Up", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    private let accountType : UISegmentedControl = {
        let sgmntCntrl = UISegmentedControl(items: ["Rider","Driver"])
        sgmntCntrl.backgroundColor = .backgroundColor
        sgmntCntrl.tintColor = UIColor(white: 1, alpha: 0.8)
        sgmntCntrl.selectedSegmentIndex = 0
        return sgmntCntrl
    }()
    private lazy var accountTypeContainer : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_account_box_white_2x.png") ,
                                               segmentedControl: accountType)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    
    private let alreadyHaveAccountButton : UIButton  = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Already Have A Accont ? ",attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        attributeTitle.append(NSAttributedString(string: "Sign in",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint
        ]))
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    
    //MARK:- Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
        
    }
    fileprivate func configureUI() {
        view.backgroundColor = .backgroundColor
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let sv = UIStackView(arrangedSubviews: [emailContainer,
                                                fullNameContainer,
                                                passwordContainer,
                                                accountTypeContainer,
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
        
        
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    //MARK:- Selectors
    @objc fileprivate func handleShowSignIn(){
        navigationController?.popViewController(animated: true)
    }
    @objc func signUpClicked(){
        
        guard let emailtext = emailTextField.text else {return}
        guard let passwordtext = passwordTextField.text else {return}
        guard let fullnameText = fullNameTextField.text else {return}
        
        let accountTypeIndex = accountType.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: emailtext, password: passwordtext) { [self] (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = [EMAİL_FREF:emailtext,
                          FULLNAME_FREF:fullnameText,
                          ACCOUNT_TYPE_FREF:accountTypeIndex] as [String : Any]
            
            
            if accountTypeIndex == 1 {
                let geoFire = GeoFire(firebaseRef: DRIVER_LOC_FREF)
                
                guard let loc = self.location else {return}
                geoFire.setLocation(loc, forKey: uid) { (error) in
                    if error != nil {
                        print("DEBUG: Saved Loacation successfly")
                        self.updateValues(uid: uid, values: values)
                    }else {
                        print("DEBUG: Error\(String(describing: error?.localizedDescription))")
                    }
                }
            }
            self.updateValues(uid: uid, values: values)
        }
    }
    //MARK:-HelperFunctions
    func updateValues(uid: String, values: [String : Any] ){
        USER_REF.child(uid).updateChildValues(values) { (error, ref) in
            let home = HomeController()
            home.configure()
            let nav = UINavigationController(rootViewController: home)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.navigationBar.isHidden = true
            self.present(nav, animated: true, completion: nil)
            
        }
    }
}


