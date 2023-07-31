//
//  MovieDetail.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

struct MovieDetail: Decodable {
    let genres: [Genres]
    let title: String
    let voteAverage: Float
    let overview: String
    let posterPath: String?
    let runtime: Int
    let releaseDate: String
}

struct Genres: Decodable, Identifiable {
    let id: Int
    let name: String
}
