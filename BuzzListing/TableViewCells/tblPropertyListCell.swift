//
//  tblPropertyListCell.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/1/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit

class tblPropertyListCell: UITableViewCell {

    @IBOutlet var imgProperty: UIImageView!
    @IBOutlet var propertyAddress: UILabel!
    @IBOutlet var btnFavorites: UIButton!
    @IBOutlet var propertyType: UILabel!
    @IBOutlet var propertyPrice: UILabel!
    @IBOutlet var propertyDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
