//
//  loginViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 2/28/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit


class loginViewController : UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate
{
    
    
    // MARK: - Outlets and Variables
    @IBOutlet var btnFBLogin: FBSDKLoginButton!
    @IBOutlet var loginSignUpContainerView: UIView!
    @IBOutlet var btnEmailLogin: UIButton!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var lblLoggedInUser: UILabel!
    // MARK: - Initialization Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fb login button setup
        btnFBLogin.delegate = self
        btnFBLogin.readPermissions = ["public_profile", "email"];
        
        //design
        loginSignUpContainerView.layer.cornerRadius = 10
        loginSignUpContainerView.layer.shadowColor = UIColor.black.cgColor
        loginSignUpContainerView.layer.shadowOpacity = 1
        loginSignUpContainerView.layer.shadowOffset = CGSize(width: 5, height:0)
        
        lblLoggedInUser.layer.shadowColor = UIColor.black.cgColor
        lblLoggedInUser.layer.shadowOpacity = 1
        lblLoggedInUser.layer.shadowOffset = CGSize(width: 5, height:0)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
            {
                if UserDefaults.standard.integer(forKey: "loginType") == 1 //facebook login
                {
                    btnEmailLogin.isUserInteractionEnabled = false
                    btnEmailLogin.setTitleColor(UIColor.darkGray, for: .normal)
                    btnLogin.isUserInteractionEnabled = false
                    btnLogin.setTitle("Already have an account? Log In", for: UIControlState.normal)
                    btnLogin.setTitleColor(UIColor.darkGray, for: .normal)
                    
                    if (UserDefaults.standard.string(forKey: "username")) != nil
                    {
                        lblLoggedInUser.isHidden = false
                        lblLoggedInUser.text = "You are logged in as " + UserDefaults.standard.string(forKey: "username")!
                    }
                    
                    
                    
                }
                else
                {
                    btnFBLogin.isUserInteractionEnabled = false
                    btnEmailLogin.isUserInteractionEnabled = false
                    btnEmailLogin.setTitleColor(UIColor.darkGray, for: .normal)
                    
                    btnLogin.isUserInteractionEnabled = true
                    btnLogin.setTitle("Log Out", for: UIControlState.normal)
                    btnLogin.setTitleColor(UIColor.red, for: .normal)
                    
                    lblLoggedInUser.isHidden = false
                    lblLoggedInUser.text = "You are logged in as " + UserDefaults.standard.string(forKey: "username")!
                    
                }
            }
            else
            {
                btnEmailLogin.isUserInteractionEnabled = true
                btnEmailLogin.setTitleColor(UIColor.red, for: .normal)
                
                btnLogin.isUserInteractionEnabled = true
                btnLogin.setTitle("Already have an account? Log In", for: UIControlState.normal)
                btnLogin.setTitleColor(UIColor.red, for: .normal)
                
                btnFBLogin.isUserInteractionEnabled = true
                lblLoggedInUser.isHidden = true
                
            }
        }
        else
        {
            //do nothing
            btnEmailLogin.isUserInteractionEnabled = true
            btnEmailLogin.setTitleColor(UIColor.red, for: .normal)
            
            btnLogin.isUserInteractionEnabled = true
            btnLogin.setTitleColor(UIColor.red, for: .normal)
            btnLogin.setTitle("Already have an account? Log In", for: UIControlState.normal)
            
            btnFBLogin.isUserInteractionEnabled = true
            
            lblLoggedInUser.isHidden = true
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
    
    // MARK: - login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if FBSDKAccessToken.current() != nil
        {
            //save user state
            UserDefaults.standard.set(true, forKey: "isLoggedIn") //Bool
            UserDefaults.standard.set(1, forKey: "loginType")  //Integer
            //change view
            btnEmailLogin.isUserInteractionEnabled = false
            btnEmailLogin.setTitleColor(UIColor.darkGray, for: .normal)
            
            btnLogin.isUserInteractionEnabled = false
            btnLogin.setTitle("Already have an account? Log In", for: UIControlState.normal)
            btnLogin.setTitleColor(UIColor.darkGray, for: .normal)
            
            
            //print("accessToken: " + String(describing: FBSDKAccessToken.current().tokenString))
            
            NetworkManager.isReachable { networkManagerInstance in
                DispatchQueue.global(qos: .background).async {
                    //get fb credentials
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, name"])
                    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                        
                        if ((error) != nil)
                        {
                            print("Error took place: \(String(describing: error))")
                        }
                        else
                        {
                            print("Print entire fetched result: \(String(describing: result))")
                            if let data = result as? [String:Any] {
                                print(data["name"] as! String)
                                
                                
                                UserDefaults.standard.set(data["name"] as! String, forKey: "username") //setObject
                                UserDefaults.standard.set(data["email"] as! String, forKey: "email")
                                
                                print(UserDefaults.standard.string(forKey: "username")!)
                                print(UserDefaults.standard.string(forKey: "email")!)
                                print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
                                print(UserDefaults.standard.integer(forKey: "loginType"))
                            }
                            
                            DispatchQueue.main.async {
                                
                                
                                self.lblLoggedInUser.isHidden = false
                                self.lblLoggedInUser.text = "You are logged in as " + UserDefaults.standard.string(forKey: "username")!
                                
                            }
                            
                        }
                    })
                    //send response to backend
                    let baseURL = GlobalConstants.baseURL
                    let varURL = "/api/v1/appUser/"
                    let accessToken = FBSDKAccessToken.current().tokenString
                    print(accessToken ?? "")
                    let strURL = String(format: "%@%@?token=%@", baseURL, varURL, accessToken!)
                    guard let url = URL(string: strURL) else {
                        print("Error: invalid login url")
                        return
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {// check for fundamental networking error
                            print("error=\(String(describing: error))")
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(String(describing: response))")
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {// check for http errors
                            print("response = \(String(describing: response))")
                            print("data = \(String(describing: data))")
                            let responseString = String(data: data, encoding: .utf8)
                            print("responseString = \(String(describing: responseString))")
                            
                            guard let unwrappedResponse = responseString
                            else{
                                return
                            }
                            print(unwrappedResponse)
                            if(unwrappedResponse.caseInsensitiveCompare("\"facebook Ok\"") == ComparisonResult.orderedSame){
                               UserDefaults.standard.set(accessToken, forKey: "access_token")
                               UserDefaults.standard.set(1, forKey: "registered")
                            }
                            else if(unwrappedResponse.caseInsensitiveCompare("\"unregistered fb user\"") == ComparisonResult.orderedSame)
                            {
                                UserDefaults.standard.set(0, forKey: "registered")
                                let alert = UIAlertController(title: "Error!!", message: "You had unregistered from the app using this Facebook account Previously. Kindly contact with the system admin to re-register.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                //do nothing
                            }
                            
                            return
                        }
                        
                    }
                    task.resume()
                    
                }
                return
            }
            NetworkManager.isUnreachable { networkManagerInstance in
                print("Network is Unavailable")
                return
            }
            
        }
        

    }
    // MARK: - logout fb user
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        logout()
    }
    
    // MARK: -  logout or login email user
    
    @IBAction func logInOrLogOut(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
        {
            logout()
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "existingUserLogin") as! existingUserLogin
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    // MARK: - logout related common functions
    func logout()
    {
        //set logged in to false
        
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        //update UI
        self.btnEmailLogin.isUserInteractionEnabled = true
        self.btnEmailLogin.setTitleColor(UIColor.red, for: .normal)
        
        self.btnLogin.isUserInteractionEnabled = true
        self.btnLogin.setTitleColor(UIColor.red, for: .normal)
        self.btnLogin.setTitle("Already have an account? Log In", for: UIControlState.normal)
        
        self.btnFBLogin.isUserInteractionEnabled = true
        self.lblLoggedInUser.isHidden = true
        //api call
        var parameters : String
        
        if UserDefaults.standard.object(forKey: "loginType") != nil
        {
            if UserDefaults.standard.integer(forKey: "loginType") == 1 //facebook login
            {
                
                if UserDefaults.standard.string(forKey: "access_token") != nil
                {
                    parameters = String(format: "source=%i&token=%@", 1, UserDefaults.standard.string(forKey: "access_token")!)
                    self.sendLogoutRequest(parameters)
                    
                }
                else
                {
                    return
                }
                
            }
            else //email login
            {
                if UserDefaults.standard.object(forKey: "access_token") != nil
                {
                    parameters = String(format: "source=%i&token=%@", 2, UserDefaults.standard.string(forKey: "access_token")!)
                    let alert = UIAlertController(title: "Confirm Your Action", message: "Are You Sure that You Want to Log Out from this Account?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in
                        self.sendLogoutRequest(parameters)
                        NetworkManager.isUnreachable { networkManagerInstance in
                            self.showAlert("Please Connect to Intenet.", "Error!!")
                            return
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
        
    }
    
    func sendLogoutRequest(_ parameters:String)
    {
        NetworkManager.isReachable { networkManagerInstance in
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseURL
                let varURL = "/api/v1/logout/?"
                let strURL = String(format: "%@%@%@", baseURL, varURL, parameters)
                guard let url = URL(string: strURL) else {
                    print("Error: invalid login url")
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {// check for fundamental networking error
                        if let error = error as NSError?, error.domain == NSURLErrorDomain {
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
                        guard let unwrappedResponse = responseString
                            else{
                                return
                        }
                        print(unwrappedResponse)
                        if(unwrappedResponse.caseInsensitiveCompare("\"logout from email\"") == ComparisonResult.orderedSame)
                        {
                            self.showAlert("User Successfully Logged Out  from this Account", "Info")
                        }
                        else if(unwrappedResponse.caseInsensitiveCompare("\"logout from fb\"") == ComparisonResult.orderedSame)
                        {
                            self.showAlert("User Successfully Logged Out  from this Account", "Info")
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.showAlert("Request Invalid.", "Error!!")
                            }
                            
                        }
                        return
                    }
                    
                }
                task.resume()
            }
        }
    }
    // MARK: -  auxiliary method - show alert
    func showAlert(_ message:String, _ title:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
