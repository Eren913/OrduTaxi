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
    
    private let location = LocationHandler.shared.locationManager.location
    let source = [
        "Cumhuriyet Taksi",
        "Çicek Taksi",
        "Birlik Taksi",
        "Sağlam Taksi",
        "Bucak Taksi",
        "Sağlık Taksi",
        "Yonca Taksi",
        "Başak Taksi",
        "Otogar Taksi",
        "Meydan Taksi",
        "Akyazı Taksi"]
    
    //MARK: Properties
    let stops = UIPickerView()
    
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
    private let telNoTextField : UITextField = {
        return UITextField().phoneTextField(withPlaceholder: "Telefon Numarası")
    }()
    
    private lazy var telNoContainer : UIView = {
        let view = UIView().inputContainerView(image: (UIImage(systemName: "phone.fill")!.withTintColor(.white)), textField: telNoTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let signUpButton  :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    private let accountType : UISegmentedControl = {
        let sgmntCntrl = UISegmentedControl(items: ["Yolcu","Taksici"])
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
    
    private let stopsTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Durağı Seç", isSecureTextEntry: false)
    }()
    
    private lazy var stopTextFieldContainer : UIView = {
        let view = UIView().inputContainerView(image: (UIImage(systemName: "mappin.circle.fill")!.withTintColor(.white)), textField: stopsTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let alreadyHaveAccountButton : UIButton  = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Hesabınız Varmı ? ",attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        attributeTitle.append(NSAttributedString(string: "Giriş Yap",attributes: [
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
        stopsTextField.inputView = stops
        stops.delegate = self
        stops.dataSource = self
        
        
    }
    fileprivate func configureUI() {
        createToolbar()
        view.backgroundColor = .backgroundColor
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let sv = UIStackView(arrangedSubviews: [emailContainer,
                                                fullNameContainer,
                                                telNoContainer,
                                                passwordContainer,
                                                accountTypeContainer,
                                                stopTextFieldContainer,
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
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc fileprivate func handleShowSignIn(){
        navigationController?.popViewController(animated: true)
    }
    @objc func signUpClicked(){
        guard let emailtext = emailTextField.text else {return}
        guard let passwordtext = passwordTextField.text else {return}
        guard let fullnameText = fullNameTextField.text else {return}
        guard let telNoText = telNoTextField.text else {return}
        guard let pickerindex = stopsTextField.text else {return}
        let accountTypeIndex = accountType.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: emailtext, password: passwordtext) { [self] (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            guard let uid = result?.user.uid else { return }
            if accountTypeIndex == 0{
                let values = [EMAİL_FREF:emailtext,
                              FULLNAME_FREF:fullnameText,
                              TEL_NO_FREF:telNoText,
                              ACCOUNT_TYPE_FREF:accountTypeIndex] as [String : Any]
                self.updateValues(uid: uid, values: values)
            }else if accountTypeIndex == 1{
                let values = [EMAİL_FREF:emailtext,
                              FULLNAME_FREF:fullnameText,
                              TEL_NO_FREF:telNoText,
                              DURAK_ISMI_FREF : pickerindex,
                              ACCOUNT_TYPE_FREF:accountTypeIndex] as [String : Any]
                self.updateValues(uid: uid, values: values)
            }
            let container = ContainerController()
            container.configure()
            self.navigationController?.pushViewController(container, animated: true)
            self.navigationController?.modalPresentationStyle = .fullScreen
        }
    }
    //MARK:-HelperFunctions
    func updateValues(uid: String, values: [String : Any] ){
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
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action:#selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        stopsTextField.inputAccessoryView = toolBar
    }
}
extension SignUpController:  UIPickerViewDelegate, UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return source[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: source[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        stopsTextField.text = source[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.text = source[row]
        return label
    }
}


