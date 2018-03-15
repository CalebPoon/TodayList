//
//  AddedTouchAreaButton.swift
//  TodayList
//
//  Created by hula3 on 2018/3/13.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class AddedTouchAreaButton: UIButton {

    var addedTouchArea = CGFloat(0)
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if addedTouchArea == 40 {
                let newBound = CGRect(
                x: self.bounds.origin.x - addedTouchArea,
                y: self.bounds.origin.y - addedTouchArea,
                width: self.bounds.width + 2 * addedTouchArea,
                height: self.bounds.height + 2 * addedTouchArea
            )
            return newBound.contains(point)
        } else {
                let newBound = CGRect(
                x: self.bounds.origin.x,
                y: self.bounds.origin.y,
                width: self.bounds.width,
                height: self.bounds.height + 40
            )
            return newBound.contains(point)
        }
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
