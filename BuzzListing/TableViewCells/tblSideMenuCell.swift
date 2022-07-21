//
//  tblSideMenuCell.swift
//  BuzzListing
//
//  Created by InfoSapex on 2/28/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import UIKit

class tblSideMenuCell: UITableViewCell {

    @IBOutlet var cellContentView: UIView!
    @IBOutlet var cellBackgroundView: UIView!
    @IBOutlet var imgManuItem: UIImageView!
    @IBOutlet var titleMenuItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
