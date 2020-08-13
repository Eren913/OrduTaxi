//
//  SDDetailFooterView.swift
//  Otaxi
//
//  Created by lil ero on 13.08.2020.
//

import UIKit

class SDDetailFooterView: UIView{
    
    //MARK:-Properties
    let imageView: UIImageView = {
        let img  = UIImageView()
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = #imageLiteral(resourceName: "Human")
        return img
    }()
    
    
    //MARK: -Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        addSubview(imageView)
        imageView.layer.cornerRadius = 10
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, width: bounds.width, height: 400)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-APi
    
    //MARK:- Helper Functions
}
