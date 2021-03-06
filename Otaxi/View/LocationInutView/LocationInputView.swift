//
//  LocationInputView.swift
//  OrduTaxi
//
//  Created by lil ero on 19.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
protocol LocationInputViewDelegate : class {
    func dismissLocationInputView()
    func excuteSearch(query: String)
}

class LocationInputView: UIView {
    
    //MARK:-Properties
    var user: User? {
        didSet{
            titlelabel.text = user?.fullname
        }
    }
    weak var delegate : LocationInputViewDelegate?
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
   private let titlelabel : UILabel = {
       let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let startLocationIndicatorView : UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let linkingView : UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let destinationIndicatorView : UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var startingLocationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şuanki Konum"
        tf.backgroundColor = .lightGray
        tf.isEnabled = false
        tf.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    private lazy var destinationLocationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Gidilecek Yer"
        tf.backgroundColor = .lightGray
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .default
        tf.delegate = self
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    
    
    //MARK:-Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: 44,
                          paddingLeft: 13,
                          width: 24,
                          height: 25)
        
        addSubview(titlelabel)
        titlelabel.centerY(inView: backButton)
        titlelabel.centerX(inView: self)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: backButton.bottomAnchor,
                                         left: leftAnchor,
                                         right: rightAnchor,
                                         paddingTop: 4,
                                         paddingLeft: 40,
                                         paddingRight: 40,
                                         height: 30)
        
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor,
                                            left: leftAnchor,
                                            right: rightAnchor,
                                            paddingTop: 14,
                                            paddingLeft: 40,
                                            paddingRight: 40,
                                            height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inView: startingLocationTextField,
                                           leftAnchor: leftAnchor,
                                           paddingLeft: 20)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextField,
                                         leftAnchor: leftAnchor,
                                         paddingLeft: 20)
        destinationIndicatorView.setDimensions(height: 6, width: 6)
        destinationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.anchor(top:startLocationIndicatorView.bottomAnchor,
                           bottom: destinationIndicatorView.topAnchor,
                           paddingTop: 4,
                           paddingBottom: 4,
                           width: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-Selectors
    
    @objc func handleBackTapped(){
        delegate?.dismissLocationInputView()
    }
}
//MARK:-UITextFieldDelegate
extension LocationInputView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {return false}
        delegate?.excuteSearch(query: query)
        return true
    }
}
