//
//  BestTaxiDetail.swift
//  Otaxi
//
//  Created by lil ero on 30.07.2020.
//

import UIKit
import Cosmos
import JXReviewController


private let reuseIdentifier = "SettingsCell"

class StopsDriverDetail: UIViewController {
    
    // MARK: - Properties
    
    var inter: Int = 0{
        didSet{
            tableView.reloadData()
        }
    }
    var cosmosTouches: Double = 0
    
    var tableView: UITableView!
    var userInfoHeader: DetailInfoHeader!
    let settingCell: SettingsCell? = nil
    var selectedDriver : Drivers?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        userInfoHeader.usernameLabel.text = selectedDriver?.fullname
        userInfoHeader.initialLabel.text = selectedDriver?.firstInitial
        userInfoHeader.emailLabel.text = selectedDriver?.email
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    private func callNumber(phoneNumber:String) {
        
        if let url = URL(string: "tel://\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    // MARK: - Helper Functions
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        let frame = CGRect(x: 0, y: 100, width: tableView.frame.width, height: 100)
        userInfoHeader = DetailInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.canCancelContentTouches = true
        tableView.tableFooterView = UIView()
        
    }
    
    func configureUI() {
        configureTableView()
        configureNavigation()
    }
    func configureNavigation(){
        navigationController?.isNavigationBarHidden = false
    }
    func requestReview() {
        let reviewController = JXReviewController()
        reviewController.image = UIImage(systemName: "app.fill")
        reviewController.title = "Enjoy it?"
        reviewController.message = "Tap a star to rate it."
        reviewController.delegate = self
        present(reviewController, animated: true)
    }
    
}

extension StopsDriverDetail: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .blue
        let btn = UIButton()
        btn.setTitle("Düzenle", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(handleDuzenleTapped), for: .touchUpInside)
        if section == 0{
            view.addSubview(btn)
            btn.centerY(inView: view)
            btn.anchor(right: view.rightAnchor,paddingRight: 12)
        }
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.centerY(inView: view)
        title.anchor(left: view.leftAnchor,paddingLeft: 16)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else {return 0}
        switch section {
        case .Social: return SocialSection.allCases.count
        case .Communication: return CommunicationSection.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        cell.selectionStyle = .none
        cell.cosmosView.settings.updateOnTouch = false
        cell.cosmosView.rating = Double(self.inter)
        guard let section = SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .Social:
            let social = SocialSection(rawValue: indexPath.row)
            cell.sectionType = social
            cell.swicthControl.isHidden = true
            
        case .Communication:
            let communication = CommunicationSection(rawValue: indexPath.row)
            cell.sectionType = communication
            cell.cosmosView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.row) else {return}
        switch section {
        case .Social:
            print(SocialSection(rawValue: indexPath.row)!)
        case .Communication:
            print(CommunicationSection(rawValue: indexPath.row)!)
        }
        
    }
    @objc func handleDuzenleTapped(sender: UIButton,update: Bool){
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        
        if sender.isSelected{
            sender.setTitle("Tamam", for: .selected)
            requestReview()
        }
    }
    
    
}
extension StopsDriverDetail: JXReviewControllerDelegate {

    func reviewController(_ reviewController: JXReviewController, didSelectWith point: Int) {
        print("DEBUG:Did select with \(point) point(s).")
    }

    func reviewController(_ reviewController: JXReviewController, didCancelWith point: Int) {
        print("DEBUG:Did cancel with \(point) point(s).")
    }

    func reviewController(_ reviewController: JXReviewController, didSubmitWith point: Int) {
        print("DEBUG: Did submit with \(point) point(s).")
        self.inter = point
        print("DEBUG: Did submit with \(self.inter) inters(s).")
    }
}
