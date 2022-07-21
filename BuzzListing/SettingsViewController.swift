//
//  SettingsViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/6/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - components
    @IBOutlet var tblSettings: UITableView!
    // MARK: - initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register table view cells
        self.tblSettings.register(UINib(nibName: "tblSettingsCell", bundle: nil), forCellReuseIdentifier: "tblSettingsCell")
    }
    // MARK: - UITableViewDatasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 450
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblSettingsCell", for: indexPath) as! tblSettingsCell
        cell.btnSignInUp.addTarget(self, action: #selector(showSignInUPPage), for: UIControlEvents.touchUpInside)
        cell.btnLogout.addTarget(self, action: #selector(showSignInUPPage), for: UIControlEvents.touchUpInside)
        cell.btnAbout.addTarget(self, action: #selector(showAboutBuzzListing), for: UIControlEvents.touchUpInside)
        cell.btnTerms.addTarget(self, action: #selector(showTerms), for: UIControlEvents.touchUpInside)
        return cell
    }
    // MARK: - Go Back From Settings
    
    @IBAction func goBack(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - show sign up page
    @objc func showSignInUPPage(sender:UIButton!)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - About BuzzListing 1.0
    @objc func showAboutBuzzListing(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndCndtnsViewController") as! TermsAndCndtnsViewController
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Terms & Conditions
    @objc func showTerms(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndCndtnsViewController") as! TermsAndCndtnsViewController
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
