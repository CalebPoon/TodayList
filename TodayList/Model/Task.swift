//
//  Task.swift
//  TodayList
//
//  Created by hula3 on 2018/3/5.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit
import os.log

class Task: NSObject, NSCoding {

    //MARK - Properties
    
    var title: String
    var isChecked: Bool
    var date: Date
    
    // Optional
    var alert: Date?
    var topic: String?
    var remark: String?
    
    // MARK: Types
    struct PropertyKey{
        static let title = "title"
        static let isChecked = "isChecked"
        static let date = "date"
        static let alert = "alert"
        static let topic = "topic"
        static let remark = "remark"
    }
    
    // MARK: - Initialization
    
    init?(title: String, isChecked: Bool, date: Date, alert: Date?, topic: String?, remark: String?) {
        // The title must not be empty
        if title.isEmpty {
            return nil
        }
        
        
        if isChecked {
            return nil
        }
        
        /*
        if date.isEmpty {
            return nil
        }*/
        
        // Initialize stored properties.
        self.title = title
        self.isChecked = isChecked
        self.date = date
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(isChecked, forKey: PropertyKey.isChecked)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(alert, forKey: PropertyKey.alert)
        aCoder.encode(topic, forKey: PropertyKey.topic)
        aCoder.encode(remark, forKey: PropertyKey.remark)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The title is required. If we cannot decode a title string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let isChecked = aDecoder.decodeBool(forKey: PropertyKey.isChecked)
        
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the Date for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let alert = aDecoder.decodeObject(forKey: PropertyKey.alert) as? Date
        let topic = aDecoder.decodeObject(forKey: PropertyKey.topic) as? String
        let remark = aDecoder.decodeObject(forKey: PropertyKey.remark) as? String

        
        self.init(title: title, isChecked: isChecked, date: date, alert: alert, topic: topic, remark: remark)
    }
    
    // MARK: - Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("AllTasks")
}
