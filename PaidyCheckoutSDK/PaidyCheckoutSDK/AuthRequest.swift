//
//  AuthRequest.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class AuthRequest: Mappable {
    public var buyer: Buyer!
    public var merchant_data: MerchantData!
    public var order: Order!
    var tracking: Tracking!
    public var options: Options!
    var consumer_data: ConsumerData!
    var auth_code: String?
    public var checksum: String!
    public var subscription: Subscription?

    required public init?(_ map: Map) {
        mapping(map)
    }
    
    public init(){
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        buyer <- map["buyer"]
        merchant_data <- map["merchant_data"]
        order <- map["order"]
        tracking <- map["tracking"]
        options <- map["options"]
        consumer_data <- map["consumer_data"]
        auth_code <- map["auth_code"]
        checksum <- map["checksum"]
    }
}
