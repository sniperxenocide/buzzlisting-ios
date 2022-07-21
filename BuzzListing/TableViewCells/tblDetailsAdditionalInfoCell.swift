//
//  tblDetailsAdditionalInfoCell.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/6/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit

class tblDetailsAdditionalInfoCell: UITableViewCell {
    
    @IBOutlet var type2: UILabel!
    @IBOutlet var mls: UILabel!
    @IBOutlet var parkingSpaces: UILabel!
    @IBOutlet var style: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
