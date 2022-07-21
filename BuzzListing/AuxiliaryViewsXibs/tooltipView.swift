//
//  tooltipView.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/14/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit


class tooltipView : UIView
{
    @IBOutlet var vwContainer: UIView!
    @IBOutlet var vwTriangle: UIView!
    @IBOutlet var vwTooltip: UIView!
    @IBOutlet var lblTooltip: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("tooltipView", owner: self, options: nil)
        addSubview(vwContainer)
        let hf = helperFunctions()
        vwTooltip.layer.borderColor = hf.hexStringToUIColor(hex: "#CBCBD1").cgColor
        vwTooltip.layer.borderWidth = 1.0
        vwContainer.frame = self.bounds
        vwContainer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       
    }
}
