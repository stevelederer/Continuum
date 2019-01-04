//
//  Extensions.swift
//  Continuum
//
//  Created by Steve Lederer on 1/2/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
