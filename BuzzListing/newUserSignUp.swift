//
//  newUserSignUp.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/1/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit

class newUserSignUP : UIViewController, UITextFieldDelegate
{
    // MARK: - Outlets and Variables
    @IBOutlet var componentsContainerView: UIView!
    
    @IBOutlet var chkTermsCndtns: UIButton!
    @IBOutlet var btnTermsCndtns: UIButton!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnDecline: UIButton!
    
    @IBOutlet var btnUserNameInfo: UIButton!
    @IBOutlet var txtFieldUserName: UITextField!
    @IBOutlet var lblUsernameWarning: UILabel!
    
    @IBOutlet var btnPasswordInfo: UIButton!
    @IBOutlet var txtFieldPassword: UITextField!
    @IBOutlet var lblPasswordWarning: UILabel!
    
    @IBOutlet var btnEmailInfo: UIButton!
    @IBOutlet var txtFieldEmail: UITextField!
    @IBOutlet var lblEmailWarning: UILabel!
    
    @IBOutlet var imgCaptcha: UIImageView!
    @IBOutlet var txtFieldCaptcha: UITextField!
    @IBOutlet var btnNotRobot: UIButton!
    
    //for tooltip view
    var toolTip: tooltipView?
    //check buttons
    var isAgreedTermsCndtns: Bool!
    var isNotRobot: Bool!
    //keyboard height
    var keyboardHeight: CGFloat!
    // MARK: - Initialization Methods
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //design code
        componentsContainerView.layer.cornerRadius = 10
        componentsContainerView.layer.shadowColor = UIColor.black.cgColor
        componentsContainerView.layer.shadowOpacity = 1
        componentsContainerView.layer.shadowOffset = CGSize(width: 5, height:0)
        
        chkTermsCndtns.layer.cornerRadius = 3
        chkTermsCndtns.layer.borderWidth = 1
        chkTermsCndtns.layer.borderColor = UIColor.lightGray.cgColor
        
        btnNotRobot.layer.cornerRadius = 3
        btnNotRobot.layer.borderWidth = 1
        btnNotRobot.layer.borderColor = UIColor.lightGray.cgColor
        
        btnSubmit.layer.cornerRadius = 5
        btnDecline.layer.cornerRadius = 5
        
        //move view controller with keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
        clearErrors()
        
        
    }
    // MARK: - Vanish Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        //vanish tooltip
        if self.toolTip != nil && self.toolTip?.isDescendant(of: self.componentsContainerView) == true
        {
            self.toolTip?.removeFromSuperview()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    //MARK: - keyboard height
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
    
    //MARK: - move view with Keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFieldCaptcha
        {
            animateTextField(textField, true)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField ==  self.txtFieldCaptcha
        {
            animateTextField(textField, false)
        }
    }
    
    
    func animateTextField(_ textField: UITextField, _ direction: Bool)
    {
        
        //let movementDistance = -(self.txtFieldCaptcha.frame.maxY - self.keyboardHeight)
        let movementDistance = self.componentsContainerView.frame.maxY - self.view.frame.width/2
        
        if direction == true //up
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x:0, y:CGFloat(-movementDistance), width:self.view.frame.width, height:self.view.frame.height)
            })
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
            })
        }
        
    }
    
    //MARK: - check box action
    
    @IBAction func checkRobotOrNot(_ sender: UIButton) {
        if isNotRobot == false
        {
            isNotRobot = true
            self.btnNotRobot.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
        }
        else
        {
            isNotRobot = false
            self.btnNotRobot.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
    }
    
    @IBAction func checkTrmsCndtns(_ sender: UIButton) {
        if isAgreedTermsCndtns == false
        {
            isAgreedTermsCndtns = true
            self.chkTermsCndtns.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
        }
        else
        {
            isAgreedTermsCndtns = false
            self.chkTermsCndtns.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
    }
    
    //MARK: - tooltip
    
    @IBAction func showUsernameTooltip(_ sender: UIButton) {
        let tip = "The User Name must be Unique and should have Two Parts Seperated with a Dot. Ex. : Chris.Hemsworth"
        showView(sender, tip: tip)

        
    }
    
    @IBAction func showPasswordTooltip(_ sender: UIButton) {
        let tip = "Password is Case Sensitive and should contain Minimum 6 Characters and should not Exceed a Maximum of 10 Characters. Ex. : 1a2B3c4D"
        showView(sender, tip: tip)

        
    }
    @IBAction func shoeEmailTooltip(_ sender: UIButton) {
        let tip = "Email Address must be Valid and should Contain no more than 100 characters. Ex. : something@gmail.com"
        showView(sender, tip: tip)

        
    }
    
    func showView(_ sender: UIButton, tip: String)
    {
        if self.toolTip == nil || self.toolTip?.isDescendant(of: self.componentsContainerView) != true
        {
            self.toolTip = tooltipView()
            self.toolTip?.frame.size = CGSize(width: 180, height: 106)
            self.toolTip?.frame.origin = CGPoint(x:sender.frame.minX, y:sender.frame.maxY)
            self.componentsContainerView.addSubview(self.toolTip!)
            self.toolTip?.lblTooltip.text = tip
        }
        else
        {
            self.toolTip?.removeFromSuperview()
        }
        
    }
    // MARK: - Submit request
    @IBAction func submitRequest(_ sender: UIButton) {
        let username = self.txtFieldUserName.text
        let password = self.txtFieldPassword.text
        let email = self.txtFieldEmail.text
        if validateInput() == true
        {
            //send response
            NetworkManager.isReachable { networkManagerInstance in
                DispatchQueue.global(qos: .background).async {
                    let baseURL = GlobalConstants.baseURL
                    let varURL = "/api/v1/appUser/?signup=Y&source=email"
                    let parameters = String(format: "&username=%@&password=%@&email=%@", username!, password!, email!)
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
                                let alert = UIAlertController(title: "Error!!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(String(describing: response))")
                            if httpStatus.statusCode == 500
                            {
                                let alert = UIAlertController(title: "Error!!", message: "Internal Server Error:500", preferredStyle: UIAlertControllerStyle.alert)
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
                            if(unwrappedResponse.caseInsensitiveCompare("\"user already exists with this mail\"") == ComparisonResult.orderedSame){
                                
                                DispatchQueue.main.async {
                                    //update UI
                                    let alert = UIAlertController(title: "Error!!", message: "A user already exists with this mail", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                            else if(unwrappedResponse.caseInsensitiveCompare("\"user already exists with this username\"") == ComparisonResult.orderedSame){
                                
                                DispatchQueue.main.async {
                                    //update UI
                                    let alert = UIAlertController(title: "Error!!", message: "A user already exists with this username", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                            else if(unwrappedResponse.caseInsensitiveCompare("\"confirm mail\"") == ComparisonResult.orderedSame){
                                
                                DispatchQueue.main.async {
                                    //update UI
                                    let alert = UIAlertController(title: "Info!!", message: "An email to activate your account has been sent to the email address.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.clearData()
                                    
                                }
                            }
                            else
                            {
                                
                            }
                            
                            return
                        }
                        
                    }
                    task.resume()
                }
            }
            NetworkManager.isUnreachable { networkManagerInstance in
                
                return
            }
            
        }
    }
    // MARK: - clear input
    @IBAction func declineData(_ sender: UIButton) {
        clearErrors()
        clearData()
    }
    // MARK: - validation
    func validateInput() -> Bool
    {
        var isInputValid = true
        //username validation
        if self.txtFieldUserName.text?.count == 0
        {
            self.lblUsernameWarning.isHidden = false
            self.lblUsernameWarning.text = "User Name is Mandatory"
            self.txtFieldUserName.layer.borderWidth = 0.3
            self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            if !isUserNameValid(self.txtFieldUserName.text!)
            {
                self.lblUsernameWarning.isHidden = false
                self.lblUsernameWarning.text = "User Name is not Valid"
                self.txtFieldUserName.layer.borderWidth = 0.3
                self.txtFieldUserName.layer.borderColor = UIColor.red.cgColor
                isInputValid = false
            }
            else
            {
                self.lblUsernameWarning.isHidden = true
                self.txtFieldUserName.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        //password validation
        if self.txtFieldPassword.text?.count == 0
        {
            self.lblPasswordWarning.isHidden = false
            self.lblPasswordWarning.text = "Password is Mandatory"
            self.txtFieldPassword.layer.borderWidth = 0.3
            self.txtFieldPassword.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            if !isPasswordValid(self.txtFieldPassword.text!)
            {
                self.lblPasswordWarning.isHidden = false
                self.lblPasswordWarning.text = "Password is not Valid"
                self.txtFieldPassword.layer.borderWidth = 0.3
                self.txtFieldPassword.layer.borderColor = UIColor.red.cgColor
                
                isInputValid = false
                
            }
            else
            {
                self.lblPasswordWarning.isHidden = true
                self.txtFieldPassword.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        //email validation
        if self.txtFieldEmail.text?.count == 0
        {
            self.lblEmailWarning.isHidden = false
            self.lblEmailWarning.text = "Email is Mandatory"
            self.txtFieldEmail.layer.borderWidth = 0.3
            self.txtFieldEmail.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            if !isEmailValid(self.txtFieldEmail.text!)
            {
                self.lblEmailWarning.isHidden = false
                self.lblEmailWarning.text = "Email is not Valid"
                self.txtFieldEmail.layer.borderWidth = 0.3
                self.txtFieldEmail.layer.borderColor = UIColor.red.cgColor
                isInputValid = false
                
            }
            else
            {
                self.lblEmailWarning.isHidden = true
                self.txtFieldEmail.layer.borderColor = UIColor.lightGray.cgColor
            }
            
        }
        //captcha validation
        //robot validation
        if isNotRobot == false
        {
            self.btnNotRobot.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            self.btnNotRobot.layer.borderColor = UIColor.lightGray.cgColor
        }
        //accept terms and conditions
        if isAgreedTermsCndtns == false
        {
            self.chkTermsCndtns.layer.borderColor = UIColor.red.cgColor
            isInputValid = false
        }
        else
        {
            self.chkTermsCndtns.layer.borderColor = UIColor.lightGray.cgColor
        }
        return isInputValid
    }
    
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
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - clear Errors
    func clearErrors()
    {
        if self.txtFieldUserName.layer.borderColor == UIColor.red.cgColor
        {
            self.txtFieldUserName.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.txtFieldPassword.layer.borderColor == UIColor.red.cgColor
        {
            self.txtFieldPassword.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.txtFieldEmail.layer.borderColor == UIColor.red.cgColor
        {
            self.txtFieldEmail.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.txtFieldCaptcha.layer.borderColor == UIColor.red.cgColor
        {
            self.txtFieldCaptcha.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.chkTermsCndtns.layer.borderColor == UIColor.red.cgColor
        {
            self.chkTermsCndtns.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.btnNotRobot.layer.borderColor == UIColor.red.cgColor
        {
            self.btnNotRobot.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if self.lblUsernameWarning.isHidden == false
        {
            self.lblUsernameWarning.isHidden = true
        }
        if self.lblPasswordWarning.isHidden == false
        {
            self.lblPasswordWarning.isHidden = true
        }
        if self.lblEmailWarning.isHidden == false
        {
            self.lblEmailWarning.isHidden = true
        }
    }
    
    // MARK: - clear data
    func clearData(){
        self.txtFieldUserName.text = ""
        self.txtFieldPassword.text = ""
        self.txtFieldEmail.text = ""
        self.txtFieldCaptcha.text = ""
        
        //check boxes
        isAgreedTermsCndtns = false
        self.chkTermsCndtns.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        isNotRobot = false
        self.btnNotRobot.setImage(UIImage.init(named: ""), for: UIControlState.normal)
    }
    
    
    
    
    
    
    
    
    
    
}
