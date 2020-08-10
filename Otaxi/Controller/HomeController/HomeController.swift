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

private enum ActionbuttonConfiguration{
    case showMenu
    case dissmissActionView
    init() {
        self = .showMenu
    }
}

protocol HomeControllerDelegate: class {
    func handleMenuToggle()
}

class HomeController : UIViewController{
    //MARK:- Properties
    let transition = CircularTransition()
    private let mapView = MKMapView()
    private let locationMeneger = LocationHandler.shared.locationManager
    
    
    private let inputActivationView = LocationInputViewActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private let rideAction = RideActionView()
    
    private final let locationInputViewHeight: CGFloat = 200
    private final let rideActionViewHeight: CGFloat = 300
    
    private var searchResults = [MKPlacemark]()
    private var savedLocations = [MKPlacemark]()
    private var actionButtonConfig = ActionbuttonConfiguration()
    
    private var route: MKRoute?
    var selectedAnnotation: CustomAnnotation?
    
    
    private let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    private let healtyTaxiButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(healtyHomePressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "staroflife.fill"), for: .normal)
        return button
    }()
    private let HighPointDrivers : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(hpPressed), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "RatingStarEmpty.png").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    private let hplabel : UILabel = {
        let label = UILabel()
        label.text = "Sağlıklı Taksi"
        label.font = UIFont(name: "Avenir-Light", size: 10)
        label.textColor = .black
        return label
    }()

    
    
     var user : User? {
        didSet{
            locationInputView.user = user
            configureSavedUserLocations()
        }
    }
    weak var delegate: HomeControllerDelegate?
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        savedLocations.removeAll()
        checkUserLoggedIn()
        configureUI()
        enableLocationServices()
        transitioningDelegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         navigationController?.navigationBar.isHidden = false
    }
    //MARK:- Selectors
    @objc func actionButtonPressed(){
        //MENU Button
        switch actionButtonConfig {
        case .showMenu:
            delegate?.handleMenuToggle()
        case .dissmissActionView:
            removeAnnotationsAndOverlays()
            mapView.showAnnotations(mapView.annotations, animated: true)
            UIView.animate(withDuration: 0.5) {
                self.inputActivationView.alpha = 1
                self.configureActionbutton(configure: .showMenu)
                self.presentRideActionView(shouldShow: false)
            }
        }
    }
    @objc fileprivate func healtyHomePressed(){
        let vc = HealtyDrivers()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    @objc fileprivate func hpPressed(){
        let vc = HighHPDrivers()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    //MARK:-Api
    func fetchUserData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchUserData(uid: uid) { user in
            self.user = user
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
        fetchDurakOnMap(TaksiDurakları.shared.duraklar)
    }

    fileprivate func configureActionbutton(configure config : ActionbuttonConfiguration){
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp.png").withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
            
        case .dissmissActionView:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dissmissActionView
        }
    }
    
    func configureUI(){
        configureMapView()
        configureRideActionView()
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor ,
                            left: view.leftAnchor,
                            paddingTop: 16,
                            paddingLeft: 20,
                            width: 30,
                            height: 30)
        view.addSubview(healtyTaxiButton)
        healtyTaxiButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                right: view.rightAnchor,
                                paddingTop: 16,
                                paddingRight: 27,
                                width: 40,
                                height: 40)
        view.addSubview(HighPointDrivers)
        HighPointDrivers.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 right: healtyTaxiButton.leftAnchor,
                                 paddingTop: 16,
                                 paddingRight: 18,
                                 width: 30,
                                 height: 30)
        view.addSubview(hplabel)
        hplabel.anchor(top: healtyTaxiButton.bottomAnchor,
                       right: view.rightAnchor,
                       paddingRight: 20)
        
        view.addSubview(inputActivationView)
        inputActivationView.layer.cornerRadius = 10
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50,
                                          width: view.frame.width - 64)
        
        inputActivationView.anchor(top: actionButton.bottomAnchor,
                                   paddingTop: 30)
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
    func configureRideActionView(){
        view.addSubview(rideAction)
        rideAction.frame = CGRect(x: 0,
                                  y: view.frame.height,
                                  width: view.frame.width,
                                  height: rideActionViewHeight)
    }
    func configureSavedUserLocations() {
        guard let user = user else { return }
        savedLocations.removeAll()
        if let homeLocation = user.homeLocation {
            geocodeAddressString(address: homeLocation)
        }
        
        if let workLocation = user.workLocation {
            geocodeAddressString(address: workLocation)
        }
    }
    func geocodeAddressString(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let clPlacemark = placemarks?.first else { return }
            let placemark = MKPlacemark(placemark: clPlacemark)
            self.savedLocations.append(placemark)
            self.tableView.reloadData()
        }
    }    
    func dissmisLocationView(completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
        }, completion: completion)
    }
    func presentRideActionView(shouldShow: Bool,destination: MKPlacemark? = nil){
        
        let yOrigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight : self.view.frame.height
        
        if shouldShow {
            guard let destination = destination else {return}
            self.rideAction.destination = destination
        }
        
        UIView.animate(withDuration: 0.4) {
            self.rideAction.frame.origin.y = yOrigin
        }
    }
    func fetchDurakOnMap(_ duraklar: [TaksiDurak]) {
        for durak in duraklar {
            let annotations = CustomAnnotation(title: durak.name, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: durak.lattitude, longitude: durak.longtitude))
            mapView.addAnnotation(annotations)
        }
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
    
    func generatePolyline(toDestination destination:MKMapItem){
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { (response, error) in
            guard let response = response else { return }
            self.route = response.routes[0]
            
            guard let polyline = self.route?.polyline else {return}
            self.mapView.addOverlay(polyline)
            
        }
    }
    func removeAnnotationsAndOverlays() {
        mapView.annotations.forEach { (annotation) in
            if let anno = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
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
        guard annotation is CustomAnnotation else { return nil }
        let identifier = "Annotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(systemName: "mappin.circle.fill")
            annotationView.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            button.addTarget(self, action: #selector(handleDetailDisclosure), for: .touchUpInside)
            annotationView.rightCalloutAccessoryView = button
            return annotationView
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? CustomAnnotation
    }
    //MARK:-MapView Selectors
    @objc func handleDetailDisclosure(){
        guard let selectedtitle = selectedAnnotation?.title else {return}
        let detail = StopsDriver()
        detail.navigationTitle = selectedtitle
        detail.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let rotue = self.route{
            let polyline = rotue.polyline
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = .mainBlueTint
            lineRenderer.lineWidth = 3
            return lineRenderer
        }
        return MKOverlayRenderer()
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
        dissmisLocationView { _ in
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
    
}
//MARK:-UITableviewDelegates/DataSoruce
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Kayıtlı Adressler" : "Sonuç"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? savedLocations.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! LocationCell
        
        if indexPath.section == 0 {
            cell.placemark = savedLocations[indexPath.row]
        }
        
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        
        return cell
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.savedLocations.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = indexPath.section == 0 ? savedLocations[indexPath.row] : searchResults[indexPath.row]
        configureActionbutton(configure: .dissmissActionView)
        let destination = MKMapItem(placemark: selectedPlacemark)
        generatePolyline(toDestination: destination)
        dissmisLocationView { _ in
            self.mapView.addAnnotationAndSelect(forCoordinate: selectedPlacemark.coordinate)
            
            let annotations = self.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
            self.mapView.zoomToFit(annotations: annotations)
            self.presentRideActionView(shouldShow: true, destination: selectedPlacemark)
        }
    }
}
extension HomeController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = healtyTaxiButton.center
        transition.circleColor = .backgroundColor
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = healtyTaxiButton.center
        transition.circleColor = .backgroundColor
        return transition
    }
}
