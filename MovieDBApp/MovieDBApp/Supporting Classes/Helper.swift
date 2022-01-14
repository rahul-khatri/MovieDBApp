//
//  Helper.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.
//

import Foundation
import UIKit

func showAlert(_ title: String, _ message: String, _ onComplete: (()->Void)? = nil) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) { action in
        onComplete?()
    }
    alert.addAction(okAction)
    
    UIWindow.key?.rootViewController?.present(alert, animated: true, completion: nil)
}
