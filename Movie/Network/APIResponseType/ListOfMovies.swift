//
//  ListOfMovies.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

struct ListOfMovies: Decodable {
    let page: Int
    let totalPages: Int
    let results: [MovieOverview]
}

struct MovieOverview: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let voteAverage: Float
    let posterPath: String?
}
