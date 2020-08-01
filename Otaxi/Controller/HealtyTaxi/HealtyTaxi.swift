//
//  HealtyTaxi.swift
//  Otaxi
//
//  Created by lil ero on 1.08.2020.
//
let healtyTaxiTableViewIdentifier = "id"
import UIKit
import Cosmos



class HealtyTaxi: UIViewController{
    
    //MARK: - Properties
    let tableView = UITableView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureTableView()
        configureNavigation(title: "Sağlıklı Taksiciler")
        
    }
    //MARK:-Helper Functions
    func configureTableView(){
        tableView.frame = view.bounds
        tableView.register(HealtyTaxiCell.self, forCellReuseIdentifier: healtyTaxiTableViewIdentifier)
        view.addSubview(tableView)
    }
    func configureNavigation(title: String){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    //MARK:-Api
    
    
    //MARK:- Selectors
}
//MARK:- Extensions
extension HealtyTaxi: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: healtyTaxiTableViewIdentifier, for: indexPath) as! HealtyTaxiCell
        cell.accessoryType = .detailButton
        cell.nameLabel.text = "Eren"
        cell.stopLabel.text = "Cumhuriyet Taksi"
        cell.initialLabel.text = "E"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeDetail = StopsDriverDetail()
        navigationController?.pushViewController(homeDetail, animated: true)
    }
    
    
}
