//
//  existingUserLogin.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/1/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit

class existingUserLogin : UIViewController, UITextFieldDelegate
{
    // MARK: - Outlets and Variables
    @IBOutlet var componentsContainerView: UIView!
    @IBOutlet var txtUsernameEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var chkBoxRememberMe: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnForgetPsswrd: UIButton!
    @IBOutlet var lblWarningUsername: UILabel!
    @IBOutlet var lblWarningPassword: UILabel!
    //check buttons
    var rememberMe: Bool!
    // MARK: - Initialization Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //design code
        componentsContainerView.layer.cornerRadius = 10
        componentsContainerView.layer.shadowColor = UIColor.black.cgColor
        componentsContainerView.layer.shadowOpacity = 1
        componentsContainerView.layer.shadowOffset = CGSize(width: 5, height:0)
        
        chkBoxRememberMe.layer.cornerRadius = 3
        chkBoxRememberMe.layer.borderWidth = 1
        chkBoxRememberMe.layer.borderColor = UIColor.lightGray.cgColor
        
        btnSubmit.layer.cornerRadius = 5
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
        clearErrors()
        
        
    }
    // MARK: - Vanish Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    //MARK: - check box action
    @IBAction func checkRememberMe(_ sender: UIButton) {
        if rememberMe == false
        {
            rememberMe = true
            self.chkBoxRememberMe.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
        }
        else
        {
            rememberMe = false
            self.chkBoxRememberMe.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
    }
    // MARK: - Login validation
    func isUserNameValid(_ username: String) -> Bool{
        let usernameRegEx = "[a-zA-Z0-9_]+\\.[a-zA-Z0-9_]+"
        let usernameTest  = NSPredicate(format:"SELF MATCHES[c] %@", usernameRegEx)
        return usernameTest.evaluate(with: username)
    }
    
    func isPasswordValid(_ password: String) -> Bool
    {
        if password.count >= 6 && password.count <= 10
        {
            return true
        }
        return false
        
    }
    
    func validateInput() -> Bool
    {
        var isInputValid = true
        //username validation
        if self.txtUsernameEmail.text?.count == 0
        {
            self.lblWarningUsername.isHidden = false
            self.lblWarningUsername.text = "User Name is Mandatory"
            self.txtUsernameEmail.layer.borderWidth = 0.3
            self.txtUsernameEmail.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            if !isUserNameValid(self.txtUsernameEmail.text!)
            {
                self.lblWarningUsername.isHidden = false
                self.lblWarningUsername.text = "User Name is not Valid"
                self.txtUsernameEmail.layer.borderWidth = 0.3
                self.txtUsernameEmail.layer.borderColor = UIColor.red.cgColor
                isInputValid = false
            }
            else
            {
                self.lblWarningUsername.isHidden = true
                self.txtUsernameEmail.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        //password validation
        if self.txtPassword.text?.count == 0
        {
            self.lblWarningPassword.isHidden = false
            self.lblWarningPassword.text = "Password is Mandatory"
            self.txtPassword.layer.borderWidth = 0.3
            self.txtPassword.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            if !isPasswordValid(self.txtPassword.text!)
            {
                self.lblWarningPassword.isHidden = false
                self.lblWarningPassword.text = "Password is not Valid"
                self.txtPassword.layer.borderWidth = 0.3
                self.txtPassword.layer.borderColor = UIColor.red.cgColor
                
                isInputValid = false
                
            }
            else
            {
                self.lblWarningPassword.isHidden = true
                self.txtPassword.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        return isInputValid
    }
    
    // MARK: - login request submit
    @IBAction func loginExistingUser(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let username = self.txtUsernameEmail.text
        let password = self.txtPassword.text
        
        if validateInput() ==  true
        {
            NetworkManager.isReachable { networkManagerInstance in
                DispatchQueue.global(qos: .background).async {
                    let baseURL = GlobalConstants.baseURL
                    let varURL = "/oauth2_provider/token/"
                    let strURL = String(format: "%@%@", baseURL, varURL)
                    let url = URL(string: strURL)!
                    var request = URLRequest(url: url)
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    let postString = String(format: "grant_type=password&client_id=rRfdf2vcQWOZn3giZVomGmk1hsXOSgWHIWufnIxw&client_secret=62YKlcrMTjrkKpKqtG1hzdP7cxOstW6nKUBq2rj7Ob2S3eUsmDsdR4h0WKCGv6K0M7NhQLhlfWYhkWJ0G5C3fPDlVT60YI64ClRXgBIep0895FtQ9ey11fM9u0s9l374&username=%@&password=%@", username!, password!)
                    request.httpBody = postString.data(using: .utf8)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {     // check for fundamental networking error
                            //print("error=\(String(describing: error))")
                            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                                //print(error.code)
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Error!!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                            DispatchQueue.main.async {
                                sender.isUserInteractionEnabled = true
                            }
                            
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error!!", message: String(format: "Internal Server Error:%i(%@)", httpStatus.statusCode, HTTPURLResponse.localizedString(forStatusCode : httpStatus.statusCode)), preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                sender.isUserInteractionEnabled = true
                            }
                            
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200
                        {
                            let responseString = String(data: data, encoding: .utf8)
                            //print("responseString = \(String(describing: responseString))")
                            
                            guard let unwrappedResponse = responseString
                                else{
                                    DispatchQueue.main.async {
                                        sender.isUserInteractionEnabled = true
                                    }
                                    
                                    return
                            }
                            print(unwrappedResponse)
                            if(unwrappedResponse.caseInsensitiveCompare("\"no active user found with this username\"") == ComparisonResult.orderedSame){
                                
                                DispatchQueue.main.async {
                                    //update UI
                                    let alert = UIAlertController(title: "Error!!", message: "Username or Password is Wrong", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                            else if unwrappedResponse.caseInsensitiveCompare("no active user found with this username") == ComparisonResult.orderedSame
                            {
                                //update UI
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Error!!", message: "You had unregistered from the app using this Facebook account Previously. Kindly contact with the system admin to re-register.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                            else
                            {
                                
                                if let data = responseString?.data(using: .utf8) {
                                    do {
                                        let responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                        
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn") //Bool
                                        UserDefaults.standard.set(2, forKey: "loginType")  //Integer
                                        UserDefaults.standard.set(responseDictionary!["access_token"] as! String, forKey: "access_token")
                                        UserDefaults.standard.set(responseDictionary!["expires_in"], forKey: "expires_in")
                                        UserDefaults.standard.set(responseDictionary!["token_type"] as! String, forKey: "token_type")
                                        UserDefaults.standard.set(responseDictionary!["scope"] as! String, forKey: "scope")
                                        UserDefaults.standard.set(responseDictionary!["refresh_token"] as! String, forKey: "refresh_token")
                                        UserDefaults.standard.set(username, forKey: "username")
                                        
                                        DispatchQueue.main.async {
                                            //update UI
                                            self.clearData()
                                            let alert = UIAlertController(title: "Info", message: String(format:"You have Successfully Logged in as %@",UserDefaults.standard.string(forKey: "username")!), preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                       
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                
                            }
                        }
                    }
                    task.resume()
                }
                DispatchQueue.main.async {
                    sender.isUserInteractionEnabled = true
                }
                
                return
            }
            NetworkManager.isUnreachable { networkManagerInstance in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error!!", message: "Please Connect to Internet.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    sender.isUserInteractionEnabled = true
                }
                
                return
            }
        }
    }
    
    // MARK: - clear errors
    func clearErrors()
    {
        if self.txtUsernameEmail.layer.borderColor == UIColor.red.cgColor
        {
            self.txtUsernameEmail.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.txtPassword.layer.borderColor == UIColor.red.cgColor
        {
            self.txtPassword.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        
        if self.lblWarningUsername.isHidden == false
        {
            self.lblWarningUsername.isHidden = true
        }
        if self.lblWarningPassword.isHidden == false
        {
            self.lblWarningPassword.isHidden = true
        }
        
    }
    // MARK: -  clear data
    func clearData(){
        self.txtUsernameEmail.text = ""
        self.txtPassword.text = ""
        
        //check boxes
        rememberMe = false
        self.chkBoxRememberMe.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        
    }
}
