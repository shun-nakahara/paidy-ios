//
//  Paidy.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

public class Paidy: NSObject {
    var merchantKey : String
    var sessionId: String
    public var imagePath: String?
    
    public init(merchantKey: String) {
        self.merchantKey = merchantKey
        self.sessionId = ("\(Int(NSDate().timeIntervalSince1970 * 1000))")
    }
    
    public func launch(delegate:PaidyCheckOutDelegate, authRequest: AuthRequest) -> UIViewController{
        let paidyViewController = PaidyCheckOutViewController(merchantKey: merchantKey, delegate: delegate, authRequest: authRequest, sessionId: sessionId, imagePath: imagePath)
        return paidyViewController
    }
}
