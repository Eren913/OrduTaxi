//
//  DetailInfo.swift
//  Otaxi
//
//  Created by lil ero on 30.07.2020.
//

import UIKit
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
        let img = UIImageView().profileUploadImage()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let profileImageDimension: CGFloat = 80
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        configureInitalLabel()
        configureImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-Helper function
    func configureImageView(){
        addSubview(uploadImageView)
        uploadImageView.centerX(inView: profileImageView)
        uploadImageView.centerY(inView: profileImageView)
        uploadImageView.setDimensions(height: 65, width: 65)
        uploadImageView.layer.cornerRadius = 65 / 2
        uploadImageView.frame.size = CGSize(width: profileImageView.frame.size.width, height: profileImageView.frame.size.height)
    }
    func configureInitalLabel(){
        profileImageView.addSubview(initialLabel)
        initialLabel.centerX(inView: profileImageView)
        initialLabel.centerY(inView: profileImageView)
    }
    
}
