//
//  ContactViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/6/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
class ContactViewController : UIViewController, UIScrollViewDelegate
{
    // MARK: - components
    
    @IBOutlet var txtFieldUserName: UITextField!
    @IBOutlet var txtFieldEmail: UITextField!
    @IBOutlet var txtFieldPhone: UITextField!
    @IBOutlet var lblPropertyName: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var btnEmail: UIButton!
    @IBOutlet var btnPrivacyPolicy: UIButton!
    @IBOutlet var imgScrollView: UIScrollView!
    
    var propertyImagesArray : [UIImage] = []
    var propertyName : String = ""
    var propertyId: String = ""
    var propertyType: String = ""
    
    // MARK: - initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        //design
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 5, height:0)
        contentView.layer.cornerRadius = 10
        
        //btnEmail.layer.cornerRadius = 3
        btnEmail.layer.cornerRadius = 3
        
        //print(self.propertyImagesArray)
        //print(self.propertyName)
        print(propertyId)
        print(propertyType)
        self.lblPropertyName.text = self.propertyName
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtFieldUserName.layer.borderWidth = 0.3
        self.txtFieldUserName.layer.borderColor = UIColor.gray.cgColor
        self.txtFieldUserName.text = ""
        
        self.txtFieldEmail.layer.borderWidth = 0.3
        self.txtFieldEmail.layer.borderColor = UIColor.gray.cgColor
        self.txtFieldEmail.text = ""
        
        //load images
        self.imgScrollView.contentSize.width = 200 * CGFloat(self.propertyImagesArray.count) + CGFloat(5*(self.propertyImagesArray.count+1))
        for i in 0..<self.propertyImagesArray.count
        {
            let imageView = UIImageView()
            let x = 200 * CGFloat(i) + CGFloat(5*(i + 1))
            imageView.frame = CGRect(x: x, y: 5, width: 200, height: self.imgScrollView.frame.height-10)
            //imageView.contentMode = .scaleToFill
            imageView.image = self.propertyImagesArray[i]
            self.imgScrollView.addSubview(imageView)
        }
        
        
    }
    // MARK: - Send Email
//    Unresolved contact request entry:(api for property contact request): (GET Method)
//
//    endPoint:
//
//    /api/v1/unresolvedEntry/?type=1&id=127&username=adnan.0944 (contact request while logged in)
//    /api/v1/unresolvedEntry/?type=1&id=127&username=shuvo&anonymous=Y&email=shuvo@infosapex.com
//
//    type =1 (Residential)
//    type =2 (Condo)
//    type =3 (Commercial)
//
//    id = property_id(residential_id or commercial_id or condo_id)
//    username = AppUsername
//
//
//    Response:  'contact request added'
//    'no such user' (if no active user found using 1st endpoint)
//
//    'invalid request' (if parameters are not correctly set)
    @IBAction func sendEmail(_ sender: UIButton) {
        let baseURL = GlobalConstants.baseURL
        let varURL = String(format:"/api/v1/unresolvedEntry/?type=%@&id=%@&username=", self.propertyType, self.propertyId)
        var parameters = ""
        var strURL = ""
        if UserDefaults.standard.object(forKey: "isLoggedIn") != nil
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
            {
                if UserDefaults.standard.string(forKey: "username") != nil
                {
                    parameters = UserDefaults.standard.string(forKey: "username")!
                    strURL = String(format:"%@%@%@", baseURL, varURL, parameters)
                    self.sendContactRequest(strURL)
                }
                else
                {
                    return
                }
            }
            else
            {
                //empty field detection
                
                if(self.txtFieldUserName.text == "")
                {
                    self.txtFieldUserName.layer.borderWidth = 0.3
                    self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                    
                    let alert = UIAlertController(title: "Error!!", message: "Username is Mandatory", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else
                {
                    self.txtFieldUserName.layer.borderWidth = 0.3
                    self.txtFieldUserName.layer.borderColor = UIColor.gray.cgColor
                }
                if(self.txtFieldEmail.text == "")
                {
                    self.txtFieldEmail.layer.borderWidth = 0.3
                    self.txtFieldEmail.layer.borderColor = UIColor.red.cgColor
                    
                    let alert = UIAlertController(title: "Error!!", message: "Email is Mandatory", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else
                {
                    self.txtFieldEmail.layer.borderWidth = 0.3
                    self.txtFieldEmail.layer.borderColor = UIColor.gray.cgColor
                }
                if(self.txtFieldPhone.text == "")
                {
                    
                    //do nothing for now
                }
                else
                {
                    
                }
                
                
                if validateName(self.txtFieldUserName.text!) == true && validateEmail(self.txtFieldEmail.text!) == true && validatePhone(self.txtFieldPhone.text!) == true
                {
                    parameters = String(format:"%@&anonymous=Y&email=%@", self.txtFieldUserName.text!, self.txtFieldEmail.text!)
                    strURL = String(format:"%@%@%@", baseURL, varURL, parameters)
                    self.sendContactRequest(strURL)
                }
                else
                {
                    if validateName(self.txtFieldUserName.text!) == false
                    {
                        let alert = UIAlertController(title: "Error!!", message: "Username is not Valid", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.txtFieldUserName.layer.borderWidth = 0.3
                        self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                        
                        return
                    }
                    else
                    {
                        self.txtFieldUserName.layer.borderWidth = 0.3
                        self.txtFieldUserName.layer.borderColor = UIColor.gray.cgColor
                    }
                    if validateEmail(self.txtFieldEmail.text!) == false
                    {
                        let alert = UIAlertController(title: "Error!!", message: "Email is not Valid", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.txtFieldEmail.layer.borderWidth = 0.3
                        self.txtFieldEmail.layer.borderColor = UIColor.red.cgColor
                        
                        return
                    }
                    else
                    {
                        self.txtFieldEmail.layer.borderWidth = 0.3
                        self.txtFieldEmail.layer.borderColor = UIColor.gray.cgColor
                    }
                    if validatePhone(self.txtFieldPhone.text!) == false
                    {
                        self.txtFieldPhone.layer.borderWidth = 0.3
                        self.txtFieldPhone.layer.borderColor = UIColor.red.cgColor
                        
                        return
                    }
                    else
                    {
                        self.txtFieldPhone.layer.borderWidth = 0.3
                        self.txtFieldPhone.layer.borderColor = UIColor.gray.cgColor
                    }
                    
                }
            }
        }
        else
        {
            //empty field detection
            
            if(self.txtFieldUserName.text == "")
            {
                self.txtFieldUserName.layer.borderWidth = 0.3
                self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                
                
                let alert = UIAlertController(title: "Error!!", message: "Username is Mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else
            {
                self.txtFieldUserName.layer.borderWidth = 0.3
                self.txtFieldUserName.layer.borderColor = UIColor.gray.cgColor
            }
            if(self.txtFieldEmail.text == "")
            {
                self.txtFieldEmail.layer.borderWidth = 0.3
                self.txtFieldEmail.layer.borderColor = UIColor.red.cgColor
                
                let alert = UIAlertController(title: "Error!!", message: "Email is Mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else
            {
                self.txtFieldEmail.layer.borderWidth = 0.3
                self.txtFieldEmail.layer.borderColor = UIColor.gray.cgColor
            }
            if(self.txtFieldPhone.text == "")
            {
                
                //do nothing for now
            }
            else
            {
                
            }
            if validateName(self.txtFieldUserName.text!) == true && validateEmail(self.txtFieldEmail.text!) == true && validatePhone(self.txtFieldPhone.text!) == true
            {
                parameters = String(format:"%@&anonymous=Y&email=%@", self.txtFieldUserName.text!, self.txtFieldEmail.text!)
                strURL = String(format:"%@%@%@", baseURL, varURL, parameters)
                self.sendContactRequest(strURL)
            }
            else
            {
                if validateName(self.txtFieldUserName.text!) == false
                {
                    let alert = UIAlertController(title: "Error!!", message: "Username is not Valid", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.txtFieldUserName.layer.borderWidth = 0.3
                    self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                    
                    return
                }
                else
                {
                    self.txtFieldUserName.layer.borderWidth = 0.3
                    self.txtFieldUserName.layer.borderColor = UIColor.gray.cgColor
                }
                if validateEmail(self.txtFieldEmail.text!) == false
                {
                    let alert = UIAlertController(title: "Error!!", message: "Email is not Valid", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.txtFieldUserName.layer.borderWidth = 0.3
                    self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                    
                    return
                }
                else
                {
                    self.txtFieldEmail.layer.borderWidth = 0.3
                    self.txtFieldEmail.layer.borderColor = UIColor.gray.cgColor
                }
                if validatePhone(self.txtFieldPhone.text!) == false
                {
                    self.txtFieldUserName.layer.borderWidth = 0.3
                    self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                    
                    return
                }
                else
                {
                    self.txtFieldPhone.layer.borderWidth = 0.3
                    self.txtFieldPhone.layer.borderColor = UIColor.gray.cgColor
                }
            }
        }
        
    }
    func validateName(_ Name: String) -> Bool
    {
        return true
    }
    func validateEmail(_ email: String) -> Bool
    {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func validatePhone(_ email: String) -> Bool
    {
        return true
    }
    // MARK: - send request
    func sendContactRequest(_ strURL: String)
    {
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async {
                
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
                        print("response = \(String(describing: response))")
                        print("data = \(String(describing: data))")
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(String(describing: responseString))")
                        
                        guard let unwrappedResponse = responseString
                            else{
                                return
                        }
                        print(unwrappedResponse)
                        
                        var title = "Error"
                        var msg = ""
                        if unwrappedResponse == "\"contact request added\""
                        {
                            title = "Info"
                            msg = "Conatct Request Sent Successfully!!"
                            DispatchQueue.main.async {
                                self.txtFieldUserName.text = ""
                                self.txtFieldEmail.text = ""
                                self.txtFieldPhone.text = ""
                            }
                            
                        }
                        else if unwrappedResponse == "\"no such user\""
                        {
                            
                            msg = "The Current User was not Found in Database!!"
                        }
                        else
                        {
                            msg = "Request Invalid!!"
                        }
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
    // MARK: - Show Privacy Policy
    @IBAction func showPrivacyPolicy(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndCndtnsViewController") as! TermsAndCndtnsViewController
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
