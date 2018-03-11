//
//  customCheckbox.swift
//  TodayList
//
//  Created by hula3 on 2018/3/4.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    var isChecked:Bool = false{
        didSet {
            if isChecked == true{
                
                self.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_S_OK"), for: .normal)
            }else{
                self.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_S"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        //self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: .touchUpInside)
        self.isChecked = false
        self.setBackgroundImage(#imageLiteral(resourceName: "Checkmark_S"), for: .normal)
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
