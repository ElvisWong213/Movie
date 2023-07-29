//
//  WebAccess.swift
//  Movie
//
//  Created by Elvis on 22/07/2023.
//

import Foundation

class WebAccess {
    enum APIError: Error {
        case NoSuchPath, NoSuchKeys, invalidResponse, invalidData
    }
    
    func getAPIKey() throws -> String {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            throw APIError.NoSuchPath
        }
        guard let keys = NSDictionary(contentsOfFile: path) else {
            throw APIError.NoSuchKeys
        }
        return keys["TMDB_key"] as? String ?? ""
    }
    
    func fetchMovieFromAPI<T: Decodable>(url: URL, model: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(model.self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
}

// MARK: - List Movies
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

// MARK: - Movie Details
struct MovieDetail: Decodable {
    let genres: [Genres]
    let title: String
    let voteAverage: Float
    let overview: String
    let posterPath: String
    let runtime: Int
    let releaseDate: String
}

struct Genres: Decodable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Movie Review
struct ListOfReview: Decodable {
    let page: Int?
    let results: [Review]?
    let totalPages: Int?
}

struct Review: Decodable, Identifiable, Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String?
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let createdAt: String?
}

struct AuthorDetails: Decodable {
    let name: String?
    let userName: String?
    let rating: Float?
}

// MARK: - Video

