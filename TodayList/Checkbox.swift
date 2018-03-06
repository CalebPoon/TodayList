//
//  customCheckbox.swift
//  TodayList
//
//  Created by hula3 on 2018/3/4.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    let checkedImage = UIImage(named:"Checkmark_S_OK")! as UIImage
    let unCheckedImage  = UIImage(named: "Checkmark_S")! as UIImage
    
    var isChecked:Bool = false{
        didSet {
            if isChecked == true{
                self.setBackgroundImage(checkedImage, for: .normal)
            }else{
                self.setBackgroundImage(unCheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        //self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: .touchUpInside)
        self.isChecked = false
        self.setBackgroundImage(unCheckedImage, for: .normal)
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
