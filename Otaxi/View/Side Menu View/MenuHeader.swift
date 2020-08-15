//
//  MenuHeader.swift
//  UberTutorial
//
//  Created by Stephen Dowless on 9/23/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class MenuHeader: UIView {
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    fileprivate var statusArray: [Bool] = []
    
    let user : User?
    private lazy var profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .white
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    lazy var uploadImageView : UIImageView = {
        let img = UIImageView().configureImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    private let status: UISwitch = {
        let s = UISwitch()
        s.tintColor = .white
        s.onTintColor = .mainBlueTint
        s.addTarget(self, action: #selector(handleStatus(_:)), for: .valueChanged)
        return s
    }()
    let pickupModeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 1.0, alpha: 0.9)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    // MARK: - Lifecycle
    
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 10, paddingLeft: 12,
                                width: 64, height: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        
        initialLabel.text = user.firstInitial
        fullnameLabel.text = user.fullname
        emailLabel.text = user.email
        
        configureInitalLabel()
        configureImageView()
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: profileImageView,
                      leftAnchor: profileImageView.rightAnchor,
                      paddingLeft: 12)
        
        if user.status != nil{
            user.status == true ? configureSwitch(enabled: true) : configureSwitch(enabled: false)
        }else{
            configureSwitch(enabled: false)
        }
        
        getStatusState()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc fileprivate func handleStatus(_ sender: UISwitch){
        if status.isOn{
            configureSwitch(enabled: true)
            self.setStatus(status: true)
        }else{
            configureSwitch(enabled: false)
            self.setStatus(status: false)
        }
    }
    
    // MARK: - Api
    fileprivate func getStatusState(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        _ = Service.shared.fetchStatus(uid: uid)
    }
    fileprivate func setStatus(status: Bool){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        db.collection(USER_FREF).document(uid).setData(["Status": status], merge: true) { (error) in
            if let error = error{
                print("DEBUG: Fatal error updating status \(error.localizedDescription)")
                return
            }
        }
        USER_REF.child(uid).updateChildValues(["Status": status]) { (error, ref) in
            if let error = error{
                debugPrint("DEBUG: RealtimeDatabase Updata Data Error -- \(error.localizedDescription)")
            }
        }
        
    }
    
    //MARK:-Helper function
    fileprivate func configureImageView(){
        addSubview(uploadImageView)
        uploadImageView.centerX(inView: profileImageView)
        uploadImageView.centerY(inView: profileImageView)
        uploadImageView.setDimensions(height: 65, width: 65)
        uploadImageView.layer.cornerRadius = 65 / 2
        uploadImageView.frame.size = CGSize(width: profileImageView.frame.size.width, height: profileImageView.frame.size.height)
    }
    fileprivate func configureInitalLabel(){
        profileImageView.addSubview(initialLabel)
        initialLabel.centerX(inView: profileImageView)
        initialLabel.centerY(inView: profileImageView)
    }
    func configureSwitch(enabled: Bool) {
        if user?.accountType == .driver {
            addSubview(pickupModeLabel)
            pickupModeLabel.anchor(left: leftAnchor,bottom: bottomAnchor,paddingLeft: 16, paddingBottom: 17)
            addSubview(status)
            status.isOn = enabled
            status.anchor(left: pickupModeLabel.rightAnchor,bottom: bottomAnchor,paddingLeft: 14,paddingBottom: 10)
            pickupModeLabel.text = enabled ? "Durumunuz: Müsait" : "Durumunuz: Meşgul"
        }
    }
}
