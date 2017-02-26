//
//  UserModel.swift
//  Octowire
//
//  Created by Mart Roosmaa on 26/02/2017.
//  Copyright © 2017 Mart Roosmaa. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    var id: Int64?
    var username: String?
    var avatarUrl: String?
    var name: String?
    var bio: String?
    var location: String?
    var email: String?
    var website: String?

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.username <- map["login"]
        self.avatarUrl <- map["avatar_url"]
        self.name <- map["name"]
        self.bio <- map["bio"]
        self.location <- map["location"]
        self.email <- map["email"]
        self.website <- map["blog"]
    }
}
