//
//  HomeController.swift
//  OrduTaxi
//
//  Created by lil ero on 18.07.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

private let reuseIdentifer = "LocationCell"

class HomeController : UIViewController{
    //MARK:- Properties
    private let mapView = MKMapView()
    private let locationMeneger = LocationHandler.shared.locationManager
    
    
    private let inputActivationView = LocationInputViewActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private final let locationInputViewHeight: CGFloat = 200
    
    private var searchResults = [MKPlacemark]()
    
    private var user : User? {
        didSet{
            locationInputView.user = user
        }
    }
    
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        //signOut()
        checkUserLoggedIn()
        configureUI()
        enableLocationServices()
        
        
    }
    //MARK:-Api
    
    func fetchUserData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchUserData(uid: uid) { user in
            self.user = user
        }
    }
    func fetchDriverData(){
        guard let location = locationMeneger?.location else {return}
        Service.shared.fetchDrivers(location: location) { (driver) in
            guard let coordinate = driver.location?.coordinate else {return}
            let annotation =  DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            print("DEBUG: Driver location \(coordinate)")
            var driverIsVisible : Bool {
                return self.mapView.annotations.contains { (anno) -> Bool in
                    guard let annotation = anno as? DriverAnnotation else {return false}
                    
                    if annotation.uid == driver.uid{
                        print("DEBUG: handle update driver location")
                        annotation.updateAnnotationLocations(withLocations: coordinate)
                        return true
                    }
                    return false
                }
            }
            if !driverIsVisible{
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    func checkUserLoggedIn(){
        presentLoginController()
    }
    func presentLoginController() {
        if Auth.auth().currentUser?.uid == nil{
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.isModalInPresentation = true
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else {
            configure()
        }
        
    }
    //MARK:- Helper Functions
    func configure(){
        configureUI()
        fetchUserData()
        fetchDriverData()
    }
    
    func configureUI(){
        configureMapView()
        navigationController?.navigationBar.isHidden = true
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
        configureTableView()
        
    }
    func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func configureLocationInputView(){
        view.addSubview(locationInputView)
        locationInputView.delegate = self
        locationInputView.anchor(top: view.topAnchor,
                                 left : view.leftAnchor,
                                 right: view.rightAnchor,
                                 height: locationInputViewHeight)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.4) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
        
    }
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.rowHeight = 60
        //Remove to Empty seperator
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0,
                                 y: view.frame.height,
                                 width: view.frame.width,
                                 height: height)
        view.addSubview(tableView)
    }
    func signOut(){
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.isModalInPresentation = true
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }catch{
            print("DEBUG: SignOut Error")
        }
    }
    
    func dissmisLocationView(completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }, completion: completion)
    }
}
//MARK:- MapViewHelper
private extension HomeController{
    func searchBy(naturalLanguageQuery: String,completion: @escaping([ MKPlacemark ]) -> Void){
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response , error) in
            guard let response = response else {return}
            
            response.mapItems.forEach { (mapitem) in
                results.append(mapitem.placemark)
            }
            completion(results)
        }
    }
}



//MARK:-MapViewDelegates
extension HomeController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation{
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: DRIVER_ANNO_REUSE_ID)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right.png")
            return view
        }
        return nil
    }
}


//MARK:- Location Services
extension HomeController {
    func enableLocationServices(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not Determined Location")
            locationMeneger?.requestWhenInUseAuthorization()
            break
        case .restricted,.denied:
            print("DEBUG: Denied Location")
            break
        case .authorizedAlways:
            print("DEBUG: authorizedAlways Location")
            locationMeneger?.startUpdatingLocation()
            locationMeneger?.desiredAccuracy = kCLLocationAccuracyBest
            break
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse Location")
            locationMeneger?.requestAlwaysAuthorization()
            break
            
        @unknown default:
            break
        }
        
        /*
         if #available(iOS 14.0, *) {
         func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         let accuracyAuthorization = manager.accuracyAuthorization
         switch accuracyAuthorization {
         case .fullAccuracy:
         locationMeneger?.desiredAccuracy = kCLLocationAccuracyBest
         locationMeneger?.startUpdatingLocation()
         print("DEBUG: fullAccuracy location")
         break
         case .reducedAccuracy:
         print("DEBUG: reducedAccuracy location")
         locationMeneger?.requestWhenInUseAuthorization()
         break
         default:
         break
         }
         }
         }
         */
        
    }
}

//MARK:- LocationViewACtivationDelegate
extension HomeController : LocationInputViewActivationViewDelegate{
    func presentLocationInputView() {
        //Touched HomeController TExt field
        inputActivationView.alpha = 0
        configureLocationInputView()
        
    }
}
//MARK:- LocationInputViewDelegate
extension HomeController: LocationInputViewDelegate{
    func excuteSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (placemarks) in
            self.searchResults = placemarks
            self.tableView.reloadData()
        }
    }
    
    
    func dismissLocationInputView() {
        dissmisLocationView()
    }
    
}
//MARK:-UITableviewDelegates/DataSoruce
extension HomeController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "eren"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer,for: indexPath) as! LocationCell
        
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlaceMarks = searchResults[indexPath.row]
        dissmisLocationView { _ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlaceMarks.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
}

