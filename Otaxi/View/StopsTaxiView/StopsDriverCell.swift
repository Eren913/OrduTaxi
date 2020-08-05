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
        view.addSubview(initialLabel)
        initialLabel.centerX(inView: view)
        initialLabel.centerY(inView: view)
        return view
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
