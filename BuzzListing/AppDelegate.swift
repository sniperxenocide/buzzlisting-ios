//
//  AppDelegate.swift
//  BuzzListing
//
//  Created by InfoSapex on 2/25/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import CoreLocation



let googleApiKey  = "AIzaSyD2Idp3PhmDhYEJQzJyyMQnwWNpVm0f4I4"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let manager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //get location
        manager.delegate = self
        manager.requestLocation()
        //end
        
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
           //call api to help in generating survey
           trackAppLaunching(location.coordinate.latitude, location.coordinate.longitude)
            //end
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func trackAppLaunching(_ lat : Double, _ long : Double)
    {
        NetworkManager.isReachable { networkManagerInstance in
            //send response to backend
            DispatchQueue.global(qos: .background).async {
                let baseURL = GlobalConstants.baseURL
                var varURL : String = ""
                if UserDefaults.standard.bool(forKey: "isLoggedIn") == true
                {
                    
                    varURL = String(format: "/api/v1/appview/?lat=%f&long=%f&username=%@",lat, long, UserDefaults.standard.string(forKey: "username")!)
                }
                else
                {
                    varURL = String(format: "/api/v1/ardata/?lat=%f&long=%f", lat, long)
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
                        }
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {// check for http errors
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {// check for http errors
                        guard let responseString = String(data: data, encoding: .utf8) else
                        {
                            return
                        }
                        print(responseString)
                    }
                }
                task.resume()
            }
            return
        }
        NetworkManager.isUnreachable { networkManagerInstance in
            return
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL?, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

