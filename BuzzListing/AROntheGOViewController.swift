//
//  AROntheGOViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/7/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit
import CoreLocation


class AROntheGOViewController : UIViewController, CLLocationManagerDelegate, ARSCNViewDelegate
{
    
    
    // MARK: - components
    @IBOutlet var sideMenuButton: UIButton!
    @IBOutlet var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet var sideMenuContainer: sideMenuView!
    
    @IBOutlet var tempMarker2: UIView!
    @IBOutlet var tempMarker1: UIView!
    @IBOutlet var directionView: UIView!
    @IBOutlet var ARSCNStreetView: ARSCNView!
    
    //filter related componenets
    @IBOutlet var btnChkRent: UIButton!
    @IBOutlet var btnChkSale: UIButton!
    
    @IBOutlet var filterContainerview: filterView!
    @IBOutlet var filterContainerViewConstraint: NSLayoutConstraint!
    
    //filter related variables
    var availibilityType : NSString = ""
    
    //for location
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var previousLocationLongitude: Double!
    var previousLocationLatitude: Double!
    
    
    
    
    // MARK: - initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        //design
        btnChkRent.layer.cornerRadius = 3
        btnChkRent.layer.borderColor = UIColor.darkGray.cgColor
        btnChkRent.layer.borderWidth = 1
        btnChkSale.layer.cornerRadius = 3
        btnChkSale.layer.borderColor = UIColor.darkGray.cgColor
        btnChkSale.layer.borderWidth = 1
        //hide side menu
        sideMenuConstraint.constant = -240
        //register action hide side menu button
        sideMenuContainer.backBtn.addTarget(self, action: #selector(hideSideMenu), for: UIControlEvents.touchUpInside)
        filterContainerview.btnBack.addTarget(self, action: #selector(hideFilter), for: UIControlEvents.touchUpInside)
        filterContainerview.btnDone.addTarget(self, action: #selector(hideFilter), for: UIControlEvents.touchUpInside)
        
        //design
//        tempMarker1.layer.cornerRadius = 5
//        tempMarker2.layer.cornerRadius = 5
//        directionView.layer.cornerRadius = 50
//
//        let gradient1 = CAGradientLayer()
//        gradient1.frame = tempMarker1.bounds
//        gradient1.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
//        tempMarker1.layer.insertSublayer(gradient1, at: 0)
//
//        let gradient2 = CAGradientLayer()
//        gradient2.frame = tempMarker2.bounds
//        gradient2.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
//        tempMarker2.layer.insertSublayer(gradient2, at: 0)
        
        filterContainerViewConstraint.constant = -240
        
        //create and attach node
        ARSCNStreetView.delegate = self
        ARSCNStreetView.showsStatistics = true
        
        //automatically find houses for rent
        self.availibilityType = "1"
        self.btnChkRent.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
        self.btnChkSale.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        
        
        self.directionView.layer.cornerRadius = 50
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupScene()
        setupConfiguration()
        
        //set up tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        self.ARSCNStreetView.addGestureRecognizer(tap)
        
        // location
        determineMyCurrentLocation()
        //add nodes
        //addNodes("For Sale","$520000","House-17, Road-30, Gulshan-1", 90.415031, 23.784652, 90.414970, 23.784912)
        
        //fetch data after a particular time interval
        let date = Date().addingTimeInterval(0)
        let timer = Timer(fireAt: date, interval: 10, target: self, selector: #selector(runCode), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    // MARK: - ARKit Scene
    func setupScene() {
        let scene = SCNScene()
        ARSCNStreetView.scene = scene
    }
    
    func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        ARSCNStreetView.session.run(configuration)
    }
    // MARK: - location related
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation != nil
        {
            self.previousLocationLongitude = currentLocation.coordinate.longitude
            self.previousLocationLatitude = currentLocation.coordinate.latitude
        }
        currentLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(currentLocation.coordinate.latitude)")
        print("user longitude = \(currentLocation.coordinate.longitude)")
        
        
        
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    func toRadians(_ value: Double) -> Double {
        return ( value * .pi ) / 180
    }
    
    func toDegrees(_ value: Double) -> Double {
        return ( value * 180 ) / .pi
    }
    
    func calculateBearing(_ longFrom: Double, _ latFrom: Double, _ longTo: Double, latTo: Double) -> Double {
        let lat1 = toRadians(latFrom)
        let lon1 = toRadians(longFrom)
        
        let lat2 = toRadians(latTo)
        let lon2 = toRadians(longTo)
        
        let longitudeDiff = lon2 - lon1
        
        let y = sin(longitudeDiff) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(longitudeDiff);
        
        return atan2(y, x)
    }
    
    // MARK: -
    // MARK: - place properties in ARScene
    //parameters can contain property type(residential/commercial/condo), availibility type(for sale/rent) and price range(min/max or both)
    
    // MARK: - Step:1 (fetch data using API)
    @objc func runCode()
    {
        print("I am inside runCode()")
        
        let filterParameters = populateFilterParametersDict ()
        print(filterParameters)
        if currentLocation != nil
        {
            
            for view in self.ARSCNStreetView.subviews {
                UIView.animate(withDuration: 1, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
                //view.removeFromSuperview()
            }
            makeCurrentPositionLabel()
            fetchDataForProperties(-79.50720, 43.927820, filterParameters)
            //fetchDataForProperties(currentLocation.coordinate.longitude, currentLocation.coordinate.latitude, filterParameters)
        }
        else
        {
            return
        }
        //fetchDataForProperties(90.415012, 23.784754, filterParameters)
    }
    func makeCurrentPositionLabel()
    {
        print("making a circle in left corner of the screen")
        let label = UILabel()
        label.frame.size = CGSize(width: 12.0, height: 12.0)
        label.layer.cornerRadius = label.frame.height/2
        label.layer.masksToBounds = true
        label.center.x = 80
        label.center.y = self.ARSCNStreetView.frame.height  - 80
        label.backgroundColor = UIColor.blue
        //dynamicLabel.textAlignment = NSTextAlignment.Center
        //dynamicLabel.text = "test label"
        self.ARSCNStreetView.addSubview(label)
        
        
        
        
    }
    func fetchDataForProperties(_ long: Double, _ lat: Double, _ filterParameters: NSMutableDictionary)
    {
        
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseURL
                //&type=1&sr=Sale&max=1800000&min=700000
                var varURL = String(format: "/api/v1/ardata/?lat=%f&long=%f", lat, long)
                //add filter parameters
                if filterParameters.object(forKey: "propertyType") as? NSString != nil
                {
                    if(filterParameters.object(forKey: "propertyType") as? NSString != "1")
                    {
                        varURL = String(format: "%@&type=%@", varURL, (filterParameters.object(forKey: "propertyType") as? NSString)!)
                    }
                    
                }
                if filterParameters.object(forKey: "availibilityType") as? NSString != nil
                {
                    print(filterParameters.object(forKey: "availibilityType") as? NSString ?? "")
                    if filterParameters.object(forKey: "availibilityType") as? NSString == "0"
                    {
                        varURL = String(format: "%@&sr=Sale", varURL)
                    }
                    else if filterParameters.object(forKey: "availibilityType") as? NSString == "1"
                    {
                        varURL = String(format: "%@&sr=Lease", varURL)
                    }
                    
                }
                if filterParameters.object(forKey: "maxPrice") as? NSString != nil && filterParameters.object(forKey: "maxPrice") as? NSString != ""
                {
                    varURL = String(format: "%@&max=%@", varURL, (filterParameters.object(forKey: "maxPrice") as? NSString)!)
                }
                if filterParameters.object(forKey: "minPrice") as? NSString != nil && filterParameters.object(forKey: "minPrice") as? NSString != ""
                {
                    varURL = String(format: "%@&min=%@", varURL, (filterParameters.object(forKey: "minPrice") as? NSString)!)
                }
                //end
                let strURL = String(format: "%@%@", baseURL, varURL)
                print(strURL)
                guard let url = URL(string: strURL) else {
                    print("Error: invalid data url")
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {// check for fundamental networking error
                        if let error = error as NSError?, error.domain == NSURLErrorDomain {
                            //print(error.code)
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error!!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error!!", message: String(format: "Internal Server Error:%i", httpStatus.statusCode), preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {// check for http errors
//                        print("response = \(String(describing: response))")
//                        print("data = \(String(describing: data))")
//                        guard let responseString = String(data: data, encoding: .utf8) else
//                        {
//                            return
//                        }
//                        print("responseString = \(String(describing: responseString))")
                        
//                        guard let unwrappedResponse = responseString
//                            else{
//                                return
//                        }
                        //print(unwrappedResponse)
                        do {
                            let dataDictionary : NSDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any] as NSDictionary
                            print(dataDictionary)
                            let propertyListArray :  NSMutableArray = dataDictionary.object(forKey: "data") as! NSMutableArray
                            print(propertyListArray)
                            for aProperty in propertyListArray
                            {
                                let currentProperty = aProperty as! NSMutableDictionary
                                print(currentProperty)
                                //self.addNodes(currentProperty.object(forKey: "salerent") as! NSString, "59900", currentProperty.object(forKey: "address") as! NSString, long, lat, (currentProperty.object(forKey: "longitude") as! NSString).doubleValue, (currentProperty.object(forKey: "latitude") as! NSString).doubleValue)
                                print(NSString.init(format: "%.2f", currentProperty.object(forKey: "price") as! Double))
                                print(currentProperty.object(forKey: "longitude") as! Double)
                                DispatchQueue.main.async {
                                    self.addNodes(currentProperty.object(forKey: "salerent") as! NSString, NSString.init(format: "%.2f", currentProperty.object(forKey: "price") as! Double), currentProperty.object(forKey: "address") as! NSString, long, lat, currentProperty.object(forKey: "longitude") as! Double, currentProperty.object(forKey: "latitude") as! Double,currentProperty)
                                }
                                
                            }
                            
                        } catch {
                            print("Something went wrong")
                        }
                        return
                        
                    }
                    
                }
                task.resume()
            }
            
            return
        }
        NetworkManager.isUnreachable { networkManagerInstance in
            let alert = UIAlertController(title: "Info", message: "Please Check Your Internet Connection.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    //helper functions to calculate translation of a node
    
    func positionFromTransform(_ transform: simd_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func transformMatrix(_ matrix: simd_float4x4, _ distance:Double, _ bearing:Double) -> simd_float4x4 {
        let rotationMatrix = rotateAroundY(matrix_identity_float4x4, Float(bearing))
        
        let position = vector_float4(0.0, 0.0, Float(-distance), 0.0)
        let translationMatrix = getTranslationMatrix(matrix_identity_float4x4, position)
        
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        
        return simd_mul(matrix, transformMatrix)
    }
    
    func getTranslationMatrix(_ matrix: simd_float4x4, _ translation : vector_float4) -> simd_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    func rotateAroundY(_ matrix: simd_float4x4, _ degrees: Float) -> simd_float4x4 {
        var matrix = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
    // MARK: - Step:2 (calculating position of each property from user's current location)
    func calculatePosition(_ longFrom: Double, _ latFrom: Double, _ longTo: Double, _ latTo: Double)-> SCNVector3{
        
        let coordinate₀ = CLLocation(latitude: latFrom, longitude: longFrom)
        let coordinate₁ = CLLocation(latitude: latTo, longitude: longTo)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // distance in meters
        
        print("Distance: ", distanceInMeters)
        
        let bearing = calculateBearing(longFrom, latFrom, longTo, latTo: latTo)
        print("Bearing: ", bearing)
        
        let locationTransform = transformMatrix(matrix_identity_float4x4, distanceInMeters, bearing)
        return positionFromTransform(locationTransform)
        
    }
    
    // MARK: - Step:3 (add nodes to each property)
    func addNodes(_ propertyType: NSString, _ price: NSString, _ address: NSString, _ longFrom: Double, _ latFrom: Double, _ longTo: Double, _ latTo: Double, _ propertyDetails: NSMutableDictionary)
    {
        let propertyTypeText = propertyType as String
        let priceText = price as String
        let addressText = address as String
        let container = SCNBox(width: 6.0, height: 4.0, length: 0.001, chamferRadius: 0)
        let container2 = SCNBox(width: 1.0, height: 0.3, length: 0.001, chamferRadius: 0)
        
        //var originalTransform:SCNMatrix4!
        let coordinate₀ = CLLocation(latitude: latFrom, longitude: longFrom)
        let coordinate₁ = CLLocation(latitude: latTo, longitude: longTo)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // distance in meters
        
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 250, height: 80)
        layer.backgroundColor = UIColor.white.cgColor
        
        let gradient2 = CAGradientLayer()
        gradient2.frame = layer.bounds
        gradient2.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
        layer.insertSublayer(gradient2, at: 0)
        
        let textLayer = CATextLayer()
        textLayer.frame = layer.bounds
        textLayer.fontSize = 15
        textLayer.string = "   " + addressText + "\n   Price: $" + priceText + "\n   For " + propertyTypeText + "\n   Distance: " + String(format: "%.2f",distanceInMeters) + " m"
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.backgroundColor = UIColor.lightGray.cgColor
        textLayer.foregroundColor = UIColor.darkText.cgColor
        textLayer.display()
        layer.addSublayer(textLayer)
        
//        let materialPropertyType = SCNMaterial()
//        materialPropertyType.diffuse.contents = UIColor.black
//        propertyTypeText.materials = [materialPropertyType]
//
//        let materialPrice = SCNMaterial()
//        materialPrice.diffuse.contents = UIColor.black
//        priceText.materials = [materialPrice]
//
//        let materialAddress = SCNMaterial()
//        materialAddress.diffuse.contents = UIColor.black
//        addressText.materials = [materialAddress]
        
        let materialContainer = SCNMaterial()
        materialContainer.diffuse.contents = UIColor.white
        materialContainer.diffuse.contents = layer
        container.materials = [materialContainer]
        
        let materialContainer2 = SCNMaterial()
        materialContainer2.diffuse.contents = UIColor.white
        materialContainer2.diffuse.contents = layer
        container2.materials = [materialContainer2]
        
        let node = SCNNode(geometry: container)
        // Move model's pivot to its center in the Y axis
        //let (minBox, maxBox) = node.boundingBox
        //node.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y)/2, 0)
        let checkPos = calculatePosition(longFrom, latFrom, longTo, latTo)
        print("Position of the Node: ",checkPos.x," ", checkPos.y," ",checkPos.z)
        node.position = checkPos
        
        
        
        //node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        //node.geometry = container
        
        //dummy
        //let node2 = SCNNode(geometry: container2)
        //node2.position = SCNVector3(0, 0, 0.9)
        //dummy
        
        //let nodePropertyType = SCNNode(geometry: propertyTypeText)
        //nodePropertyType.position = SCNVector3(0, 0, 0)
        node.setValue(propertyDetails, forKey: "propertyDetails")
        node.constraints = [SCNBillboardConstraint()]
        ARSCNStreetView.scene.rootNode.addChildNode(node)
        //ARSCNStreetView.scene.rootNode.addChildNode(node2)
        //ARSCNStreetView.scene.rootNode.addChildNode(nodePropertyType)
        ARSCNStreetView.autoenablesDefaultLighting = true
        
        
        // Update UI
        let label1 = UILabel()
        label1.frame.size = CGSize(width: 12.0, height: 12.0)
        label1.layer.cornerRadius = label1.frame.height/2
        label1.layer.masksToBounds = true
        let xPos = CGFloat(Int(checkPos.x/10))
        label1.center.x = 80 + xPos
        let yPos = CGFloat(Int(checkPos.z/10))
        label1.center.y =  self.ARSCNStreetView.frame.height  - 80 + yPos
        label1.backgroundColor = UIColor.green
        //dynamicLabel.textAlignment = NSTextAlignment.Center
        //dynamicLabel.text = "test label"
        
        
        self.ARSCNStreetView.addSubview(label1)
        
        
        
        
    }
    // MARK: - Step:4 (add click event on each property)
    
    
    // MARK: - side menu
    @IBAction func showSideMenu(_ sender: UIButton)
    {
        if(self.sideMenuConstraint.constant == -240)
        {
            UIView.animate(withDuration: (0.2), animations: {
                self.sideMenuConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            })
        }
    }
    @objc func hideSideMenu(_ sender: UIButton)
    {
        if(self.sideMenuConstraint.constant == 0)
        {
            UIView.animate(withDuration: (0.2), animations: {
                self.sideMenuConstraint.constant = -240
                self.view.layoutIfNeeded()
                
            })
        }
        
    }
    // MARK: - filter related
    @IBAction func showHideFilter(_ sender: UIButton) {
        if(self.filterContainerViewConstraint.constant == -240)
        {
            UIView.animate(withDuration: (0.2), animations: {
                self.filterContainerViewConstraint.constant = 0
                self.view.layoutIfNeeded()

            })
        }
        else if(self.filterContainerViewConstraint.constant == 0)
        {
            let filterParameters = populateFilterParametersDict ()
            print(filterParameters)
            runCode()
            UIView.animate(withDuration: (0.2), animations: {
                //self.filterContainerview.txtMaxPrice.text
                //self.filterContainerview.txtMinPrice.text
                self.filterContainerViewConstraint.constant = -240
                self.view.layoutIfNeeded()

            })
        }
        else
        {
            
        }
    }
    
    @objc func hideFilter(_ sender: UIButton)
    {
        if(self.filterContainerViewConstraint.constant == 0)
        {
            let filterParameters = populateFilterParametersDict ()
            print(filterParameters)
            runCode()
            UIView.animate(withDuration: (0.2), animations: {
                //self.filterContainerview.txtMaxPrice.text
                //self.filterContainerview.txtMinPrice.text
                self.filterContainerViewConstraint.constant = -240
                self.view.layoutIfNeeded()
                
            })
        }
        
    }
    
    
    @IBAction func chkBtnRent(_ sender: UIButton) {
        if self.availibilityType.isEqual(to: "0")
        {
            self.availibilityType = "1"
            self.btnChkRent.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
            self.btnChkSale.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            let filterParameters = populateFilterParametersDict ()
            print(filterParameters)
            runCode()
            //load everything again here
        }
    }
    
   
    @IBAction func chkBtnSale(_ sender: UIButton) {
        if self.availibilityType.isEqual(to: "1")
        {
            self.availibilityType = "0"
            self.btnChkRent.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            self.btnChkSale.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
            let filterParameters = populateFilterParametersDict ()
            print(filterParameters)
            runCode()
            //load everything again here
        }
    }
    
    // MARK: - populate filter
    func populateFilterParametersDict () -> NSMutableDictionary
    {
        let filterParametersDict : NSMutableDictionary = NSMutableDictionary ()
        
        filterParametersDict.setValue(self.availibilityType, forKey: "availibilityType")
        filterParametersDict.setValue(self.filterContainerview.txtMinPrice.text, forKey: "minPrice")
        filterParametersDict.setValue(self.filterContainerview.txtMaxPrice.text, forKey: "maxPrice")
        
        if self.filterContainerview.chkedRes == false && self.filterContainerview.chkedCom == false && self.filterContainerview.chkedCon == false
        {
            filterParametersDict.setValue("1", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == true && self.filterContainerview.chkedCom == false && self.filterContainerview.chkedCon == false
        {
            filterParametersDict.setValue("2", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == false && self.filterContainerview.chkedCom == true && self.filterContainerview.chkedCon == false
        {
            filterParametersDict.setValue("3", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == false && self.filterContainerview.chkedCom == false && self.filterContainerview.chkedCon == true
        {
            filterParametersDict.setValue("4", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == true && self.filterContainerview.chkedCom == true && self.filterContainerview.chkedCon == false
        {
            filterParametersDict.setValue("5", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == true && self.filterContainerview.chkedCom == false && self.filterContainerview.chkedCon == true
        {
            filterParametersDict.setValue("6", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == false && self.filterContainerview.chkedCom == true && self.filterContainerview.chkedCon == true
        {
            filterParametersDict.setValue("7", forKey: "propertyType")
        }
        else if self.filterContainerview.chkedRes == true && self.filterContainerview.chkedCom == true && self.filterContainerview.chkedCon == true
        {
            filterParametersDict.setValue("8", forKey: "propertyType")
        }
        return filterParametersDict
        
    }
    
    // MARK: - handle tap on nodes
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: self.ARSCNStreetView)
            let hits = self.ARSCNStreetView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                let propertyDetails = (tappedNode?.value(forKey: "propertyDetails")) as! NSMutableDictionary
                print(propertyDetails)
                print("You tapped a node.")
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                vc.propertyDetails = propertyDetails
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
