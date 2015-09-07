//
//  Payment.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class Payment: Mappable  {
    public var payment_id: String!
    public var status: String!
    public var test: Bool!
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        payment_id <- map["payment_id"]
        status  <- map["status"]
        test  <- map["test"]
    }
}
