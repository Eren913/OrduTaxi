//
//  DetailInfo.swift
//  Otaxi
//
//  Created by lil ero on 30.07.2020.
//

import UIKit
import Firebase
class DetailInfoHeader: UIView {
    
    // MARK: - Properties
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .white
        return label
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var uploadImageView : UIImageView = {
        let img = UIImageView().configureImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    let status: UIView = {
        let view = UIView()
        return view
    }()
    var selectedDriver: Rating?
    // MARK: - Init
    
    init(user: Rating,frame: CGRect) {
        self.selectedDriver = user
        super.init(frame: frame)
        
        configureUI()
        configureInitalLabel()
        configureImageView()
        
        fetchStatus()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-Api
    fileprivate func fetchStatus(){
        guard let uid = selectedDriver?.uid else {return}
        _ = Service.shared.fetchUserData(uid: uid, completion: { (u) in
            if u.status != nil{
                if u.status == true {
                    self.status.backgroundColor = .green
                }else {
                    self.status.backgroundColor = .red
                }
            }else{
                self.status.backgroundColor = .backgroundColor
            }
            
        })
    }
    
    //MARK:-Helper function
    fileprivate func configureUI(){
        let profileImageDimension: CGFloat = 80
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor,paddingLeft: 16,width: profileImageDimension,height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.centerY(inView: profileImageView,constant: -10)
        usernameLabel.anchor(left:profileImageView.rightAnchor, paddingLeft: 12)

        addSubview(emailLabel)
        emailLabel.centerY(inView: profileImageView,constant: 10)
        emailLabel.anchor(left:profileImageView.rightAnchor ,paddingLeft: 12)
        
        addSubview(status)
        status.centerY(inView: self)
        status.anchor(right: rightAnchor, paddingRight: 25, width: 10, height: 10)
        status.layer.cornerRadius = 10/2
    }
    fileprivate func configureImageView(){
        addSubview(uploadImageView)
        uploadImageView.centerX(inView: profileImageView)
        uploadImageView.centerY(inView: profileImageView)
        uploadImageView.setDimensions(height: 80, width: 80)
        uploadImageView.layer.cornerRadius = 80 / 2
        uploadImageView.frame.size = CGSize(width: profileImageView.frame.size.width, height: profileImageView.frame.size.height)
    }
    fileprivate func configureInitalLabel(){
        profileImageView.addSubview(initialLabel)
        initialLabel.centerX(inView: profileImageView)
        initialLabel.centerY(inView: profileImageView)
    }
    
}
