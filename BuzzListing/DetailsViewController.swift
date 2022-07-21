//
//  DetailsViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/6/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DetailsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    // MARK: - view components
    @IBOutlet var contactView: UIView!
    @IBOutlet var btnContact: UIButton!
    @IBOutlet var tblDetails: UITableView!
    
    @IBOutlet var imgScrollView: UIScrollView!
    //data
    @IBOutlet var listPrice: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var saleRent: UILabel!
    @IBOutlet var numberOfBeds: UILabel!
    @IBOutlet var numberOfBaths: UILabel!
    @IBOutlet var sqFt: UILabel!
    @IBOutlet var petPolicy: UILabel!
    
    @IBOutlet var btnFavorites: UIButton!
    //data
    
    //property Details Dictionary
    var propertyDetails : NSMutableDictionary = NSMutableDictionary()
    var dataDictionary : NSDictionary = NSDictionary()
    //array to contain images
    var imagesArray : [UIImage] = []
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        //design
        contactView.layer.shadowColor = UIColor.black.cgColor
        contactView.layer.shadowOpacity = 0.8
        contactView.layer.shadowOffset = CGSize(width: 5, height:0)
        btnContact.layer.cornerRadius = 3
        //register table cells
        self.tblDetails.register(UINib(nibName: "tblDetailsDescriptionCell", bundle: nil), forCellReuseIdentifier: "tblDetailsDescriptionCell")
        self.tblDetails.register(UINib(nibName: "tblDetailsAdditionalInfoCell", bundle: nil), forCellReuseIdentifier: "tblDetailsAdditionalInfoCell")
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        //indicate favorite or not
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
            {
                let realm = try! Realm()
                let strQry = String(format:"id == '%@'", String(format: "%@_%d", UserDefaults.standard.string(forKey: "username")!, self.propertyDetails.object(forKey: "id") as! NSInteger))
                print(strQry)
                let userFavorites = realm.objects(favPropertiesTable.self).filter(strQry)
                
                if userFavorites.count == 0
                {
                    self.btnFavorites.setImage(UIImage.init(named: "add_favorites"), for: UIControlState.normal)
                }
                else
                {
                    self.btnFavorites.setImage(UIImage.init(named: "saved_favorites"), for: UIControlState.normal)
                }
            }
        }
        //end
        //print(propertyDetails)
        fetchData()
    }
    // MARK: - Fetch Data
    func fetchData()
    {
        //call api to get details
        NetworkManager.isReachable { networkManagerInstance in
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseURL
                guard self.propertyDetails.object(forKey: "id") != nil else
                {
                    return
                }
                guard self.propertyDetails.object(forKey: "type") != nil else
                {
                    return
                }
                let propertyId : NSInteger = self.propertyDetails.object(forKey: "id") as! NSInteger
                let propertyType : NSInteger = self.propertyDetails.object(forKey: "type") as! NSInteger
                var varURL : String = ""
                if propertyType == 1
                {
                    varURL = String(format: "/api/v1/%@/%d/","freehold",propertyId)
                }
                else if propertyType == 2
                {
                    varURL = String(format: "/api/v1/%@/%d/","condo",propertyId)
                }
                else
                {
                    varURL = String(format: "/api/v1/%@/%d/","commercial",propertyId)
                }
                
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
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                        
                        do {
                            self.dataDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any] as NSDictionary
                            print(self.dataDictionary)
                            DispatchQueue.main.async {
                                
                                self.loadHeaderData()
                                self.tblDetails.reloadData()
                                self.loadImages()
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
            }
            
            return
        }
        //end
    }
    // MARK: - load images
    func loadImages()
    {
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async
            {
                    let baseURL = GlobalConstants.baseMediaURL
                    let typeInt = self.propertyDetails.object(forKey: "type") as! NSInteger
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
                    let mls = self.propertyDetails.object(forKey: "mls#") as! NSString
                    print(type)
                    print(mls)
                
                    //while loop
                    var iterator : NSInteger = 1
                
                    while iterator < 20
                    {
                        
                        let varURL = String(format: "%@/%@-%d.jpeg", type, mls, iterator)
                        iterator = iterator + 1
                        print(varURL)
                        let strURL = String(format: "%@%@", baseURL, varURL)
                        //let strURL = "http://182.160.114.45:8910/media/Images/Commercial/N4018399-1000.jpeg"
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
                                    
                                }
                                return
                            }
                            
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                                
                            }
                            
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                                DispatchQueue.main.async {
                                    self.imagesArray.append(UIImage(data: data)!)
                                    print(self.imagesArray)
                                    let imageView = UIImageView()
                                    let x = 200 * CGFloat(self.imagesArray.count-1) + CGFloat(5*((self.imagesArray.count-1) + 1))
                                    imageView.frame = CGRect(x: x, y: 5, width: 200, height: self.imgScrollView.frame.height-10)
                                    //imageView.contentMode = .scaleToFill
                                    imageView.image = self.imagesArray[self.imagesArray.count-1]
                                    self.imgScrollView.contentSize.width = 200 * CGFloat(self.imagesArray.count) + CGFloat(5*self.imagesArray.count)
//
//
//
//                                    if self.imgScrollView.frame.width > 375
//                                    {
//                                        let x = 200 * CGFloat(self.imagesArray.count-1) + CGFloat(5*((self.imagesArray.count-1) + 1))
//                                        imageView.frame = CGRect(x: x, y: 5, width: 200, height: self.imgScrollView.frame.height-10)
//                                        //imageView.contentMode = .scaleToFill
//                                        imageView.image = self.imagesArray[self.imagesArray.count-1]
//                                        self.imgScrollView.contentSize.width = 200 * CGFloat(self.imagesArray.count) + CGFloat(5*self.imagesArray.count)
//                                    }
//                                    else
//                                    {
//                                        let x = self.imgScrollView.frame.size.width * CGFloat(self.imagesArray.count-1) + CGFloat(5*((self.imagesArray.count-1) + 1))
//                                        imageView.frame = CGRect(x: x, y: 5, width: self.imgScrollView.frame.width-10, height: self.imgScrollView.frame.height-10)
//                                        imageView.contentMode = .scaleToFill
//                                        imageView.image = self.imagesArray[self.imagesArray.count-1]
//                                        self.imgScrollView.contentSize.width = self.imgScrollView.frame.size.width * CGFloat(self.imagesArray.count) + CGFloat(5*self.imagesArray.count)
//                                    }
                                    
                                    self.imgScrollView.addSubview(imageView)
                                }
                                
                            }
                            
                        }
                        task.resume()
                    }
                
            }
            
        }
        
        NetworkManager.isUnreachable { networkManagerInstance in
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Info", message: "Images Couldn't be loaded. Please Check Your Internet Connection.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        //image
    }
    // MARK: - load header data
    func loadHeaderData()
    {
        self.listPrice.text = "$" + (self.dataDictionary.object(forKey: "ListPrice") as! String)
        let area = self.dataDictionary.object(forKey: "Area") as! String
        let addressText = self.dataDictionary.object(forKey: "Address") as! String
        
        if ((self.dataDictionary.object(forKey: "Municipality") as? String) != nil){
            self.address.text = addressText + ", " + (self.dataDictionary.object(forKey: "Municipality") as! String) + ", " + area
        }
        else{
            self.address.text = "N/A"
        }
        if ((self.dataDictionary.object(forKey: "SaleLease") as? String) != nil){
            self.saleRent.text = "For " + (self.dataDictionary.object(forKey: "SaleLease") as! String)
        }
        else{
            self.saleRent.text = "N/A"
        }
        
        if (propertyDetails.object(forKey: "type") as! Int) == 1{
            if ((self.dataDictionary.object(forKey: "ApproxSquareFootage") as? String) != nil){
                self.sqFt.text = (self.dataDictionary.object(forKey: "ApproxSquareFootage") as! String) + ", " + (self.dataDictionary.object(forKey: "ApproxSquareFootage") as! String)
            }
            else{
                self.sqFt.text = "N/A"
            }
        }else if (propertyDetails.object(forKey: "type") as! Int) == 2{
            if ((self.dataDictionary.object(forKey: "ApproxSquareFootage") as? String) != nil){
                self.sqFt.text = (self.dataDictionary.object(forKey: "ApproxSquareFootage") as! String) + ", " + (self.dataDictionary.object(forKey: "ApproxSquareFootage") as! String)
            }
            else{
                self.sqFt.text = "N/A"
            }
        }else{
            if ((self.dataDictionary.object(forKey: "TotalArea") as? String) != nil){
                self.sqFt.text = (self.dataDictionary.object(forKey: "TotalArea") as! String) + ", " + (self.dataDictionary.object(forKey: "TotalAreaCode") as! String)
            }
            else{
                self.sqFt.text = "N/A"
            }
        }
        
        if ((self.dataDictionary.object(forKey: "Washrooms") as? String) != nil){
            self.numberOfBaths.text = (self.dataDictionary.object(forKey: "Washrooms") as! String)
        }else{
            self.numberOfBaths.text = "N/A"
        }
        if self.dataDictionary["Bedrooms"] == nil{
            self.numberOfBeds.text = "N/A"
        }else{
            self.numberOfBeds.text = (self.dataDictionary.object(forKey: "Bedrooms") as! String)
        }
        
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 460
        }
        else if indexPath.section == 1
        {
            return 350
        }
        else
        {
            return 0
        }
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
//    {
//        return 5
//    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == self.tblDetails
        {
            return 2
        }
        else
        {
            return 0;
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.tblDetails
        {
            if indexPath.section == 0
            {
                let firstCell = tableView.dequeueReusableCell(withIdentifier: "tblDetailsDescriptionCell", for: indexPath) as! tblDetailsDescriptionCell
                firstCell.btnMoreDetails.addTarget(self, action: #selector(showMoreDetails), for: UIControlEvents.touchUpInside)
                //load data for first cell
                if self.dataDictionary["RemarksForClients"] != nil {
                    firstCell.txtDescription.text = (self.dataDictionary.object(forKey: "RemarksForClients") as! String)
                }
                
                if self.dataDictionary["ListPrice"] != nil {
                    firstCell.listPrice.text = "$" + (self.dataDictionary.object(forKey: "ListPrice") as! String)
                }

                if self.dataDictionary["Bedrooms"] != nil {
                    if ((self.dataDictionary.object(forKey: "Bedrooms") as? String) != nil){
                        firstCell.numberOfBeds.text = (self.dataDictionary.object(forKey: "Bedrooms") as! String)
                    }else{
                        firstCell.numberOfBeds.text = "N/A"
                    }
                }
                if self.dataDictionary["Washrooms"] != nil {
                    if ((self.dataDictionary.object(forKey: "Washrooms") as? String) != nil){
                        firstCell.numberOfBaths.text = (self.dataDictionary.object(forKey: "Washrooms") as! String)
                    }else{
                        firstCell.numberOfBaths.text = "N/A"
                    }
                    
                    //for commercial properties bedrooms are never available
                    if self.dataDictionary["Bedrooms"] == nil {
                        firstCell.numberOfBeds.text = "N/A"
                    }
                }
                
                if self.dataDictionary["Taxes"] != nil {
                    if ((self.dataDictionary.object(forKey: "Taxes") as? String) != nil){
                        firstCell.taxes.text = "$" + (self.dataDictionary.object(forKey: "Taxes") as! String)
                    }else{
                        firstCell.taxes.text = "N/A"
                    }
                }
                if self.dataDictionary["ListBrokerage"] != nil {
                    if ((self.dataDictionary.object(forKey: "ListBrokerage") as? String) != nil){
                        firstCell.brokerage.text = (self.dataDictionary.object(forKey: "ListBrokerage") as! String)
                    }else{
                        firstCell.brokerage.text = "N/A"
                    }
                }
                if self.dataDictionary["GarageType"] != nil {
                    if ((self.dataDictionary.object(forKey: "GarageType") as? String) != nil){
                        firstCell.garageType.text = (self.dataDictionary.object(forKey: "GarageType") as! String)
                    }else{
                        firstCell.garageType.text = "N/A"
                    }
                }
                if self.dataDictionary["AirConditioning"] != nil {
                    if ((self.dataDictionary.object(forKey: "AirConditioning") as? String) != nil){
                        firstCell.airConditioning.text = (self.dataDictionary.object(forKey: "AirConditioning") as! String)
                    }else{
                        firstCell.airConditioning.text = "N/A"
                    }
                }
                if (propertyDetails.object(forKey: "type") as! Int) == 1{
                    firstCell.propertyType.text = "Residential"
                }else if (propertyDetails.object(forKey: "type") as! Int) == 2{
                    firstCell.propertyType.text = "Condo"
                }else{
                    firstCell.propertyType.text = "Commercial"
                }
                //end
                return firstCell
            }
            else if indexPath.section == 1
            {
                let secondCell = tableView.dequeueReusableCell(withIdentifier: "tblDetailsAdditionalInfoCell", for: indexPath) as! tblDetailsAdditionalInfoCell
                //load daata for second cell
                if self.dataDictionary["Type2"] != nil {
                    if ((self.dataDictionary.object(forKey: "Type2") as? String) != nil){
                        secondCell.type2.text = (self.dataDictionary.object(forKey: "Type2") as! String)
                    }else{
                        secondCell.type2.text = "N/A"
                    }
                }
                if self.dataDictionary["MLSNumber"] != nil {
                    if ((self.dataDictionary.object(forKey: "MLSNumber") as? String) != nil){
                        secondCell.mls.text = (self.dataDictionary.object(forKey: "MLSNumber") as! String)
                    }else{
                        secondCell.mls.text = "N/A"
                    }
                }
                
                if self.dataDictionary["ParkingSpaces"] != nil {
                    if ((self.dataDictionary.object(forKey: "ParkingSpaces") as? String) != nil){
                        secondCell.parkingSpaces.text = (self.dataDictionary.object(forKey: "ParkingSpaces") as! String)
                    }else{
                        secondCell.parkingSpaces.text = "N/A"
                    }
                }
                
                if (propertyDetails.object(forKey: "type") as! Int) == 1{
//                    secondCell.style.text = (self.dataDictionary.object(forKey: "Style") as! String)
                    if ((self.dataDictionary.object(forKey: "Style") as? String) != nil){
                        secondCell.style.text = (self.dataDictionary.object(forKey: "Style") as! String)
                    }else{
                        secondCell.style.text = "N/A"
                    }
                }else if (propertyDetails.object(forKey: "type") as! Int) == 2{
//                    secondCell.style.text = (self.dataDictionary.object(forKey: "Style") as! String)
                    if ((self.dataDictionary.object(forKey: "Style") as? String) != nil){
                        secondCell.style.text = (self.dataDictionary.object(forKey: "Style") as! String)
                    }else{
                        secondCell.style.text = "N/A"
                    }
                }else{
                    secondCell.style.text = "N/A"
                }
                //end
                return secondCell
            }
            else
            {
                return cell
            }
            
        }
        return cell
    }
    
    // MARK: - load more details
    @objc func showMoreDetails(sender:UIButton!)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreDetailsViewController") as! MoreDetailsViewController
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Contact Related Method
    @IBAction func contactVendor(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        //self.present(vc, animated: true, completion: nil)
        vc.propertyImagesArray = self.imagesArray
        if self.propertyDetails.object(forKey: "id") as? NSInteger != nil
        {
            vc.propertyId = String(format: "%d", self.propertyDetails.object(forKey: "id") as! NSInteger)
        }
        else
        {
            return
        }
        if self.propertyDetails.object(forKey: "type") as? NSInteger != nil
        {
            vc.propertyType = String(format: "%d", self.propertyDetails.object(forKey: "type") as! NSInteger)
        }
        else
        {
            return
        }
        vc.propertyName = String(format:"this Property Situated at %@", (self.propertyDetails.object(forKey: "address") as? NSString)!)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - save as favorites
    
    @IBAction func saveFavorites(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
            {
                print(sender.tag)
                
                let currentPropertyDictionary : NSMutableDictionary = self.propertyDetails
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
    
    
}
