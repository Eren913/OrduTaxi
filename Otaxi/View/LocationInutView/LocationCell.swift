//
//  LocationCell.swift
//  OrduTaxi
//
//  Created by lil ero on 19.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    
    var placemark : MKPlacemark? {
        didSet{
            titlelabel.text = placemark?.name
            adressLabel.text = placemark?.address
        }
    }
    //MARK:- Properties
    let titlelabel : UILabel = {
       let label = UILabel()
        label.text = "123 M Streed"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
     let adressLabel : UILabel = {
       let label = UILabel()
        label.text = "1234 sub Title"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //MARK:-Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let stack = UIStackView(arrangedSubviews: [titlelabel,adressLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
