//
//  MoreDetailsViewController.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/6/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit

class MoreDetailsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - components
    @IBOutlet var tblMoreDetails: UITableView!
    // MARK: - initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register table view cells
        self.tblMoreDetails.register(UINib(nibName: "tblMoreDetailsCell", bundle: nil), forCellReuseIdentifier: "tblMoreDetailsCell")
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 1780
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblMoreDetailsCell", for: indexPath) as! tblMoreDetailsCell
        
        return cell
    }
}
