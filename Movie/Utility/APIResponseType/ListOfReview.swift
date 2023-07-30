//
//  ListOfReview.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

struct ListOfReview: Decodable {
    let page: Int
    let results: [Review]
    let totalPages: Int
}

struct Review: Decodable, Identifiable, Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
}

struct AuthorDetails: Decodable {
    let name: String
    let userName: String?
    let rating: Float?
}
