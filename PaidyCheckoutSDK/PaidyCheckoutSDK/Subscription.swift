//
//  Subscription.swift
//  PaidyCheckoutSDK
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class Subscription: Mappable {
    var title: String!
    var interval: String!
    var interval_count: Int = 0
    var start: String!

    public init(title: String, interval: String, interval_count: Int, start: String){
        self.title = title
        self.interval = interval
        self.interval_count = interval_count
        self.start = start
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        title <- map["title"]
        interval <- map["interval"]
        interval_count <- map["interval_count"]
        start <- map["start"]
    }
}