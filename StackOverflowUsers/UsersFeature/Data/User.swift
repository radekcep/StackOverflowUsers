//
//  User.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let imageURL: URL
    let reputation: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case name = "display_name"
        case imageURL = "profile_image"
        case reputation
    }
}
