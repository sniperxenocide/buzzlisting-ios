//
//  TermsAndCndtnsViewController.swift
//  BuzzListing
//
//  Created by Adnan Hassan on 4/9/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class TermsAndCndtnsViewController : UIViewController
{
    
    @IBOutlet weak var trmsWebView: WKWebView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var btnOK: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //design
        mainContainerView.layer.cornerRadius = 10
        mainContainerView.layer.shadowColor = UIColor.black.cgColor
        mainContainerView.layer.shadowOpacity = 1
        mainContainerView.layer.shadowOffset = CGSize(width: 5, height:0)
        btnOK.layer.cornerRadius = 5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    func fetchData()
    {
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseURL
                let varURL = "/api/v1/terms/"
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
                        print("response = \(String(describing: response))")
                        print("data = \(String(describing: data))")
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(String(describing: responseString))")
                        
                        guard let unwrappedResponse = responseString
                            else{
                                return
                        }
                        print(unwrappedResponse)
                        
                        do {
                            let dataArray : NSMutableArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableArray
                            if(dataArray.count != 0)
                            {
                                let dataDict : NSDictionary = dataArray[0] as! NSDictionary
                                let responseText = dataDict.object(forKey: "text") as! NSString
//                                let terms = try NSAttributedString(data: responseText.data(using : String.Encoding.utf8.rawValue)!,
//                                    options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//                                print(terms)
                                print(responseText)
                                DispatchQueue.main.async {
                                    self.trmsWebView.loadHTMLString(responseText as String, baseURL: nil)
                                }
                            }
                            else
                            {
                                return
                            }
                            print(dataArray)
                            
                            
                        } catch {
                            DispatchQueue.main.async {
                                self.trmsWebView.loadHTMLString("", baseURL: nil)
                            }
                            return
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
    
    @IBAction func btnOKAction(_ sender: UIButton) {
        //presentingViewController?.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
}
