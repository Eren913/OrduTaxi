//
//  SDHeader.swift
//  Otaxi
//
//  Created by lil ero on 15.08.2020.
//

import UIKit

class SDHeader : UIView{
    
    //MARK:-Properties
    
    var selectedStop : CustomAnnotation!
    let app = UIApplication.shared
    private let adressLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Light", size: 16)
        lbl.numberOfLines = 1
        return lbl
    }()
    private let telNo: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Light", size: 16)
        return lbl
    }()
    private var callButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(handlecallButton), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "phone.fill")!.withTintColor(.white), for: .normal)
        return btn
    }()
    
    //MARK:-LifeCycle
    init(stop: CustomAnnotation,frame: CGRect) {
        self.selectedStop = stop
        super.init(frame: frame)
        configureUI()
        getinfoStops()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-HelperFunc
    fileprivate func configureUI(){
        addSubview(adressLabel)
        adressLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,right: rightAnchor, paddingTop: 10, paddingLeft: 20,paddingRight: 12)
        addSubview(telNo)
        telNo.anchor(top: adressLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 20)
        addSubview(callButton)
        callButton.centerY(inView: telNo)
        callButton.anchor(right: rightAnchor,paddingRight: 12)
    }
    
    //MARK:-Api
    fileprivate func getinfoStops(){
        guard let tel = selectedStop.telNo else {return}
        guard let adress = selectedStop.adress else {return}
        adressLabel.text = "Adres: \(adress)"
        telNo.text = "Telefon numarası: \(tel)"
    }
    
    //MARK:-Selectors
    @objc fileprivate func handlecallButton(){
        let alert = UIAlertController(title: nil, message: "Durağı Aramak İstiyormusunuz", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            if let phone = URL(string: "tel://\(self.selectedStop.telNo!)"){
                if self.app.canOpenURL(phone){
                    self.app.open(phone, options: [:], completionHandler: nil)
                    print("DEBUG: Stops Driver Header successs Call")
                }
            }else{
                print("DEBUG: Stops Driver Header Fail Call")
            }
        })
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
