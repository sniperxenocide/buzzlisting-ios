//
//  SegueFromLeft.swift
//  BuzzListing
//
//  Created by InfoSapex on 3/5/18.
//  Copyright © 2018 InfoSapex. All rights reserved.
//

import Foundation
import UIKit
class SegueFromLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        print(src)
        print(dst)
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: nil
        )
    }
}
