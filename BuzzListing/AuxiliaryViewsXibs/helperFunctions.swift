//
//  helperFunctions.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/12/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit


class helperFunctions
{
    // MARK: - get and post data
    func getData(strURL : String)
    {
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                print(strURL)
                guard let url = URL(string: strURL) else {
                    print("Error: cannot create URL")
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
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    let httpStatus = response as? HTTPURLResponse
                    print("statusCode should be 200, but is \(String(describing: httpStatus?.statusCode))")
                    
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
    func postData(strURL : String, postData : String)
    {
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")
            DispatchQueue.global(qos: .background).async {
                print("This will run on the background queue")
                let url = URL(string: strURL)!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let postString = postData
                request.httpBody = postString.data(using: .utf8)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {     // check for fundamental networking error
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    
                    DispatchQueue.main.async {
                        print("This will run on the main queue, after the previous code in outer block")
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
    
    
    // MARK: - get color from hexcode
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: - Realm related method
    
    
    
    
}
