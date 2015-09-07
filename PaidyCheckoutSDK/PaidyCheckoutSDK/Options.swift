//
//  Options.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class Options: Mappable {
    var authorize_type: String!
    var num_payments: Int!
    
    public init(authorize_type: String){
        self.authorize_type = authorize_type
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        authorize_type <- map["authorize_type"]
        num_payments <- map["num_payments"]
    }
}
