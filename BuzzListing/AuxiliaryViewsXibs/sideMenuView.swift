//
//  sideMenuView.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/5/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit

class sideMenuView: UIView, UITableViewDelegate, UITableViewDataSource {
    //side menu elements
    @IBOutlet var contentView: UIView!
    @IBOutlet var sideMenuVisualEffect: UIVisualEffectView!
    @IBOutlet var sideMenuVisualEffectView: UIView!
    @IBOutlet var backBtnLogoView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var imgAppLogo: UIImageView!
    @IBOutlet var signInUPBtn: UIButton!
    @IBOutlet var tblSideMenu: UITableView!
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    override func awakeFromNib() {
//        //register table view cells
//        self.tblSideMenu.register(UINib(nibName: "tblSideMenuCell", bundle: nil), forCellReuseIdentifier: "tblSideMenuCell")
//
//
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("sideMenuView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //register table view cells
        self.tblSideMenu.delegate = self
        self.tblSideMenu.dataSource = self
        self.tblSideMenu.register(UINib(nibName: "tblSideMenuCell", bundle: nil), forCellReuseIdentifier: "tblSideMenuCell")
        
        fetchAppLogo()
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
                return 2
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
//                if indexPath.row == 3
//                {
//                    cell.titleMenuItem.text = "Favorite Listings"
//                    cell.imgManuItem.image = UIImage.init(named: "saved_favorites")
//                }
//                else if indexPath.row == 4
//                {
//                    cell.titleMenuItem.text = "Contacted Listings"
//                    cell.imgManuItem.image = UIImage.init(named: "contacted_listings")
//                }
//                else if indexPath.row == 5
//                {
//                    cell.titleMenuItem.text = "Recently Viewed Listings"
//                    cell.imgManuItem.image = UIImage.init(named: "recently_viewed_searches")
//                }
//                else if indexPath.row == 6
//                {
//                    cell.titleMenuItem.text = "Recent Searches"
//                    cell.imgManuItem.image = UIImage.init(named: "recently_viewed_searches")
//                }
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
        if tableView == self.tblSideMenu
        {
            tableView.deselectRow(at: indexPath, animated: false)
            if indexPath.section == 0
            {
                if indexPath.row == 0
                {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "propertyListviewController") as! propertyListviewController
//                    if self.viewController != nil
//                    {
//                        vc.lat = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.latitude)!)
//                        vc.long = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.longitude)!)
//                        vc.sr = "Sale"
//                        self.viewController?.navigationController?.pushViewController(vc, animated: true)
//                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let propertyListNavigationController = storyboard.instantiateViewController(withIdentifier: "propertyListNavigationController") as! propertyListNavigationController
                    (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.sr = "Sale"
                    
                    
                    if self.viewController != nil
                    {
                        (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.lat = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.latitude)!)
                        (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.long = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.longitude)!)
                        self.viewController?.present(propertyListNavigationController, animated: true, completion: nil)
                    }
                }
                else if indexPath.row == 1
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let propertyListNavigationController = storyboard.instantiateViewController(withIdentifier: "propertyListNavigationController") as! propertyListNavigationController
                    (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.sr = "Lease"
                    
                    
                    if self.viewController != nil
                    {
                        (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.lat = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.latitude)!)
                        (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.long = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.longitude)!)
                        self.viewController?.present(propertyListNavigationController, animated: true, completion: nil)
                    }
                    
                }
                else if indexPath.row == 2
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let propertyListNavigationController = storyboard.instantiateViewController(withIdentifier: "propertyListNavigationController") as! propertyListNavigationController
                    (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.sr = "Recently Sold"
                    
                    
                    if self.viewController != nil
                    {
                        (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.lat = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.latitude)!)
                        (propertyListNavigationController.viewControllers[0] as? propertyListviewController)?.long = NSString(format: "%f", ((self.viewController as? AROntheGOViewController)?.currentLocation.coordinate.longitude)!)
                        self.viewController?.present(propertyListNavigationController, animated: true, completion: nil)
                    }
                    
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
                   
                }
                else if indexPath.row == 1
                {
                    if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
                    {
                        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
                        {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let savedListNavigationController = storyboard.instantiateViewController(withIdentifier: "savedSearchesNavigationController") as! savedSearchesNavigationController
                            
                            if self.viewController != nil
                            {
                                self.viewController?.present(savedListNavigationController, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Info", message: "You are not logged in. Please login if you already have an account or register to get a new account.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.viewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Info", message: "You are not logged in. Please login if you already have an account or register to get a new account.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.viewController?.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                else if indexPath.row == 2
                {
                    
                }
                if indexPath.row == 3
                {
                    
                }
                else if indexPath.row == 4
                {
                    
                }
                else if indexPath.row == 5
                {
                    
                }
                else if indexPath.row == 6
                {
                    
                }
                else
                {
                    //do nothing
                }
                
            }
            else if indexPath.section == 2
            {
                if indexPath.row == 0
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let settingsNavigationController = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController") as! SettingsNavigationController
                    if self.viewController != nil
                    {
                        self.viewController?.present(settingsNavigationController, animated: true, completion: nil)
                    }
                    
                }
                else if indexPath.row == 1
                {
                    
                }
                else if indexPath.row == 2
                {
                    
                }
                else if indexPath.row == 3
                {
                    
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
    }
    
    // MARK: - show sign up navigation controller
    @IBAction func showSignInUpPage(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavigationController = storyboard.instantiateViewController(withIdentifier: "loginNavigationController") as! loginNavigationController
        if self.viewController != nil
        {
            self.viewController?.present(loginNavigationController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - fetch app logo
    func fetchAppLogo()
    {
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseMediaURL
                let varURL = "logo/1024x1024.png"
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
                                self.viewController?.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error!!", message: String(format: "Internal Server Error:%i", httpStatus.statusCode), preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.viewController?.present(alert, animated: true, completion: nil)
                        }
                        
                        
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {// check for http errors
//                        print("response = \(String(describing: response))")
                        print("data = \(String(describing: data))")
                        //let responseString = String(data: data, encoding: .utf8)
                        //print("responseString = \(String(describing: responseString))")
                        
//                        guard let unwrappedResponse = responseString
//                            else{
//                                return
//                        }
                        //print(unwrappedResponse)
                        DispatchQueue.main.async {
                            
                            self.imgAppLogo.image = UIImage(data: data)
                        }
                        
//                        do {
//                            let dataArray : NSMutableArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableArray
//                            if(dataArray.count != 0)
//                            {
//                                let dataDict : NSDictionary = dataArray[0] as! NSDictionary
//                                let responseText = dataDict.object(forKey: "text") as! NSString
//                                //                                let terms = try NSAttributedString(data: responseText.data(using : String.Encoding.utf8.rawValue)!,
//                                //                                    options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//                                //                                print(terms)
//                                print(responseText)
//                                DispatchQueue.main.async {
//
//                                }
//                            }
//                            else
//                            {
//                                return
//                            }
//                            print(dataArray)
//
//
//                        } catch {
//                            DispatchQueue.main.async {
//
//                            }
//                            return
//                        }
                        
                        
                        
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
            self.viewController?.present(alert, animated: true, completion: nil)
            return
        }
    }
}

extension UIView {
    
    var viewController: UIViewController? {
        
        var responder: UIResponder? = self
        
        while responder != nil {
            
            if let responder = responder as? UIViewController {
                return responder
            }
            responder = responder?.next
        }
        return nil
    }
}
