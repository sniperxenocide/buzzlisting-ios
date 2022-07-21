//
//  savedSearchesViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 4/24/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class savedSearchesViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Outlets and Variables
    
    @IBOutlet var tblPropertyList: UITableView!
    
    // container to contain saved searches
    var savedSearchesFromRealm: Results<favPropertiesTable> = try! Realm().objects(favPropertiesTable.self).filter(String(format:"username = '%@'", UserDefaults.standard.string(forKey: "username")!))
    
    // MARK: - initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        //register table view cells
        self.tblPropertyList.register(UINib(nibName: "tblPropertyListCell", bundle: nil), forCellReuseIdentifier: "tblPropertyListCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.savedSearchesFromRealm = try! Realm().objects(favPropertiesTable.self).filter(String(format:"username = '%@'", UserDefaults.standard.string(forKey: "username")!))
        self.tblPropertyList.reloadData()
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
            return self.savedSearchesFromRealm.count
        }
        else
        {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblPropertyListCell", for: indexPath) as! tblPropertyListCell
        cell.contentView.backgroundColor = UIColor.clear
        let aSavedSearchTable = self.savedSearchesFromRealm[indexPath.section]
        
        cell.propertyAddress.text = aSavedSearchTable.address
        cell.propertyType.text = aSavedSearchTable.property_type
        cell.propertyPrice.text = aSavedSearchTable.price
        cell.propertyDetails.text = aSavedSearchTable.municipality_area
        
        //hide favorites button
        cell.btnFavorites.isHidden = true
        
        //image load
        let typeInt = Int(aSavedSearchTable.typeInt)
        let mls = aSavedSearchTable.mls
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async
                {
                    let baseURL = GlobalConstants.baseMediaURL
                    
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
            //create here a dictionary for details page
            let propertyDetails : NSMutableDictionary = NSMutableDictionary()
            propertyDetails.setValue(Int(self.savedSearchesFromRealm[indexPath.section].property_id), forKey: "id")
            propertyDetails.setValue(Int(self.savedSearchesFromRealm[indexPath.section].typeInt), forKey: "type")
            propertyDetails.setValue(self.savedSearchesFromRealm[indexPath.section].mls, forKey: "mls#")
            propertyDetails.setValue(self.savedSearchesFromRealm[indexPath.section].address, forKey: "address")
            vc.propertyDetails = propertyDetails
            //
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Go Back From Current View
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}
