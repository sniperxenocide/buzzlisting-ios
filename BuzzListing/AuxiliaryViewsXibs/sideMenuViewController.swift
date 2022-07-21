//
//  sideMenuViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/5/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit

class sideMenuViewController : UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var sideMenuView: UIView!
    @IBOutlet var sideMenuVisualEffect: UIVisualEffectView!
    @IBOutlet var sideMenuVisualEffectView: UIView!
    @IBOutlet var backBtnLogoView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var imgAppLogo: UIImageView!
    @IBOutlet var signInUPBtn: UIButton!
    @IBOutlet var tblSideMenu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //design
        sideMenuView.layer.shadowColor = UIColor.black.cgColor
        sideMenuView.layer.shadowOpacity = 0.8
        sideMenuView.layer.shadowOffset = CGSize(width: 5, height:0)
        //adding a pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(panPerformed(_:))))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        //register table view cells
        self.tblSideMenu.register(UINib(nibName: "tblSideMenuCell", bundle: nil), forCellReuseIdentifier: "tblSideMenuCell")
        
    }
    // MARK: - Hide Side Menu
    @objc func panPerformed(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began || panGesture.state == .changed
        {
            let translation = panGesture.translation(in: self.view).x
            
            if translation > 0 { //swipe right
                
                
                
                
            }
            else //swipe left
            {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFromRight
                transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                self.view.window!.layer.add(transition, forKey: kCATransition)
                
                self.dismiss(animated: false, completion: nil)
                
            }
        }
        else if panGesture.state == .ended
        {
            
        }
    }
    @IBAction func goBackFromSideMenu(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - Sign In or Sign UP
    @IBAction func signInUPAction(_ sender: UIButton) {
        let loginNavigationController = storyboard?.instantiateViewController(withIdentifier: "loginNavigationController") as! loginNavigationController
        present(loginNavigationController, animated: true, completion: nil)
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
                return 7
            }
            else if section == 2
            {
                return 4
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
                else if indexPath.row == 1
                {
                    cell.titleMenuItem.text = "Notifications"
                    cell.imgManuItem.image = UIImage.init(named: "notifications")
                }
                else if indexPath.row == 2
                {
                    cell.titleMenuItem.text = "Saved Searches"
                    cell.imgManuItem.image = UIImage.init(named: "saved_favorites")
                }
                if indexPath.row == 3
                {
                    cell.titleMenuItem.text = "Favorite Listings"
                    cell.imgManuItem.image = UIImage.init(named: "saved_favorites")
                }
                else if indexPath.row == 4
                {
                    cell.titleMenuItem.text = "Contacted Listings"
                    cell.imgManuItem.image = UIImage.init(named: "contacted_listings")
                }
                else if indexPath.row == 5
                {
                    cell.titleMenuItem.text = "Recently Viewed Listings"
                    cell.imgManuItem.image = UIImage.init(named: "recently_viewed_searches")
                }
                else if indexPath.row == 6
                {
                    cell.titleMenuItem.text = "Recent Searches"
                    cell.imgManuItem.image = UIImage.init(named: "recently_viewed_searches")
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
                    cell.titleMenuItem.text = "Rate This App"
                    cell.imgManuItem.image = UIImage.init(named: "rate_this_app")
                }
                else if indexPath.row == 1
                {
                    cell.titleMenuItem.text = "Feedback"
                    cell.imgManuItem.image = UIImage.init(named: "feedback")
                }
                else if indexPath.row == 2
                {
                    cell.titleMenuItem.text = "List a rental"
                    cell.imgManuItem.image = UIImage.init(named: "list_a_rental")
                }
                else if indexPath.row == 3
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
}
