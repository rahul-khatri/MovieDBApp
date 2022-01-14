//
//  UIWindow+Extension.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.
//

import Foundation
import UIKit

extension UIWindow {
    static var key: UIWindow? {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.window
    }
}
