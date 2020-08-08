//
//  BestTaxiCell.swift
//  Otaxi
//
//  Created by lil ero on 28.07.2020.
//

import UIKit
import MapKit
import Cosmos

class StopsDriverCell: UITableViewCell {
    
    // MARK: - Properties
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .white
        return label
    }()
    lazy var profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    lazy var uploadImageView : UIImageView = {
        let img = UIImageView().profileUploadImage()
        img.isUserInteractionEnabled = true
        return img
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [nameLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.centerY(inView: self)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor,left: safeAreaLayoutGuide.leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,paddingTop: 10,paddingLeft: 12,paddingBottom: 10)
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10)
        stack.anchor(width: self.bounds.width,height: 80)
        
        configureImageView()
        configureInitalLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureImageView(){
        addSubview(uploadImageView)
        uploadImageView.centerX(inView: profileImageView)
        uploadImageView.centerY(inView: profileImageView)
        uploadImageView.setDimensions(height: 80, width: 80)
        uploadImageView.layer.cornerRadius = 80 / 2
        uploadImageView.frame.size = CGSize(width: profileImageView.frame.size.width, height: profileImageView.frame.size.height)
    }
    func configureInitalLabel(){
        profileImageView.addSubview(initialLabel)
        initialLabel.centerX(inView: profileImageView)
        initialLabel.centerY(inView: profileImageView)
    }
}
