//
//  Credits.swift
//  Movie
//
//  Created by Elvis on 31/07/2023.
//

import Foundation

struct Credits: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    let character: String
}

struct Crew: Decodable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    let department: String
}
