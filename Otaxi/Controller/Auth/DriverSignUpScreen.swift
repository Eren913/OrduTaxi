//
//  DriverSignUpScreen.swift
//  Otaxi
//
//  Created by lil ero on 8.08.2020.
//

import UIKit
import Firebase

class DriverSignUp: UIViewController{
    
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
        label.text = "OTaksi"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    //MARK:-
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
    //MARK:-
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Şifre", isSecureTextEntry: true)
    }()
    private lazy var passwordContainer : UIView = {
        let view = UIView().inputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x.png") , textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    //MARK:-
    private let telNoTextField : UITextField = {
        return UITextField().phoneTextField(withPlaceholder: "Telefon Numarası")
    }()
    
    private lazy var telNoContainer : UIView = {
        let view = UIView().inputContainerView(image: (UIImage(systemName: "phone.fill")!.withTintColor(.white)), textField: telNoTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let plakaTextField : UITextField = {
        return UITextField().phoneTextField(withPlaceholder: "Plakanız")
    }()
    
    private lazy var plakaContainer : UIView = {
        let view = UIView().inputContainerView(image: (UIImage(systemName: "tag.fill")!.withTintColor(.white)), textField: plakaTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    //MARK:-
    private let signUpButton  :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.backgroundColor = .mainBlueTint
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    //MARK:-
    private let stopsTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Durağı Seç", isSecureTextEntry: false)
    }()
    
    private lazy var stopTextFieldContainer : UIView = {
        let view = UIView().inputContainerView(image: (UIImage(systemName: "mappin.circle.fill")!.withTintColor(.white)), textField: stopsTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    //MARK:-
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
    private let alreadyHaveADriver : UIButton  = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Yolcumusunuz ? ",attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        attributeTitle.append(NSAttributedString(string: "Kayıt Ol",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
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
    override func viewDidLayoutSubviews() {
        signUpButton.layer.insertSublayer(CALayer.gradientLayer(frame: signUpButton.bounds), at: 0)
    }
    //MARK:- HelperFunctions
    
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
                                                stopTextFieldContainer,
                                                plakaContainer,
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
        
        
        view.addSubview(alreadyHaveADriver)
        alreadyHaveADriver.centerX(inView: view)
        alreadyHaveADriver.anchor(top: sv.bottomAnchor, paddingTop: 10)
        
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
        guard let plaka = plakaTextField.text else {return}
        
        if emailTextField.text != "" && passwordTextField.text != "" && fullNameTextField.text != "" && telNoTextField.text != "" && stopsTextField.text != "" && plakaTextField.text != ""{
            Auth.auth().createUser(withEmail: emailtext, password: passwordtext) { [self] (result, error) in
                if let error = error {
                    self.presentAlertController(withTitle: "Kayıt Olurken Hata Meydana Geldi", message: error.localizedDescription)
                    return
                }
                guard let uid = result?.user.uid else { return }
                let values = [EMAİL_FREF       : emailtext,
                              FULLNAME_FREF    : fullnameText,
                              TEL_NO_FREF      : telNoText,
                              DURAK_ISMI_FREF  : pickerindex,
                              ACCOUNT_TYPE_FREF: 1,
                              USER_ID_FREF     : uid,
                              PLAKA_FREF       : plaka] as [String : Any]
                self.updateValues(uid: uid, values: values)
                
                let container = ContainerController()
                container.configure()
                self.navigationController?.pushViewController(container, animated: true)
                self.navigationController?.modalPresentationStyle = .fullScreen
            }
        }else{
            self.presentAlertController(withTitle: "Boş Alan Bırakılamaz", message: "Lütfen Tüm Alanları Doldurunuz")
            return
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
extension DriverSignUp:  UIPickerViewDelegate, UIPickerViewDataSource{
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


