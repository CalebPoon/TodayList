//
//  OthersFunc.swift
//  FoodTracker
//
//  Created by hula3 on 2018/3/2.
//  Copyright © 2018年 hula3. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Color

// Change color from hex to UIColor
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class customColor {
    static let globalBackground = hexStringToUIColor(hex: "#FCFBF8")
    static let globalShadow = hexStringToUIColor(hex: "F5F4F0")
    static let popViewBackground = hexStringToUIColor(hex: "FFFEFC")
    
    static let Blue_Background = hexStringToUIColor(hex: "4A90E2")
    static let Orange_alert = hexStringToUIColor(hex: "#FB912F")
    static let Green_date = hexStringToUIColor(hex: "#109F7C")
    static let Gray_topic = hexStringToUIColor(hex: "#666666")
    static let Red_delete = hexStringToUIColor(hex: "#E4384D")
    
    static let Black1 = hexStringToUIColor(hex: "#333333")
    static let Black2 = hexStringToUIColor(hex: "#666666")
    static let Black3 = hexStringToUIColor(hex: "#C2C2C2")
}

// MARK: - Date functions
func compareDate(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    //let date1Componet = calendar.component(.day, from: date1)
    let date1Componets = calendar.dateComponents([.day, .month, .year], from: date1)
    //let date2Componet = calendar.component(.day, from: date2)
    let date2Componets = calendar.dateComponents([.day, .month, .year], from: date2)
    
    
    if date1Componets.year == date2Componets.year, date1Componets.month == date2Componets.month, date1Componets.day == date2Componets.day {
         return true
    } else {
        return false
    }
}

func getStringOfDate(date: Date, type: Int) -> String {
    let dateFormatter = DateFormatter()
    if type == 1 {
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8")
        dateFormatter.dateFormat = "M月d日"
    } else {
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH:mm"
    }
    let string = dateFormatter.string(from: date)
    return string
}


