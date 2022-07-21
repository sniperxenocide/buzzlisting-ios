//
//  propertyListViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 2/27/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class propertyListviewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    // MARK: - Outlets and Variables
    @IBOutlet var tblPropertyList: UITableView!
    var sr: NSString = ""
    var lat: NSString = ""
    var long: NSString = ""
    var dataarray : NSMutableArray = NSMutableArray()
    // MARK: - Initialization Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //register table view cells
        self.tblPropertyList.register(UINib(nibName: "tblPropertyListCell", bundle: nil), forCellReuseIdentifier: "tblPropertyListCell")
        //adding a pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.panPerformed(_:))))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        
        print(self.sr)
        print(self.lat)
        print(self.long)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //call API to get data
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseURL
                //&type=1&sr=Sale&max=1800000&min=700000
                //let varURL = String(format: "/api/v1/ardata/?lat=%@&long=%@&sr=%@", self.lat, self.long, self.sr)
                let varURL = String(format: "/api/v1/ardata/?lat=%@&long=%@&sr=%@", "43.82782", "-79.5072", self.sr)
                
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
                        
                        do {
                            let dataDictionary : NSDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any] as NSDictionary
                            print(dataDictionary)
                            self.dataarray = dataDictionary.object(forKey: "data") as! NSMutableArray
                            print(self.dataarray)
                            DispatchQueue.main.async {
                                self.tblPropertyList.reloadData()
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
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Info", message: "Please Check Your Internet Connection.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        //end
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == self.tblPropertyList
        {
            return self.dataarray.count
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblPropertyListCell", for: indexPath) as! tblPropertyListCell
        let propertyAtCurrentIndex : NSMutableDictionary = self.dataarray[indexPath.section] as! NSMutableDictionary
        if(propertyAtCurrentIndex.object(forKey: "address") as? String != nil)
        {
            cell.propertyAddress.text = propertyAtCurrentIndex.object(forKey: "address") as? String
        }
        if(propertyAtCurrentIndex.object(forKey: "salerent") as? String != nil)
        {
            cell.propertyType.text = String(format: "Property for %@", (propertyAtCurrentIndex.object(forKey: "salerent") as? String)!)
        }
        if(propertyAtCurrentIndex.object(forKey: "price") as? Double != nil)
        {
            cell.propertyPrice.text = String(format: "$%.2f/mo", (propertyAtCurrentIndex.object(forKey: "price") as? Double)!)
        }
        if(propertyAtCurrentIndex.object(forKey: "area") as? String != nil && propertyAtCurrentIndex.object(forKey: "municipality") as? String != nil)
        {
            cell.propertyDetails.text = String(format:"%@, %@",propertyAtCurrentIndex.object(forKey: "area") as! String, propertyAtCurrentIndex.object(forKey: "municipality") as! String)
        }
        //add target to save favorites
        cell.btnFavorites.tag = indexPath.section
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
            {
                let realm = try! Realm()
                let strQry = String(format:"id == '%@'", String(format: "%@_%d", UserDefaults.standard.string(forKey: "username")!, propertyAtCurrentIndex.object(forKey: "id") as! NSInteger))
                print(strQry)
                let userFavorites = realm.objects(favPropertiesTable.self).filter(strQry)
                
                if userFavorites.count == 0
                {
                    cell.btnFavorites.setImage(UIImage.init(named: "add_favorites"), for: UIControlState.normal)
                }
                else
                {
                    cell.btnFavorites.setImage(UIImage.init(named: "saved_favorites"), for: UIControlState.normal)
                }
            }
        }
        
        cell.btnFavorites.addTarget(self, action: #selector(saveFavorites(_:)), for: UIControlEvents.touchUpInside)
        //image load
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async
            {
                let baseURL = GlobalConstants.baseMediaURL
                let typeInt = propertyAtCurrentIndex.object(forKey: "type") as! NSInteger
                var type = ""
                if(typeInt == 1)
                {
                    type = "Residential"
                }
                else if(typeInt == 2)
                {
                    type = "Condo"
                }
                else
                {
                    type = "Commercial"
                }
                
                let mls = propertyAtCurrentIndex.object(forKey: "mls#") as! NSString
                print(type)
                print(mls)
                let varURL = String(format: "%@/%@-1.jpeg", type, mls)
                print(varURL)
                let strURL = String(format: "%@%@", baseURL, varURL)
                print(strURL)
                let url = URL(string: strURL)
                if url != nil
                {
                    var request = URLRequest(url: url!)
                    request.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if data != nil && error == nil
                        {
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                                DispatchQueue.main.async {
                                    cell.imgProperty.image = UIImage.init(named: "img_unavailable")
                                    let alert = UIAlertController(title: "Error!!", message: String(format: "Internal Server Error:%i", httpStatus.statusCode), preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                            
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {// check for http errors
                                DispatchQueue.main.async {
                                    if data != nil
                                    {
                                        
                                        cell.imgProperty.image = UIImage(data: data!)
                                    }
                                    else
                                    {
                                        cell.imgProperty.image = UIImage.init(named: "img_unavailable")
                                    }
                                    
                                }
                                
                            }
                        
                        
                        }
                        
                        else
                        {
                            DispatchQueue.main.async {
                                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                                    cell.imgProperty.image = UIImage.init(named: "img_unavailable")
                                    //print(error.code)
                                    let alert = UIAlertController(title: "Error!!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                   }
                  task.resume()
                }
            
             }
        }
        NetworkManager.isUnreachable { networkManagerInstance in
            DispatchQueue.main.async {
                cell.imgProperty.image = UIImage.init(named: "img_unavailable")
                let alert = UIAlertController(title: "Info", message: "Image Couldn't be loaded. Please Check Your Internet Connection.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        //image
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == self.tblPropertyList
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            //self.present(vc, animated: true, completion: nil)
            vc.propertyDetails = self.dataarray[indexPath.section] as! NSMutableDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Go Back From Current View
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    
    }
    
    // MARK: - Vanish Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - save favorites
    @objc func saveFavorites(_ sender: UIButton)
    {
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
            {
                print(sender.tag)
                if sender.tag < 0 || sender.tag > self.dataarray.count - 1
                {
                    return
                }
                let currentPropertyDictionary : NSMutableDictionary = self.dataarray[sender.tag] as! NSMutableDictionary
                if UserDefaults.standard.string(forKey: "username") == nil || currentPropertyDictionary.object(forKey: "id") as? NSInteger == nil
                {
                    return
                }
                let realm = try! Realm()
                let strQry = String(format:"id == '%@'", String(format: "%@_%d", UserDefaults.standard.string(forKey: "username")!, currentPropertyDictionary.object(forKey: "id") as! NSInteger))
                let userFavorites = realm.objects(favPropertiesTable.self).filter(strQry)
                
                if userFavorites.count == 0
                {
                    //add this entry
                    let myFavProperty = favPropertiesTable()
                    print(currentPropertyDictionary)
                    myFavProperty.id = String(format: "%@_%d", UserDefaults.standard.string(forKey: "username")!, currentPropertyDictionary.object(forKey: "id") as! NSInteger)
                    myFavProperty.username = UserDefaults.standard.string(forKey: "username")!
                    myFavProperty.property_id = String(format:"%d",currentPropertyDictionary.object(forKey: "id") as! NSInteger)
                    
                    if currentPropertyDictionary.object(forKey: "mls#") as? String != nil
                    {
                        myFavProperty.mls = (currentPropertyDictionary.object(forKey: "mls#") as? String)!
                    }
                    if currentPropertyDictionary.object(forKey: "type") as? Int != nil
                    {
                        myFavProperty.typeInt = String(format:"%d",(currentPropertyDictionary.object(forKey: "type") as? Int)!)
                    }
                    if(currentPropertyDictionary.object(forKey: "address") as? String != nil)
                    {
                        myFavProperty.address = (currentPropertyDictionary.object(forKey: "address") as? String)!
                    }
                    if(currentPropertyDictionary.object(forKey: "salerent") as? String != nil)
                    {
                        myFavProperty.property_type = String(format: "Property for %@", (currentPropertyDictionary.object(forKey: "salerent") as? String)!)
                    }
                    if(currentPropertyDictionary.object(forKey: "price") as? Double != nil)
                    {
                        myFavProperty.price = String(format: "$%.2f/mo", (currentPropertyDictionary.object(forKey: "price") as? Double)!)
                    }
                    if(currentPropertyDictionary.object(forKey: "area") as? String != nil && currentPropertyDictionary.object(forKey: "municipality") as? String != nil)
                    {
                        myFavProperty.municipality_area = String(format:"%@, %@",currentPropertyDictionary.object(forKey: "area") as! String, currentPropertyDictionary.object(forKey: "municipality") as! String)
                    }
                    try! realm.write {
                        realm.add(myFavProperty)
                    }
                    sender.setImage(UIImage.init(named: "saved_favorites"), for: UIControlState.normal)
                }
                else
                {
                    //delete this entry
                    sender.setImage(UIImage.init(named: "add_favorites"), for: UIControlState.normal)
                    try! realm.write {
                        realm.delete(userFavorites)
                    }
                    
                }
            }
            else
            {
                let alert = UIAlertController(title: "Info", message: "You are not logged in. Please login if you already have an account or register to get a new account.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Info", message: "You are not logged in. Please login if you already have an account or register to get a new account.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Show Side Menu on slide
    @objc func panPerformed(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began || panGesture.state == .changed
        {
            let translation = panGesture.translation(in: self.view).x
            
            if translation > 0 { //swipe right
                //self.performSegue(withIdentifier: "segueToSideMenu", sender: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "sideMenuViewController") as! sideMenuViewController
                let transition:CATransition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.present(vc, animated: false, completion: nil)
                
//                DispatchQueue.main.async() { () -> Void in
                    //self.performSegue(withIdentifier: "segueToSideMenu", sender: nil)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "sideMenuViewController") as! sideMenuViewController
//
//                    let transition: CATransition = CATransition()
//                    let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//                    transition.duration = 0.5
//                    transition.timingFunction = timeFunc
//                    transition.type = kCATransitionMoveIn
//                    transition.subtype = kCATransitionFromLeft
//
//                    self.navigationController?.view.layer.add(transition, forKey: kCATransition)
//                    self.navigationController?.pushViewController(vc, animated: false)
//                    let transition = CATransition()
//                    transition.duration = 0.5
//                    transition.type = kCATransitionReveal
//                    transition.subtype = kCATransitionFromLeft
//                    transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    
//                    let src = self
//                    let dst = vc
//
//                    //src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
//                    self.present(vc, animated: false, completion: nil)
//                    dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
//
//
//                    UIView.animate(withDuration: 0.25,
//                                   delay: 0.0,
//                                   options: UIViewAnimationOptions.curveEaseInOut,
//                                   animations: {
//                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//
//                    },
//                                   completion: nil
//                    )
                    
                    //self.present(vc, animated: true, completion: nil)
//                }
                
                
                
            }
            else //swipe left
            {
                
                
            }
        }
        else if panGesture.state == .ended
        {
            
        }
    }
}
