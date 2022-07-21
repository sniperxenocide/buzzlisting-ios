//
//  ViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 2/25/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   // MARK: - Outlets and Variables
    //panGestureRecognizer
    //@IBOutlet var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    //side menu
    @IBOutlet var sideMenuView: UIView!
    @IBOutlet var sideMenuVisualEffect: UIVisualEffectView!
    @IBOutlet var sideMenuVisualEffectView: UIView!
    @IBOutlet var sideMenuButton: UIButton!
    @IBOutlet var sideMenuConstraint: NSLayoutConstraint!
    //side menu elements
    @IBOutlet var backBtnLogoView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var imgAppLogo: UIImageView!
    @IBOutlet var signInUPBtn: UIButton!
    @IBOutlet var tblSideMenu: UITableView!
    //google map
    @IBOutlet var googleMapView: GMSMapView!
    @IBOutlet var btnGoogleMapSearch: UIButton!
    // MARK: - Initialization Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //screenEdgePanGestureRecognizer.delegate = self
        sideMenuView.layer.shadowColor = UIColor.black.cgColor
        sideMenuView.layer.shadowOpacity = 0.8
        sideMenuView.layer.shadowOffset = CGSize(width: 5, height:0)
        sideMenuConstraint.constant = -240
        
        btnGoogleMapSearch.layer.cornerRadius = 3
        btnGoogleMapSearch.layer.borderWidth = 1
        btnGoogleMapSearch.layer.borderColor = UIColor.lightGray.cgColor
        
        
        //register table view cells
        self.tblSideMenu.register(UINib(nibName: "tblSideMenuCell", bundle: nil), forCellReuseIdentifier: "tblSideMenuCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let strURL = String(format:"%@/api/v1/freehold/?start=1&length=20", GlobalConstants.baseURL)
        let url = URL(string: strURL)
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        print(stringData) //JSONSerialization
//                        let address = "1 Infinite Loop, Cupertino, CA 95014"
//
//                        let geoCoder = CLGeocoder()
//                        geoCoder.geocodeAddressString(address) { (placemarks, error) in
//                            guard
//                                let placemarks = placemarks,
//                                let location = placemarks.first?.location
//                                else {
//                                    // handle no location found
//                                    return
//                            }
//
//                            // Use your location
//                        }
                    }
                }
            })
            task.resume()
        }
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//
//    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
//        if sender.state == .began || sender.state == .changed
//        {
//            let translation = sender.translation(in: self.view).x
//
//            if translation > 0 { //swipe right
//
//                if self.sideMenuConstraint.constant < 20
//                {
//                    UIView.animate(withDuration: (0.2), animations: {
//                        self.sideMenuConstraint.constant += translation
//                        self.view.layoutIfNeeded()
//
//                    })
//
//                }
//
//
//            }
//            else //swipe left
//            {
//                if self.sideMenuConstraint.constant > -240
//                {
//                    UIView.animate(withDuration: (0.2), animations: {
//                        self.sideMenuConstraint.constant += translation
//                        self.view.layoutIfNeeded()
//
//                    })
//
//                }
//
//            }
//        }
//        else if sender.state == .ended
//        {
//            if self.sideMenuConstraint.constant < -100
//            {
//                UIView.animate(withDuration: (0.2), animations: {
//                    self.sideMenuConstraint.constant = -240
//                    self.view.layoutIfNeeded()
//
//                })
//            }
//            else
//            {
//                UIView.animate(withDuration: (0.2), animations: {
//                    self.sideMenuConstraint.constant = 0
//                    self.view.layoutIfNeeded()
//
//                })
//
//            }
//        }
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Property List Related
    @IBAction func showPropertyListNavigationController(_ sender: UIButton) {
        let propertyListNavigationController = storyboard?.instantiateViewController(withIdentifier: "propertyListNavigationController") as! propertyListNavigationController
        present(propertyListNavigationController, animated: true, completion: nil)
        
    }
    // MARK: - Side menu related
    @IBAction func showHideSideMenu(_ sender: UIButton) {
        if(self.sideMenuConstraint.constant == -240)
        {
            UIView.animate(withDuration: (0.2), animations: {
                self.sideMenuConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            })
        }
        else if(self.sideMenuConstraint.constant == 0)
        {
            UIView.animate(withDuration: (0.2), animations: {
                self.sideMenuConstraint.constant = -240
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    @IBAction func goBackFromSideMenu(_ sender: UIButton) {
        if(self.sideMenuConstraint.constant == 0)
        {
            UIView.animate(withDuration: (0.2), animations: {
                self.sideMenuConstraint.constant = -240
                self.view.layoutIfNeeded()
                
            })
        }
    }
    // MARK: - Sign In or Sign UP
    @IBAction func signInUPAction(_ sender: UIButton) {
        let loginNavigationController = storyboard?.instantiateViewController(withIdentifier: "loginNavigationController") as! loginNavigationController
        present(loginNavigationController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == self.tblSideMenu
        {
            return 3
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblSideMenu
        {
            if section == 0
            {
                return 3
            }
            else if section == 1
            {
                return 6
            }
            else if section == 2
            {
                return 1
            }
            else
            {
                return 0
            }
            
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblSideMenuCell", for: indexPath) as! tblSideMenuCell

        if tableView == self.tblSideMenu
        {
            if indexPath.section == 0
            {
                if indexPath.row == 0
                {
                    cell.titleMenuItem.text = "For Sale"
                    cell.imgManuItem.image = UIImage.init(named: "for_sale")
                }
                else if indexPath.row == 1
                {
                    cell.titleMenuItem.text = "For Rent"
                    cell.imgManuItem.image = UIImage.init(named: "for_rent")
                }
                else if indexPath.row == 2
                {
                    cell.titleMenuItem.text = "Recently Sold"
                    cell.imgManuItem.image = UIImage.init(named: "recently_sold")
                }
                else
                {
                    //do nothing
                }
            }
            else if indexPath.section == 1
            {
                if indexPath.row == 0
                {
                    cell.titleMenuItem.text = "On-the-GO"
                    cell.imgManuItem.image = UIImage.init(named: "street_peek")
                }
//                else if indexPath.row == 1
//                {
//                    cell.titleMenuItem.text = "Notifications"
//                    cell.imgManuItem.image = UIImage.init(named: "notifications")
//                }
                else if indexPath.row == 1
                {
                    cell.titleMenuItem.text = "Saved Searches"
                    cell.imgManuItem.image = UIImage.init(named: "saved_favorites")
                }
                if indexPath.row == 2
                {
                    cell.titleMenuItem.text = "Favorite Listings"
                    cell.imgManuItem.image = UIImage.init(named: "saved_favorites")
                }
                else if indexPath.row == 3
                {
                    cell.titleMenuItem.text = "Contacted Listings"
                    cell.imgManuItem.image = UIImage.init(named: "contacted_listings")
                }
                else if indexPath.row == 4
                {
                    cell.titleMenuItem.text = "Recently Viewed Listings"
                    cell.imgManuItem.image = UIImage.init(named: "recently_viewed_searches")
                }
                else if indexPath.row == 5
                {
                    cell.titleMenuItem.text = "Recent Searches"
                    cell.imgManuItem.image = UIImage.init(named: "recently_viewed_searches")
                }
                else
                {
                    //do nothing
                }
                
            }
            else if indexPath.section == 2
            {
//                if indexPath.row == 0
//                {
//                    cell.titleMenuItem.text = "Rate This App"
//                    cell.imgManuItem.image = UIImage.init(named: "rate_this_app")
//                }
//                else if indexPath.row == 1
//                {
//                    cell.titleMenuItem.text = "Feedback"
//                    cell.imgManuItem.image = UIImage.init(named: "feedback")
//                }
//                else if indexPath.row == 2
//                {
//                    cell.titleMenuItem.text = "List a rental"
//                    cell.imgManuItem.image = UIImage.init(named: "list_a_rental")
//                }
                if indexPath.row == 0
                {
                    cell.titleMenuItem.text = "Settings"
                    cell.imgManuItem.image = UIImage.init(named: "settings")
                }
                else
                {
                    //do nothing
                }
            }
            else
            {
                //do nothing
            }
        }
        return cell
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
   
    
    // MARK: - Google map search start
    
    @IBAction func typeSearchPlaceView(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String)
    {
        DispatchQueue.main.async() { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)

            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapView.camera = camera
            marker.title = "Address : \(title)"
            marker.map = self.googleMapView
        }

    }
    
    
}
// MARK: - Google map keyboard
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
//        print("Place address: \(String(describing: place.formattedAddress))")
//        print("Place attributions: \(String(describing: place.attributions))")
        
        
        
        DispatchQueue.main.async() { () -> Void in
            let position = place.coordinate
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 10)
            self.googleMapView.camera = camera
            marker.title = "Address : \(place.name)"
            marker.map = self.googleMapView
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

