//
//  TopicTableViewCell.swift
//  TodayList
//
//  Created by hula3 on 2018/4/30.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var TopicTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = customColor.popViewBackground
        TopicTitle.textColor = customColor.Black1
        
        // selection background
        let selectedView = UIView()
        selectedView.backgroundColor = customColor.globalShadow
        selectedView.layer.cornerRadius = 10
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
