//
//  BestTaxiDetail.swift
//  Otaxi
//
//  Created by lil ero on 30.07.2020.
//

import UIKit
import Cosmos
import JXReviewController
import Firebase


private let reuseIdentifier = "SettingsCell"

class StopsDriverDetail: UIViewController {
    
    // MARK: - Properties
    
    var ratingPoint: Int = 0{
        didSet{
            tableView.reloadData()
        }
    }
    var tableView: UITableView!
    var userInfoHeader: DetailInfoHeader!
    let settingCell: SettingsCell? = nil
    var selectedDriver : Rating!
    
    var begeniler = [Rating]()
    
    let fireStore = Firestore.firestore()
    
    let app = UIApplication.shared
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        userInfoHeader.usernameLabel.text = selectedDriver?.fullname
        userInfoHeader.initialLabel.text = selectedDriver?.firstInitial
        userInfoHeader.emailLabel.text = selectedDriver?.email
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getRating()
    }
    
    //MARK:-Api
    func setRating(){
        fireStore.runTransaction({ (transection, errorPointer) -> Any? in
            let selectedRatingPoint : DocumentSnapshot
            do{
                try selectedRatingPoint = transection.getDocument(self.fireStore.collection(USER_FREF).document(self.selectedDriver.uid))
            }catch let error as NSError{
                debugPrint("DEBUG: Puanlamada Hata oluştu...\(error.localizedDescription)")
                return nil
            }
            
            guard let eskisayi = (selectedRatingPoint.data()?[HEALTH_SCORE_FREF] as? Int) else {return nil}
            let secilenFikirRef = self.fireStore.collection(USER_FREF).document(self.selectedDriver.uid)
            if self.begeniler.count > 0 {
                //Kullanıcı daha önceden beğenmiş ve beğeniden çıkmak üzere
                transection.updateData([HEALTH_SCORE_FREF : eskisayi - self.ratingPoint], forDocument: secilenFikirRef)
            }else {
                //kullanıcı daha önce beğenmemeiş ve beğenmek üzere
                transection.updateData([HEALTH_SCORE_FREF : eskisayi + self.ratingPoint], forDocument: secilenFikirRef)
            }
            return nil
        }) { (nesne, error) in
            if let error = error {
                debugPrint("DEBUG: Puanlama Fonksiyonunda hata meydana geldi \(error.localizedDescription)")
            }
        }
        tableView.reloadData()
    }
    func getRating(){
        fireStore.collection(USER_FREF).document(selectedDriver.uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {print("DEBUG: Error fetching document: \(error!)")
                return}
            guard let data = document.data() else {print("DEBUG: Document data was empty.")
                return}
            let ratPoint = data[HEALTH_SCORE_FREF] as? Int ?? 0
            self.ratingPoint = ratPoint
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
    }
    func configureUI() {
        settingCell?.delegate = self
        configureTableView()
        configureNavigation()
    }
    func configureNavigation(){
        navigationController?.isNavigationBarHidden = false
    }
    func requestReview() {
        let reviewController = JXReviewController()
        reviewController.image = UIImage(systemName: "app.fill")
        reviewController.title = "Sürücünün Durumu"
        reviewController.message = "Yıldıza Dokun Ve Puanla"
        reviewController.delegate = self
        present(reviewController, animated: true)
    }
    private func callNumber(phoneNumber:String) {
        if let phone = URL(string: "tel://\(phoneNumber)"){
            if app.canOpenURL(phone){
                app.open(phone, options: [:], completionHandler: nil)
                print("DEBUG: successs Call")
            }
        }else{
            print("DEBUG: Fail Call")
        }
        
    }
    func setFavoriteTaxiData(favorite: Bool){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let way = fireStore.collection(USER_FREF).document(uid).collection("FavoriTaksiciler").document(selectedDriver.uid)
            way.setData([
                FAVORITE_TAXI: favorite],merge: true) { (error) in
                if let error = error {
                    self.presentAlertController(withTitle: "Taksici favorilere eklenirken Hata Meydana Geldi ", message: error.localizedDescription)
                }
        }
    }
}
//MARK:-UITableViewDelegate,UITableViewDataSource
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
        cell.cosmosView.rating = Double(self.ratingPoint)
        guard let section = SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        if indexPath.row == 1 {
            cell.callButton.isHidden = false
            cell.callLabel.isHidden = false
            cell.callLabel.text = selectedDriver.telNo
        }
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
    @objc func handleDuzenleTapped(sender: UIButton){
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        if sender.isSelected{
            sender.setTitle("Tamam", for: .selected)
            requestReview()
        }else{
        }
    }
    
    
}
//MARK:-JXReviewControllerDelegate
extension StopsDriverDetail: JXReviewControllerDelegate {
    func reviewController(_ reviewController: JXReviewController, didSubmitWith point: Int) {
        self.ratingPoint = point
        setRating()
    }
}
//MARK:- SettingsCellDelegate
extension StopsDriverDetail: SettingsCellDelegate{
    func callButton(_ sender: UIButton) {
        callNumber(phoneNumber: selectedDriver.telNo)
    }
    
    func swicthSender(_ sender: UISwitch) {
        if sender.isOn{
            setFavoriteTaxiData(favorite: true)
        }else{
            setFavoriteTaxiData(favorite: false)
        }
    }
}
