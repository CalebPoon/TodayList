//
//  TaskTableViewCell.swift
//  TodayList
//
//  Created by hula3 on 2018/3/2.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit
import AudioToolbox

//MARK: Delegate method
protocol TodayListTaskTableViewCellDelegate: AnyObject {
    func checkboxTapped(cell : TodayListTaskTableViewCell)
}


class TodayListTaskTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var TaskTitle: UILabel!
    @IBOutlet weak var Checkbox: CheckBox!
    var alertIcon: UIImageView!
    
    weak var delegate: TodayListTaskTableViewCellDelegate?
    
    var hasAlert = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set background color
        backgroundColor = customColor.globalBackground
        backgroundView = UIImageView(image: #imageLiteral(resourceName: "CheckedCell"))
        backgroundView?.alpha = 0
        
        Checkbox.addedTouchArea = 6
        
        /*
        //addAlertIcon()
        if hasAlert {
            layoutWithAlert()
        } else {
            layoutWithoutAlert()
        }*/
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
       
    }
    
    //MARK: Action
    
    // Assign the action of checkbox
    @IBAction func checkboxTapped(_ sender: CheckBox) {
        // Check delegate is not nil with '?'
        delegate?.checkboxTapped(cell: self)
    }


    // MARK: - Alert Layout
    func layoutWithoutAlert() {
        // Checkbox
        Checkbox.frame = CGRect(x: 16, y: self.center.y - Checkbox.frame.height/2, width: Checkbox.frame.width, height: Checkbox.frame.height)
        
        // TaskTitle
        TaskTitle.sizeToFit()
        
        let titleLengthMaximum = self.frame.width - 16 - 4 - Checkbox.frame.width - 16
        if TaskTitle.frame.width > titleLengthMaximum {
            TaskTitle.frame = CGRect(x: 16 + Checkbox.frame.width + 4, y: self.center.y - TaskTitle.frame.height/2, width: titleLengthMaximum, height: TaskTitle.frame.height)
        } else  {
            TaskTitle.frame = CGRect(x: 16 + Checkbox.frame.width + 4, y: self.center.y - TaskTitle.frame.height/2, width: TaskTitle.frame.width, height: TaskTitle.frame.height)
        }
        
    }
    /*
    func layoutWithAlert() {
        // Checkbox
        Checkbox.frame = CGRect(x: 16, y: self.center.y - Checkbox.frame.height/2, width: Checkbox.frame.width, height: Checkbox.frame.height)

        // TaskTitle
        TaskTitle.sizeToFit()
        let titleLengthMaximum = self.frame.width - 16 - alertIcon.frame.width - 6 - 4 - Checkbox.frame.width - 16
        if TaskTitle.frame.width > titleLengthMaximum {
            TaskTitle.frame = CGRect(x: 16 + Checkbox.frame.width + 4, y: self.center.y - TaskTitle.frame.height/2, width: titleLengthMaximum, height: TaskTitle.frame.height)
        } else  {
            TaskTitle.frame = CGRect(x: 16 + Checkbox.frame.width + 4, y: self.center.y - TaskTitle.frame.height/2, width: TaskTitle.frame.width, height: TaskTitle.frame.height)
        }
        
        //AlertIcon
        addAlertIcon()
    
    }*/
    
    func addAlertIcon() {
        alertIcon = UIImageView()
        alertIcon.image = #imageLiteral(resourceName: "Alert_s")
        alertIcon.frame = CGRect(x: 16 + Checkbox.frame.width + 4 + TaskTitle.frame.width + 6, y: self.center.y - alertIcon.frame.height/2, width: alertIcon.frame.width, height: alertIcon.frame.height)
        self.addSubview(alertIcon)
    }

}
