//
//  TaskTableViewCell.swift
//  TodayList
//
//  Created by hula3 on 2018/3/2.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

//MARK: Delegate method
protocol TodayListTaskTableViewCellDelegate: AnyObject {
    func checkboxTapped(cell : TodayListTaskTableViewCell)
}


class TodayListTaskTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var TaskTitle: UILabel!
    @IBOutlet weak var Checkbox: CheckBox!
    weak var delegate: TodayListTaskTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set background color
        backgroundColor = customColor.globalBackground
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
    

}