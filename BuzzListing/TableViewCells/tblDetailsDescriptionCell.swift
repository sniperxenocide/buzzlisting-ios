//
//  tblDetailsDescriptionCell.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/6/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit

class tblDetailsDescriptionCell: UITableViewCell {

    @IBOutlet var btnMoreDetails: UIButton!
    
    @IBOutlet var listPrice: UILabel!
    @IBOutlet var txtDescription: UITextView!
    @IBOutlet var numberOfBaths: UILabel!
    @IBOutlet var propertyType: UILabel!
    
    @IBOutlet var airConditioning: UILabel!
    @IBOutlet var garageType: UILabel!
    @IBOutlet var taxes: UILabel!
    @IBOutlet var brokerage: UILabel!
    @IBOutlet var numberOfBeds: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
