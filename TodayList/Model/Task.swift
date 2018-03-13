//
//  Task.swift
//  TodayList
//
//  Created by hula3 on 2018/3/5.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class Task {
    
    //MARK Properties
    
    var title: String
    var isChecked: Bool
    
    //var date: Date
    //var alert:
    
    
    //MARK: Initialization
    
    init?(title: String, isChecked: Bool) {
        // The title must not be empty
        if title.isEmpty {
            return nil
        }
        
        // isChecked must be false
        if isChecked {
            return nil
        }
        
        // Initialize stored properties.
        self.title = title
        self.isChecked = isChecked
    }
}
