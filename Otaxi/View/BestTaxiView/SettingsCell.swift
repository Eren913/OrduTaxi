//
//  SettingsCell.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Cosmos
class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
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
        view.text = "Sağlık Puanı"
        view.settings.textColor = .red
        view.settings.textMargin = 20
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cosmosView)
        cosmosView.anchor(left: leftAnchor , paddingLeft: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
