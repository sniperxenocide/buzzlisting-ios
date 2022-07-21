//
//  tblSettingsCell.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/8/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class tblSettingsCell: UITableViewCell {

    @IBOutlet var btnSignInUp: UIButton!
    @IBOutlet var btnUnregister: UIButton!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    // MARK: -  initialization methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setBtnState()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: -  button states
    func setBtnState()
    {
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil //have logged in atleast once
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") ==  true //logged in
            {
                //sign up
                btnSignInUp.isUserInteractionEnabled = false
                btnSignInUp.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                //logout
                btnLogout.isUserInteractionEnabled = true
                btnLogout.setTitleColor(UIColor.blue, for: UIControlState.normal)
                //unregister
                if UserDefaults.standard.object(forKey: "loginType") != nil //have logged in atleast once
                {
                    if UserDefaults.standard.integer(forKey: "loginType") == 1 //facebook
                    {
                        if UserDefaults.standard.object(forKey: "registered") != nil
                        {
                            if UserDefaults.standard.integer(forKey: "registered") == 1 //registered
                            {
                                btnUnregister.isUserInteractionEnabled = true
                                btnUnregister.setTitleColor(UIColor.red, for: UIControlState.normal)
                            }
                            else//unregistered
                            {
                                btnUnregister.isUserInteractionEnabled = false
                                btnUnregister.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                            }
                            
                        }
                    }
                    
                    else //logged in from email
                    {
                        btnUnregister.isUserInteractionEnabled = true
                        btnUnregister.setTitleColor(UIColor.red, for: UIControlState.normal)
                    }
                    
                }
                else //never logged in
                {
                    btnUnregister.isUserInteractionEnabled = false
                    btnUnregister.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                }
                
            }
            else //not logged in
            {
                //sign up
                btnSignInUp.isUserInteractionEnabled = true
                btnSignInUp.setTitleColor(UIColor.blue, for: UIControlState.normal)
                //logout
                btnLogout.isUserInteractionEnabled = false
                btnLogout.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                //unregister
                btnUnregister.isUserInteractionEnabled = false
                btnUnregister.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            }
        }
        else //never logged in
        {
            //sign up
            btnSignInUp.isUserInteractionEnabled = true
            btnSignInUp.setTitleColor(UIColor.blue, for: UIControlState.normal)
            //logout
            btnLogout.isUserInteractionEnabled = false
            btnLogout.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            //unregister
            btnUnregister.isUserInteractionEnabled = false
            btnUnregister.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        }
    }
    
    // MARK: - unregister from current account
    @IBAction func unregister(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirm Your Action", message: "Are You Sure that You Want to Unregister?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in
            NetworkManager.isReachable { networkManagerInstance in
                DispatchQueue.global(qos: .background).async {
                    let baseURL = "http://10.10.11.171:8000"
                    let varURL = "/api/v1/unregister/?"
                    var parameters : String
                    if UserDefaults.standard.object(forKey: "loginType") != nil
                    {
                        if UserDefaults.standard.integer(forKey: "loginType") == 1 //facebook login
                        {
                            if FBSDKAccessToken.current().tokenString != nil
                            {
                                parameters = String(format: "source=%i&token=%@", 1, FBSDKAccessToken.current().tokenString)
                            }
                            else
                            {
                                return
                            }
                            
                        }
                        else
                        {
                            if UserDefaults.standard.object(forKey: "access_token") != nil
                            {
                                parameters = String(format: "source=%i&token=%@", 2, UserDefaults.standard.string(forKey: "access_token")!)
                            }
                            else
                            {
                                return
                            }
                            
                        }
                    }
                    else
                    {
                        return
                    }
                    
                    let strURL = String(format: "%@%@%@", baseURL, varURL, parameters)
                    guard let url = URL(string: strURL) else {
                        print("Error: invalid login url")
                        return
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {// check for fundamental networking error
                            //print("error=\(String(describing: error))")
                            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                                //print(error.code)
                                self.showAlert(error.localizedDescription, "Error!!")
                            }
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(String(describing: response))")
                            self.showAlert(String(format:"Internal Server Error:%i", httpStatus.statusCode), "Error!!")
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {// check for http errors
                            print("response = \(String(describing: response))")
                            print("data = \(String(describing: data))")
                            let responseString = String(data: data, encoding: .utf8)
                            print("responseString = \(String(describing: responseString))")
                            //"\"user unregistered\""
                            //"\"unregistered fb user\""
                            guard let unwrappedResponse = responseString
                                else{
                                    return
                            }
                            print(unwrappedResponse)
                            if(unwrappedResponse.caseInsensitiveCompare("\"user unregistered\"") == ComparisonResult.orderedSame){
                                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                DispatchQueue.main.async {
                                    //update UI
                                    //sign up
                                    self.btnSignInUp.isUserInteractionEnabled = true
                                    self.btnSignInUp.setTitleColor(UIColor.blue, for: UIControlState.normal)
                                    //logout
                                    self.btnLogout.isUserInteractionEnabled = false
                                    self.btnLogout.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                                    //unregister
                                    self.btnUnregister.isUserInteractionEnabled = false
                                    self.btnUnregister.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                                    self.showAlert("User Successfully Unregistered.", "Info")
                                    
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    //update UI
                                    self.showAlert("Request Invalid.", "Error!!")
                                }
                                
                            }
                            return
                        }
                        
                    }
                    task.resume()
                }
            }
            NetworkManager.isUnreachable { networkManagerInstance in
                self.showAlert("Please Connect to Intenet.", "Error!!")
                return
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: -  auxiliary method - show alert
    func showAlert(_ message:String, _ title:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.viewController?.present(alert, animated: true, completion: nil)
    }
}
