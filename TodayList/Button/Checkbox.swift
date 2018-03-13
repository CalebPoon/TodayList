//
//  customCheckbox.swift
//  TodayList
//
//  Created by hula3 on 2018/3/4.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    var addedTouchArea = CGFloat(0)
    
    var isChecked:Bool = false{
        didSet {
            // Animation
            if isChecked == true{
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: { (_: Bool) in
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        self.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_S_OK"), for: .normal)
                        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }, completion: { (_: Bool) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    })
                })
            }else{
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.alpha = 0
                }, completion: { (_: Bool) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.alpha = 1
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_S"), for: .normal)
                    })
                })
            }
        }
    }
    
    override func awakeFromNib() {
        //self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: .touchUpInside)
        self.isChecked = false
        self.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_S"), for: .normal)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newBound = CGRect(
            x: self.bounds.origin.x - addedTouchArea,
            y: self.bounds.origin.y - addedTouchArea,
            width: self.bounds.width + 2 * addedTouchArea,
            height: self.bounds.height + 2 * addedTouchArea
        )
        return newBound.contains(point)
    }
    /*
    @objc func buttonClicked(sender: UIButton) {
        if (sender == self){
            if isChecked == true{
                isChecked = false
            }else{
                isChecked = true
            }
        }
    }
 */
        
}
