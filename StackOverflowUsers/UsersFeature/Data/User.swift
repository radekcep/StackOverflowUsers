//
//  User.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

struct User: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let reputation: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case name = "display_name"
        case imageURL = "profile_image"
        case reputation
    }
}
