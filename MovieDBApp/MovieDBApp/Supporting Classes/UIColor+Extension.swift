//
//  UIColor+Extension.swift
//  MovieDBApp
//
//  Created by Rahul on 13/01/22.
//

import Foundation
import UIKit
 
extension UIColor {
    public convenience init?(hex: String) {
        //let r, g, b, a: CGFloat
        
        var myHex = hex
        if myHex == "" {
            myHex = "#ffffff"
        }
        var cString:String = myHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        return
    }
}
