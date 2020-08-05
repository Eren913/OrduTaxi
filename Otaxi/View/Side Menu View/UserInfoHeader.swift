//
//  UserInfoHeader.swift
//  UberTutorial
//
//  Created by Stephen Dowless on 9/23/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Firebase

class UserInfoHeader: UIView {
    
    // MARK: - Properties
    
    private let user: User
    
    private lazy var profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var uploadImageView : UIImageView = {
        let img = UIImageView().profileUploadImage()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .white
        label.text = user.firstInitial
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = user.fullname
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = user.email
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        profileImageView.setDimensions(height: 65, width: 65)
        profileImageView.layer.cornerRadius = 65 / 2
        
        configureImageView()
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: profileImageView,
                      leftAnchor: profileImageView.rightAnchor,
                      paddingLeft: 12)
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
