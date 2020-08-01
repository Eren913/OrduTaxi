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
        case .Social: return "Social"
        case .Communication: return "Communication"
        }
    }
}
enum SocialSection: Int,CaseIterable,SectionType{
    var containsSwitch: Bool { return true }
    
    case rating
    
    var description: String{
        switch self {
        case .rating: return "Puan"
        }
    }
}
enum CommunicationSection: Int,CaseIterable,SectionType{
    
    var containsSwitch: Bool {
        switch self{
        case .favorite : return true
        }
    }
    
    case favorite
    
    var description: String{
        switch self {
        case .favorite: return "Favorite"
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
    
    // MARK: - Init
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        //view.settings.updateOnTouch = true
        view.settings.filledImage = UIImage(named: "RatingStarFilled")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "RatingStarEmpty")?.withRenderingMode(.alwaysOriginal)
        view.settings.totalStars = 5
        view.settings.starSize = 24
        view.settings.starMargin = 4
        view.settings.fillMode = .precise
        view.settings.textColor = .red
        view.settings.textMargin = 20
        
        return view
    }()
    lazy var swicthControl: UISwitch = {
       let sw = UISwitch()
        sw.isOn = true
        sw.addTarget(self, action: #selector(handleSwitchControl), for: .valueChanged)
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cosmosView)
        cosmosView.anchor(left: rightAnchor , paddingLeft: 12)
        addSubview(swicthControl)
        swicthControl.centerY(inView: self)
        swicthControl.anchor(right: rightAnchor,paddingRight: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleSwitchControl(sender: UISwitch){
        if sender.isOn{
         print("DEBUG: switch on")
        }else {
            print("DEBUG: switch ooff")
        }
    }
    
}
