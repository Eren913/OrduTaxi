//
//  HealtyTaxiCell.swift
//  Otaxi
//
//  Created by lil ero on 10.08.2020.
//

import UIKit

class HealtyTaxiCell: UITableViewCell{
    
     lazy var profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
     lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .black
        return label
    }()
    
     lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
     lazy var durakName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    lazy var uploadImageView : UIImageView = {
        let img = UIImageView().profileUploadImage()
        img.isUserInteractionEnabled = true
        return img
    }()
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundColor
        
        
        
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 70, width: 70)
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor,
                                paddingTop: 10)
        addSubview(fullnameLabel)
        addSubview(durakName)
        fullnameLabel.centerX(inView: self)
        durakName.centerX(inView: self)
        fullnameLabel.anchor(top:profileImageView.bottomAnchor,paddingTop: 10)
        durakName.anchor(top:fullnameLabel.bottomAnchor,paddingTop: 10)
        
        configureImageView()
        configureInitalLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    //MARK:-Helper function
    func configureImageView(){
        addSubview(uploadImageView)
        uploadImageView.centerX(inView: profileImageView)
        uploadImageView.centerY(inView: profileImageView)
        uploadImageView.setDimensions(height: 70, width: 70)
        uploadImageView.layer.cornerRadius = 70 / 2
        uploadImageView.frame.size = CGSize(width: profileImageView.frame.size.width, height: profileImageView.frame.size.height)
    }
    func configureInitalLabel(){
        profileImageView.addSubview(initialLabel)
        initialLabel.centerX(inView: profileImageView)
        initialLabel.centerY(inView: profileImageView)
    }
}
