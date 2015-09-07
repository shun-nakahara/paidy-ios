//
//  TextViewStates.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class TextViewStates {
    
    static func setNormal(textField:UITextField) {
        var layer = textField.layer
        layer.cornerRadius = 6.0;
        layer.masksToBounds = true;
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(netHex:0xCECECF).CGColor
        
        textField.layer == layer
        textField.backgroundColor = UIColor(netHex:0xFFFFFF)
    }
    
    static func setError(textField:UITextField) {
        var layer = textField.layer
        layer.cornerRadius = 6.0;
        layer.masksToBounds = true;
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(netHex:0xCECECF).CGColor
        
        textField.layer == layer
        textField.backgroundColor = UIColor(netHex:0xFAE5E6)
    }
}
