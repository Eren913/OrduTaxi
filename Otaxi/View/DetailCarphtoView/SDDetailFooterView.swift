//
//  SDDetailFooterView.swift
//  Otaxi
//
//  Created by lil ero on 13.08.2020.
//

import UIKit

class SDDetailFooterView: UIView{
    
    //MARK:-Properties
    fileprivate let imageView: UIImageView = {
        return UIImageView().configureImageView()
    }()
    fileprivate let imageView1: UIImageView = {
        return UIImageView().configureImageView()
    }()
    fileprivate let imageView2: UIImageView = {
        return UIImageView().configureImageView()
    }()
    
    fileprivate var user: Rating!
    //MARK: -Lifecycle
    init(user: Rating,frame: CGRect){
        self.user = user
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        configureImageview()
        getCarPhoto()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-APi
    fileprivate func getCarPhoto(){
        _ = Service.shared.getDetailCarPhoto(imageView1: imageView, imageView2: imageView1, imageView3: imageView2, view: nil, uid: user.uid)
    }
    
    //MARK:- Helper Functions
    fileprivate func configureImageview(){
        addSubview(imageView)
        imageView.layer.cornerRadius = 10
        imageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: bounds.width, height: 250)
        addSubview(imageView1)
        imageView1.layer.cornerRadius = 10
        imageView1.anchor(top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: bounds.width, height: 250)
        addSubview(imageView2)
        imageView2.layer.cornerRadius = 10
        imageView2.anchor(top: imageView1.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: bounds.width, height: 250)
    }
}
