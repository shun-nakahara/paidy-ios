//
//  Tracking.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

class Tracking: Mappable  {
    var channel: String!
    var device_id: String!
    var consumer_ip: String!
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        channel    <- map["channel"]
        device_id         <- map["device_id"]
        consumer_ip      <- map["consumer_ip"]
    }
    
    init() {
        self.channel = "SDK";
        self.device_id = "53ad2b654d00007600c17d54";
        self.consumer_ip = "0.0.0.0";
    }
}
