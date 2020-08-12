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
@objc protocol SettingsCellDelegate: class {
    func swicthSender(_ sender: UISwitch)
    func callButton(_ sender: UIButton)
}

enum SettingsSection: Int,CaseIterable,CustomStringConvertible{
    case Social
    case Communication
    case General
    
    var description: String{
        switch self {
        case .Social: return "Sağlık Ve Güvenlik"
        case .Communication: return "Bilgiler"
        case .General: return "Araç Bilgileri"
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
        case .plaka: return false
        }
    }
    
    case favorite
    case phone
    case plaka
    
    var description: String{
        switch self {
        case .favorite: return "Favorilere Ekle"
        case .phone: return "Tel No:"
        case .plaka: return "Plaka: "
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
    weak var delegate: SettingsCellDelegate?
    
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
        sw.isOn = false
        sw.addTarget(delegate, action: #selector(delegate?.swicthSender(_:)), for: .valueChanged)
        return sw
    }()
    lazy var callButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(delegate, action: #selector(delegate?.callButton(_:)), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "phone.fill")!.withTintColor(.white), for: .normal)
        return btn
    }()
    let callLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    let plakaLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
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
        
        addSubview(callButton)
        callButton.isHidden = true
        callButton.centerY(inView: self)
        callButton.anchor(right: rightAnchor,paddingRight: 12)
        
        addSubview(callLabel)
        callLabel.isHidden = true
        callLabel.centerY(inView: self)
        callLabel.anchor(left: leftAnchor,paddingLeft: 80)
        
        addSubview(plakaLabel)
        plakaLabel.isHidden = true
        plakaLabel.centerY(inView: self)
        plakaLabel.anchor(left: leftAnchor,paddingLeft: 70)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
