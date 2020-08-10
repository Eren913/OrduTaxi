//
//  fff.swift
//  Otaxi
//
//  Created by lil ero on 10.08.2020.
//
let tableViewIDHC = "tableViewIDHC"
import UIKit

class HealtyDrivers : UIViewController{
    //MARK: -Propeties
    private let healtyTaxiButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    private let tableView = UITableView()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureUI()
        configureTableView()
        
    }
    //MARK: -Selectors
    @objc fileprivate func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
    //MARK: -HelperFunc
    fileprivate func configureUI(){
        view.addSubview(healtyTaxiButton)
        healtyTaxiButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                right: view.rightAnchor,
                                paddingTop: 16,
                                paddingRight: 20,
                                width: 50,
                                height: 50)
    }
    
    fileprivate func configureTableView(){
        tableView.backgroundColor = .backgroundColor
        tableView.frame = CGRect(x: 0, y: +120, width: view.bounds.width, height: view.bounds.height)
        tableView.register(HealtyTaxiCell.self, forCellReuseIdentifier: tableViewIDHC)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
    }
    
    //MARK: -Api
}
extension HealtyDrivers: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIDHC, for: indexPath) as! HealtyTaxiCell
        if indexPath.row == 0 {
            cell.fullnameLabel.text = "Eren"
            cell.initialLabel.text = "E"
            cell.durakName.text = "Cumhuriyet Taxi"
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
