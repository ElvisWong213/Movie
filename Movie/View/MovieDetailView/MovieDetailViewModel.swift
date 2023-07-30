//
//  MovieDetailViewModel.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    private let webAccess = WebAccess()
    
    @Published var data: MovieDetail?
    @Published var selection = 1
    
    func loadMovieDetails(id: Int) async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")!
            let buffer = try await webAccess.fetchMovieFromAPI(url: url, model: MovieDetail.self)
            
            DispatchQueue.main.async {
                self.data = buffer
            }
        } catch {
            print(error)
        }
    }
}
