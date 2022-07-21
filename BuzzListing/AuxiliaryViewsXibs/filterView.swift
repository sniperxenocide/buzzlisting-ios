//
//  filterView.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/8/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit

class filterView : UIView
{
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var btnChkRes: UIButton!
    @IBOutlet var btnChkCom: UIButton!
    @IBOutlet var btnChkCon: UIButton!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var txtMinPrice: UITextField!
    @IBOutlet var txtMaxPrice: UITextField!
    var chkedRes: Bool = false
    var chkedCom: Bool = false
    var chkedCon: Bool = false
    
    
    
    
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
        Bundle.main.loadNibNamed("filterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        btnChkRes.layer.cornerRadius = 3
        btnChkRes.layer.borderColor = UIColor.darkGray.cgColor
        btnChkRes.layer.borderWidth = 1
        btnChkRes.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        
        btnChkCom.layer.cornerRadius = 3
        btnChkCom.layer.borderColor = UIColor.darkGray.cgColor
        btnChkCom.layer.borderWidth = 1
        btnChkCom.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        
        btnChkCon.layer.cornerRadius = 3
        btnChkCon.layer.borderColor = UIColor.darkGray.cgColor
        btnChkCon.layer.borderWidth = 1
        btnChkCon.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        
        btnDone.layer.cornerRadius = 3.0
        
        
    }
    @IBAction func actionBtnRes(_ sender: UIButton) {
        if chkedRes == false
        {
            chkedRes = true
            btnChkRes.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
            
        }
        else
        {
            chkedRes = false
            btnChkRes.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
    }
    @IBAction func actionBtnCom(_ sender: UIButton) {
        if chkedCom == false
        {
            chkedCom = true
            btnChkCom.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
        }
        else
        {
            chkedCom = false
            btnChkCom.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
    }
    @IBAction func actionBtnCon(_ sender: UIButton) {
        if chkedCon == false
        {
            chkedCon = true
            btnChkCon.setImage(UIImage.init(named: "tick"), for: UIControlState.normal)
        }
        else
        {
            chkedCon = false
            btnChkCon.setImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
    }
}
