//
//  Buyer.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class Buyer: Mappable {
    var name: String!
    var name2: String!
    var dob: String!
    public var email: Email!
    public var phone: Phone!
    public var address: Address!

    public init(name: String, name2: String, dob: String){
        self.name = name
        self.name2 = name2
        self.dob = dob
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        name <- map["name"]
        name2 <- map["name2"]
        dob <- map["dob"]
        email <- map["email"]
        phone <- map["phone"]
        address <- map["address"]
    }
    
    public class Email: Mappable {
        var address: String  = ""
        
        public init(address: String){
            self.address = address
        }
        
        required public init?(_ map: Map) {
            mapping(map)
        }
        
        // Mappable
        public func mapping(map: Map) {
            address <- map["address"]
        }
    }
    
    public class Phone: Mappable {
        var number: String  = ""
        
        public init(number: String){
            self.number = number
        }
        
        required public init?(_ map: Map) {
            mapping(map)
        }
        
        // Mappable
        public func mapping(map: Map) {
            number <- map["number"]
        }
    }
    
    public class Address: Mappable {
        var address1: String = ""
        var address2: String = ""
        var address3: String = ""
        var address4: String = ""
        var postal_code: String = ""
        
        public init(address1: String, address2: String, address3: String, address4: String, postal_code: String){
            self.address1 = address1
            self.address2 = address2
            self.address3 = address3
            self.address4 = address4
            self.postal_code = postal_code
        }
        
        required public init?(_ map: Map) {
            mapping(map)
        }
        
        // Mappable
        public func mapping(map: Map) {
            address1 <- map["address1"]
            address2 <- map["address2"]
            address3 <- map["address3"]
            address4 <- map["address4"]
            postal_code <- map["postal_code"]
        }
    }
}
