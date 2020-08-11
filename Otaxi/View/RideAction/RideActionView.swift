//
//  RideActionView.swift
//  Otaxi
//
//  Created by lil ero on 22.07.2020.
//

import UIKit
import MapKit
import CoreLocation
protocol RideActionViewDelegate: class{
    func configureActionButton()
}

class RideActionView: UIView{
    
    var destination : MKPlacemark? {
        didSet{
            titleLabel.text = destination?.name
            adressLabel.text = destination?.address
            _ = distance(to: destination!.coordinate, distance: uberXLabel)
           //distancecalcutor()
        }
    }
    var currentCoordinate: CLLocationCoordinate2D?
    //MARK: - Properties
    weak var delegate: RideActionViewDelegate?
    let titleLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    let adressLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var infoView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "X"
        
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        return view
    }()
    let uberXLabel : UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 18)
         label.textAlignment = .center
         return label
     }()
    private let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Tamam", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,adressLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.centerX(inView: self)
        stackView.anchor(top: topAnchor,paddingTop: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top: stackView.bottomAnchor,paddingTop: 16)
        infoView.setDimensions(height: 60, width: 60)
        infoView.layer.cornerRadius = 60 / 2
        
        addSubview(uberXLabel)
        uberXLabel.anchor(top: infoView.bottomAnchor,paddingTop: 8)
        uberXLabel.centerX(inView: self)
        
        let sepratorView = UIView()
        sepratorView.backgroundColor = .lightGray
        addSubview(sepratorView)
        sepratorView.anchor(top: uberXLabel.bottomAnchor,
                            left: leftAnchor ,
                            right: rightAnchor,
                            paddingTop: 4,
                            height: 0.75)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,
                            right: rightAnchor, paddingLeft: 12, paddingBottom: 12,
                            paddingRight: 12, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- Selectors
    @objc fileprivate func actionButtonPressed(){
        delegate?.configureActionButton()
    }
    //MARK:-Helper Func
    func distance(to: CLLocationCoordinate2D,distance: UILabel) -> CLLocationDistance {
        guard let currenLocation = currentCoordinate else {return 0.00}
        let from = CLLocation(latitude: currenLocation.latitude, longitude: currenLocation.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let dis = from.distance(from: to) / 1000
        distance.text = String(format: "Ortalama Mesafe %.01fkm", dis)
        return dis
    }
}
