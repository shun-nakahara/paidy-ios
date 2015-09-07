//
//  MerchantData.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class MerchantData: Mappable {
    public var store: String = "Demo"
    public var customer_age: Int!
    public var last_order: Int!
    public var last_order_amount: Double!
    public var known_address: Bool!
    public var num_orders: Int!
    public var ltv: Double!
    public var ip_address: String!
    
    public init(store: String, last_order: Int, customer_age: Int,  last_order_amount: Double, known_address: Bool, num_orders: Int,
        ltv: Double, ip_address: String) {
            self.store = store
            self.customer_age = customer_age
            self.last_order = last_order
            self.last_order_amount = last_order_amount
            self.known_address = known_address
            self.num_orders = num_orders
            self.ltv = ltv
            self.ip_address = ip_address
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        store <- map["store"]
        customer_age <- map["customer_age"]
        last_order <- map["last_order"]
        last_order_amount <- map["last_order_amount"]
        known_address <- map["known_address"]
        num_orders <- map["num_orders"]
        ltv <- map["ltv"]
        ip_address <- map["ip_address"]
    }
}
