//
//  ViewController.swift
//  gonshare
//
//  Created by SEIF EL FREJ ISMAIL on 02/05/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase


class gondolaStations: NSObject, MKAnnotation, UIGestureRecognizerDelegate {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String ){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}




// Set location,title and subtitle of gondola stops
let accademiaStopCoordinate = CLLocationCoordinate2D(latitude: 45.43171, longitude: 12.328415)
let santaBarnabaStopCoordinate = CLLocationCoordinate2D(latitude: 45.433172, longitude: 12.324826)
let santaMariaDelGiglioStopCoordinate = CLLocationCoordinate2D(latitude: 45.431672, longitude: 12.333016)
let BauerStopCoordinate = CLLocationCoordinate2D(latitude: 45.432973, longitude: 12.335466)
let puntaDellaDoganaStopCoordinate = CLLocationCoordinate2D(latitude: 45.432354, longitude: 12.337186) //,
let sanMarcoStopCoordinate = CLLocationCoordinate2D(latitude: 45.433187, longitude: 12.339925) // ,
let sottoPorticoStopCoordinate = CLLocationCoordinate2D(latitude: 45.436375, longitude: 12.337825) // ,
let callePerdonStopCoordinate = CLLocationCoordinate2D(latitude: 45.437535, longitude: 12.331559) // ,
let sanTomàStopCoordinate = CLLocationCoordinate2D(latitude: 45.435524, longitude: 12.328308) // ,
let sanSamueleStopCoordinate = CLLocationCoordinate2D(latitude: 45.433198, longitude: 12.327043) // ,
let sanMarcoVallaressoStopCoordinate = CLLocationCoordinate2D(latitude: 45.432329, longitude: 12.337181) // ,
let santaSofiaStopCoordinate = CLLocationCoordinate2D(latitude: 45.440509, longitude: 12.334584) // ,
let bacinoOrseoloStopCoordinate = CLLocationCoordinate2D(latitude: 45.434242, longitude: 12.336802) // ,
let sanZaccariaStopCoordinate = CLLocationCoordinate2D(latitude: 45.433695, longitude: 12.342482) // ,


let coordinatesArray = [accademiaStopCoordinate,santaBarnabaStopCoordinate,santaMariaDelGiglioStopCoordinate,BauerStopCoordinate,puntaDellaDoganaStopCoordinate,sanMarcoStopCoordinate,sottoPorticoStopCoordinate,callePerdonStopCoordinate,sanTomàStopCoordinate,sanSamueleStopCoordinate,sanMarcoVallaressoStopCoordinate,santaSofiaStopCoordinate,bacinoOrseoloStopCoordinate,sanZaccariaStopCoordinate]
let titleArray = ["Accademia","S.Barnaba","S.Maria Del Giglio","Bauer","Punta Della Dogana","S.Marco","Sottoportico","Calle Perdon","S.Tomà","S.Samuele","S.Marco Valleresso","S.Sofia","Bacino Orseolo","S.Zaccaria"]
let subtitleArray = ["","","","","","","","","","","","","",""]



public var ref: DatabaseReference = Database.database().reference(fromURL: "https://gonshare-9bcac.firebaseio.com/")
public var nOfMyUsers = 0
public var counter = 0 // number of celss to show
public var uid = ""
public var nameOfStation = ""
public var publicName = "publicName"
public var stationNameForNewGroup = ""
public var myOwnCounter = 0
public var directionStationName = "Accademia"
public var isGivingDirections = false
public let screen = UIScreen.main.bounds
public let screenWidth = screen.width/414
public let screenHeight = screen.height/736

class ViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    
    
    
    
    
    ////////////
    let returnButton : UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("return", for: .normal)
        //b.translatesAutoresizingMaskIntoConstraints=false
        return b
    }()
    
    let navBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.95)
        bar.translatesAutoresizingMaskIntoConstraints=false
        return bar
        
    }()
    
    let navBarTitle : UILabel = {
        let lab = UILabel()
        lab.text = "Venice"
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints=false
        lab.font = UIFont(name:"Klavika-Bold", size: 17)
        return lab
    }()
    
    let mapBarItem : UIButton = {
        let b = UIButton()
        b.setTitle("Explore map", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints=false
        b.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.95)
        b.titleLabel?.font =  UIFont(name: "Helvetica-BoldOblique", size: (b.titleLabel?.font.pointSize)!-3)
        b.setTitleColor(UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1), for: .normal)
        b.addTarget(self, action: #selector(removeMyBookedView), for: .touchUpInside)
        return b
    }()
    
    let myBookedBarItem : UIButton = {
        let b = UIButton()
        b.setTitle("My rides (\(myOwnCounter))", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints=false
        b.titleLabel?.font =  UIFont(name: "System-Bold", size: (b.titleLabel?.font.pointSize)!-3)
        b.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.95)
        b.setTitleColor(UIColor.black, for: .normal)
        b.addTarget(self, action: #selector(addMyBookedView), for: .touchUpInside)
        return b
    }()
    
    let settingsButton : UIButton = {
        let but = UIButton(type: .system)
        but.setTitle(NSString(string: "\u{2699}\u{0000FE0E}") as String, for: .normal)
        let font = UIFont.systemFont(ofSize: 28)
        but.titleLabel?.font = font
        but.setTitleColor(UIColor.gray, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints=false
        return but
    }()
    
    
    
    let myBookedView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        cv.isScrollEnabled = true
        cv.isSpringLoaded=true
        cv.alwaysBounceVertical=true
        cv.isUserInteractionEnabled=true
        cv.collectionViewLayout.accessibilityScroll(.down)
        cv.translatesAutoresizingMaskIntoConstraints=false
        cv.refreshControl?.isEnabled = true
        
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myOwnCounter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:myBookedView.frame.width, height: 120/736*screen.height)
    }

    var valueToPickUpFrom : [[String:Any]] = []
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myBookedView.dequeueReusableCell(withReuseIdentifier: "newId", for: indexPath) as! myBookedRidesCellCollectionViewCell
            
        
        self.sthForBookedViewCell(cell: cell, indexPath: indexPath, valueToGet: valueToPickUpFrom)
        
        return cell
    }
    
    func sthForBookedViewCell(cell: myBookedRidesCellCollectionViewCell, indexPath:IndexPath, valueToGet : [[String:Any]]){
        let k = indexPath.row
        
        cell.personWaitingLabel.numberOfLines = 2
        
        
        cell.dateLabel.text = "\(valueToGet[k]["date"] as! String) at \(valueToGet[k]["nameOfStation"] as! String)"
        
        
        let currentRatio = 80.0 / (valueToGet[k]["nofUsers"] as! Double)
        let roundedText = String(format: "%.2f", currentRatio)
        
        cell.pricePerPersonLabel.text = """
        
        \(roundedText)€/person
        """
        
        cell.personWaitingLabel.text = """
        
        You are in total \(String(valueToGet[k]["nofUsers"] as! Int)) people
        """
        
        cell.joinButton.accessibilityHint = valueToGet[k]["uid"] as? String
        self.setGradientBackground(cell: cell, valueToGet: valueToGet[k]["nofUsers"] as! Double, indexPath: indexPath)
        //let stationName = valueToGet[k]["nameOfStation"] as! String
        
        
        
    }
    
    @objc func getDirections(notification: NSNotification) {
        getDirections1()
    }
    
    func setGradientBackground(cell: myBookedRidesCellCollectionViewCell, valueToGet : Double, indexPath: IndexPath) {
        let colorLeft = UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1).cgColor
        let colorRight = UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1).cgColor
        let ratio = valueToGet/6
        let doubleWidth = Double(screenWidth)
        let doubleHeight = Double(screenHeight)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = cell.fullImageView.layer.cornerRadius
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 250*ratio*doubleWidth, height: 50*doubleHeight)
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint =  CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint =  CGPoint(x: 1.0/ratio, y: 0.5)
        
        cell.fullImageView.layer.addSublayer(gradientLayer)
        
        cell.fullImageView.layer.sublayers?[0].removeFromSuperlayer()
        cell.fullImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func loadBookedRides(notification: NSNotification) {
        loadNumberOfMyBookedRides()
    }
    
    
    func loadNumberOfMyBookedRides(){
        
        myOwnCounter = 0
        valueToPickUpFrom = []
        for nam in titleArray{
            let name = nam.replacingOccurrences(of: ".", with: ",")
            bottomSheet.orderInChronologicalOrder(nameOfStation: name )
            ref.child("Stations/\(name)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                guard var valueToGet = snapshot.value as? [[String : Any]] else {return}
                
                
                for i in 0..<valueToGet.count{
                    switch valueToGet[i].count {
                    case 4:
                        if valueToGet[i]["uid"] as! String == uid{
                            myOwnCounter += 1
                            valueToGet[i]["nameOfStation"] = nam
                            self.valueToPickUpFrom.append(valueToGet[i])
                            break
                            
                        }
                    case 5:
                        if valueToGet[i]["uid"] as! String == uid || valueToGet[i]["uid2"] as! String == uid{
                            myOwnCounter += 1
                            valueToGet[i]["nameOfStation"] = nam
                            self.valueToPickUpFrom.append(valueToGet[i])
                            break
                        }
                    case 6:
                        if valueToGet[i]["uid"] as! String == uid || valueToGet[i]["uid2"] as! String == uid || valueToGet[i]["uid3"] as! String == uid{
                            myOwnCounter += 1
                            valueToGet[i]["nameOfStation"] = nam
                            self.valueToPickUpFrom.append(valueToGet[i])
                            break
                        }
                    case 7:
                        if valueToGet[i]["uid"] as! String == uid || valueToGet[i]["uid2"] as! String == uid || valueToGet[i]["uid3"] as! String == uid || valueToGet[i]["uid4"] as! String == uid{
                            myOwnCounter += 1
                            valueToGet[i]["nameOfStation"] = nam
                            self.valueToPickUpFrom.append(valueToGet[i])
                            break
                        }
                    case 8:
                        if valueToGet[i]["uid"] as! String == uid || valueToGet[i]["uid2"] as! String == uid || valueToGet[i]["uid3"] as! String == uid || valueToGet[i]["uid4"] as! String == uid || valueToGet[i]["uid5"] as! String == uid{
                            myOwnCounter += 1
                            valueToGet[i]["nameOfStation"] = nam
                            self.valueToPickUpFrom.append(valueToGet[i])
                            break
                        }
                    case 9:
                        if valueToGet[i]["uid"] as! String == uid || valueToGet[i]["uid2"] as! String == uid || valueToGet[i]["uid3"] as! String == uid || valueToGet[i]["uid4"] as! String == uid || valueToGet[i]["uid5"] as! String == uid ||
                            valueToGet[i]["uid6"] as! String == uid{
                            myOwnCounter += 1
                            valueToGet[i]["nameOfStation"] = nam
                            self.valueToPickUpFrom.append(valueToGet[i])
                            break
                        }
                    default:
                        break
                    }
                }
                
                self.myBookedView.reloadData()
                self.myBookedBarItem.setTitle("My rides (\(myOwnCounter))", for: .normal)
            })
        }
        
    }
    
    
    
    
    @ objc func addMyBookedView(){
        loadNumberOfMyBookedRides()
            if self.bookedViewIsRemoved == true{
                self.myBookedBarItem.setTitleColor(UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1), for: .normal)
                self.myBookedBarItem.titleLabel?.font =  UIFont(name: "Helvetica-BoldOblique", size: (self.myBookedBarItem.titleLabel?.font.pointSize)!)
            
                self.mapBarItem.setTitleColor(UIColor.black, for: .normal)
                self.mapBarItem.titleLabel?.font =  UIFont(name: "System-Bold", size: (self.mapBarItem.titleLabel?.font.pointSize)!)
            
                self.view.addSubview(self.myBookedView)
            
                self.myBookedView.topAnchor.constraint(equalTo: self.mapBarItem.bottomAnchor).isActive=true
                self.myBookedView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive=true
                self.myBookedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
                self.myBookedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
            
                self.bookedViewIsRemoved = false
            
            
            }
            
        
    }
    
    var bookedViewIsRemoved : Bool = true
    
    @ objc func removeMyBookedView(){
        loadNumberOfMyBookedRides()
        //setUid()
        
            
            if self.bookedViewIsRemoved == false{
                
                self.mapBarItem.titleLabel?.font =  UIFont(name: "Helvetica-BoldOblique", size: (self.mapBarItem.titleLabel?.font.pointSize)!)
                self.mapBarItem.setTitleColor(UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1), for: .normal)
                
                self.myBookedBarItem.setTitleColor(UIColor.black, for: .normal)
                self.myBookedBarItem.titleLabel?.font =  UIFont(name: "System-Bold", size: (self.mapBarItem.titleLabel?.font.pointSize)!)
                
                self.myBookedView.topAnchor.constraint(equalTo: self.mapBarItem.bottomAnchor).isActive=false
                self.myBookedView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive=false
                self.myBookedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=false
                self.myBookedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=false
                
                self.myBookedView.removeFromSuperview()
                
                self.bookedViewIsRemoved = true
                
            }
            
        
    }
    
    
    
    func navbarSetter(){
        
        view.addSubview(navBar)
        view.addSubview(navBarTitle)
        view.addSubview(mapBarItem)
        view.addSubview(myBookedBarItem)
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsSetter), for: .touchUpInside)
        
        
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        navBar.heightAnchor.constraint(equalToConstant: 60/736*screen.height).isActive=true
        
        navBarTitle.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive=true
        navBarTitle.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: 21*screenHeight).isActive=true
        navBarTitle.widthAnchor.constraint(equalToConstant: 150/(414)*screen.width).isActive=true
        navBarTitle.heightAnchor.constraint(equalToConstant: 50/736*screen.height).isActive=true
        
        settingsButton.centerYAnchor.constraint(equalTo: navBarTitle.centerYAnchor).isActive=true
        settingsButton.heightAnchor.constraint(equalTo: navBarTitle.heightAnchor).isActive=true
        settingsButton.widthAnchor.constraint(equalToConstant: 50*screenWidth).isActive=true
        settingsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20*screenWidth).isActive=true
        
        mapBarItem.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive=true
        mapBarItem.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        mapBarItem.rightAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        mapBarItem.heightAnchor.constraint(equalToConstant: 40/736*screen.height).isActive=true
        
        myBookedBarItem.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive=true
        myBookedBarItem.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        myBookedBarItem.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myBookedBarItem.heightAnchor.constraint(equalToConstant: 40/736*screen.height).isActive=true
        
        
        myBookedView.register(myBookedRidesCellCollectionViewCell.self, forCellWithReuseIdentifier: "newId")
        myBookedView.dataSource = self
        myBookedView.delegate = self
    }
    
    @ objc func settingsSetter(){
        let settingsView = settingsViewController()
        self.present(settingsView, animated: true, completion: nil)
        
    }
    
    func buttonSetter(){
        view.addSubview(returnButton)
        
        returnButton.frame = CGRect(x: 200/414*screen.width, y: 300/736*screen.height, width: 150/414*screen.width, height: 50/736*screen.height)
    }
    
    
    @ objc func ret(){
        //present(loginViewController(), animated: true, completion: nil)
        
        ref = Database.database().reference(fromURL: "https://gonshare-9bcac.firebaseio.com/")
        
        var valueToStore : [[String : Any]] =
            [
                ["name": "seif", "uid": "VXqJqdRyYNg1wqJ4ZznJV6uYbgE3", "nofUsers": 2, "date": "2/May/19 10:20"],
                ["date": "1/May/19 13:40", "uid": "nFDGnwvBd7O2rlYjQVLdsflEVwc2", "nofUsers": 4, "name": "Naceur"],
                ["name": "fathia", "uid": "uuuuuuuuu", "nofUsers": 3, "date": "12/May/19 18:20"],
                ["date": "1/Jun/19 13:00", "uid": "nFDGnwvBd7O2rlYjQVLdsflEVwc2", "nofUsers": 4, "name": "bochra"],
                ["date": "1/May/19 13:00", "uid": "nFDGnwvBd7O2rlYjQVLdsflEVwc2", "nofUsers": 4, "name": "bochra"]
                
            ]
        
        
        ref.child("Stations/Accademia").setValue(valueToStore)
        
        var title = ""
        
        
        for tit in titleArray{
            title = tit.replacingOccurrences(of: ".", with: ",")
            valueToStore[4]["name"] = title
            ref.child("Stations/\(title)").setValue(valueToStore)
            
        }
        
        
    }
    
    func setUid(){
        let loginView = loginViewController()
        ref.child("Users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let valueToGet = snapshot.value as? [[Any]] else {self.present(loginView, animated: true, completion: nil);print("not worked");return}
            
            for i in 0 ..< valueToGet.count{
                if  deviceString! == (valueToGet[i][1] as? String) {
                    uid = valueToGet[i][0] as! String
                    nOfMyUsers = (valueToGet[i][2] as? Int ?? 0)
                }
            }
            if uid == "" || nOfMyUsers == 0{
                self.present(loginView, animated: true, completion: nil)
            }
            
        })
    }
    
    
    func initCustomClass() {
        let coreData = bottomSheetView()
        coreData.parentViewController = self
    }
    
    
    
    
    //////////////////

    @IBOutlet weak var VeniceMap: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    
    
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbarSetter()
        loadNumberOfMyBookedRides()
        
        
        
        VeniceMap.delegate = self
        checkLocationServices()
        mapView()
        mapView(VeniceMap, didSelect: VeniceMap.dequeueReusableAnnotationView(withIdentifier: identifier)!)
        
        //setUid()
        ///////////
        //buttonSetter()
        //returnButton.addTarget(self, action: #selector(ret), for: .touchUpInside)
        /////////
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadBookedRides(notification:)), name: NSNotification.Name(rawValue: "loadBookedRides"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getDirections(notification:)), name: NSNotification.Name(rawValue: "getDirections"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadNumberOfMyBookedRides()
        alertSetting()
        
        
    }
    let loginView = loginViewController()
    func setNewUid() {
        
        if nOfMyUsers<1 || nOfMyUsers>5 || uid == "" {
            present(loginView, animated: true, completion: nil)
        }
    }
    
    func alertSetting(){
        if uid == "" {present(loginView, animated: true, completion: nil);return}
        let alert = UIAlertController(title: "How many people are you?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "max 5 people..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = Int(alert.textFields?.first?.text ?? "") {
                if name <= 5 , name > 0 {
                    nOfMyUsers = name
                }
            }
        }))
        if nOfMyUsers < 1 || nOfMyUsers > 5, uid != "" {
            self.present(alert, animated: true)
        }
    }
    
    // Center the user location when application initially runs
    func centerViewOnUserLocation() {
        if (locationManager.location?.coordinate) != nil{
            let region = MKCoordinateRegion(center: coordinatesArray[3], latitudinalMeters: 2000, longitudinalMeters: 2000)
            VeniceMap.setRegion(region, animated: true)
        }
        
    }
    
    // Creates the annotations on the map
    let identifier = "annotationId"
    
    func mapView(){
        
        var annotion : gondolaStations
        let gondolaStopAnnotation = VeniceMap.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        gondolaStopAnnotation?.animatesWhenAdded = true
        gondolaStopAnnotation?.titleVisibility = .adaptive
        VeniceMap.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: identifier)
        VeniceMap.dequeueReusableAnnotationView(withIdentifier: identifier)?.canShowCallout = false //important to recognize tap
        for ann in 0..<coordinatesArray.count{
            annotion = gondolaStations(coordinate: coordinatesArray[ann], title: titleArray[ann], subtitle: subtitleArray[ann])
            VeniceMap.addAnnotation(annotion)
            
        }
    }
    
    
    // Recognize when user taps on annotation + adds bottom sheet
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? gondolaStations {
            
            // Show bottom sheet view
            bottomSheet.stationNameLabel.text = annotation.title
            
            nameOfStation = annotation.title!.replacingOccurrences(of: ".", with: ",")
            
            showBottomSheetView(annotation: annotation)
            
            
            
            
        }
    }
    
    let bottomSheet = bottomSheetView()
    let sharingRide = sharingRideCell()
    
    func showBottomSheetView(annotation: gondolaStations){
        
        bottomSheet.bottomSheetLauncher()
        //sharingRide.joinButton.addTarget(sharingRide.joinButton, action: #selector(handlePresent), for: .touchUpInside)
        
    }
    
    
    
    
    // Checks the type of authorization given and acts based on that
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            VeniceMap.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert to tell how to activate location
            break
        case .notDetermined:
            //locationManager.requestLocation()
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show alert
            break
        case .authorizedAlways :
            VeniceMap.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        default:
            print("not given authorization")
        }
        
        
    }
    
    
    //
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    // Checks if the device can use location, sets up the location manager and checks wether the authorization is given
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkAuthorization()
        } else {}
    }
    
    @ objc func getDirections1(){
        removeMyBookedView()
        showExitButton()
        
        showRouteOnMap(stationName: directionStationName)
    }
    
    let exitButton : UIButton = {
        let but = UIButton(type: .roundedRect)
        but.backgroundColor = UIColor(red: 220/255, green: 0/255, blue: 60/255, alpha: 1)
        but.layer.cornerRadius = 7
        but.setTitle("Exit", for: .normal)
        but.setTitleColor(UIColor.white, for: .normal)
        but.frame = CGRect(x: screen.midX-50*screenWidth, y: screen.height-90*screenHeight, width: 100*screenWidth, height: 50*screenWidth)
        but.addTarget(self, action: #selector(removeNavigation), for: .touchUpInside)
        return but
    }()
    
    func showExitButton(){
        view.addSubview(exitButton)
    }
    @ objc func removeNavigation(){
        exitButton.removeFromSuperview()
        VeniceMap.removeOverlays(VeniceMap.overlays)
    }
    
    
    
    
    
    func showRouteOnMap(stationName: String) {
        
        
        var i = 0
        for num in 0 ..< titleArray.count {
            if titleArray[num] == stationName{
                i = num
            }
        }
        
        
        let currentLocation = locationManager.location!.coordinate
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinatesArray[i], addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .any
        
        let directions = MKDirections(request: request)
        self.view.showBlurLoader()
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { print("guard let problem");self.view.removeBluerLoader();return }
            
            if (unwrappedResponse.routes.count > 0) {
                let polyline = unwrappedResponse.routes[0].polyline
                
                self.VeniceMap.removeOverlays(self.VeniceMap.overlays)
                self.VeniceMap.addOverlay(polyline)
                self.view.removeBluerLoader()
                //self.VeniceMap.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
                self.locationNewMineUpdate(self.locationManager, didUpdateLocations: [])
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            
            polylineRenderer.createPath()
            
            
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    
     //Center user location while moving (only when users asks for directuons)
    func locationNewMineUpdate(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = manager.location else {return}
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        VeniceMap.setRegion(region, animated: true)
        
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if isGivingDirections == true{
//            VeniceMap.overlays
//            showRouteOnMap(stationName: directionStationName)
//            guard let location = locations.last else {return}
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
//            VeniceMap.setRegion(region, animated: true)
//        }
//    }
    
    
    
}



extension ViewController: CLLocationManagerDelegate{
    
    
    // Center user location while moving (only when users asks for directuons)
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        guard let location = locations.last else {return}
    //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    //        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
    //        VeniceMap.setRegion(region, animated: true)
    //    }
    
    
    // In case the location authorizaion change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
    
}
