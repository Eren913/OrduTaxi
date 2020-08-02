//
//  SettingsCell.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Cosmos

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int,CaseIterable,CustomStringConvertible{
    case Social
    case Communication
    
    var description: String{
        switch self {
        case .Social: return "Sağlık Ve Güvenlik"
        case .Communication: return "Bilgiler"
        }
    }
}
enum SocialSection: Int,CaseIterable,SectionType{
    var containsSwitch: Bool {return true}
    
    case rating
    
    var description: String{
        switch self {
        case .rating: return "Sağlık puanı"
        }
    }
}
enum CommunicationSection: Int,CaseIterable,SectionType{
    
    var containsSwitch: Bool {
        switch self{
        case .favorite : return true
        case .phone: return false
        case .carModel: return false
        }
    }
    
    case favorite
    case phone
    case carModel
    
    var description: String{
        switch self {
        case .favorite: return "Favorilere Ekle"
        case .phone: return "Tel No: +905321233245"
        case .carModel: return "Arac Model: Dacia Duster"
        }
    }
}

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    var sectionType : SectionType? {
        didSet{
            guard let sectionType = sectionType else { return }
            textLabel?.text  = sectionType.description
            swicthControl.isHidden = !sectionType.containsSwitch
            cosmosView.isHidden = !sectionType.containsSwitch
        }
    }
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = true
        view.settings.filledImage = UIImage(named: "RatingStarFilled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "RatingStarEmpty")?.withRenderingMode(.alwaysOriginal)
        view.settings.totalStars = 5
        view.settings.starSize = 24
        view.settings.starMargin = 4
        view.settings.fillMode = .full
        return view
    }()
    lazy var swicthControl: UISwitch = {
       let sw = UISwitch()
        sw.isOn = true
        sw.addTarget(self, action: #selector(handleSwitchControl), for: .valueChanged)
        return sw
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cosmosView)
        cosmosView.centerY(inView: self)
        cosmosView.anchor(right: rightAnchor , paddingLeft: 12)
        addSubview(swicthControl)
        swicthControl.centerY(inView: self)
        swicthControl.anchor(right: rightAnchor,paddingRight: 12)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- Selectors
    @objc func handleSwitchControl(sender: UISwitch){
        if sender.isOn{
        }else {
            
        }
    }
}
