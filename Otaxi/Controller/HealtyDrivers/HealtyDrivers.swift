//
//  fff.swift
//  Otaxi
//
//  Created by lil ero on 10.08.2020.
//

import UIKit

class HealtyDrivers : UIViewController{
    //MARK: -Propeties
    private let healtyTaxiButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(healtyTaxiButton)
        healtyTaxiButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                right: view.rightAnchor,
                                paddingTop: 16,
                                paddingRight: 20,
                                width: 50,
                                height: 50)
    }
    //MARK: -Selectors
    @objc fileprivate func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
    //MARK: -HelperFunc
    
    
    //MARK: -Api
}
