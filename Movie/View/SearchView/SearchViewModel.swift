//
//  SearchViewModel.swift
//  Movie
//
//  Created by Elvis on 29/07/2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    private let webAccess = WebAccess()
    @Published var totalPages: Int?
    @Published var currentPage = 1
    
    @Published var searchText: String = ""
    @Published var movies: [MovieOverview] = []
    @Published var selectedMovie: MovieOverview?
    
    
    
    func updateMoviesList(page: Int) async {
        do {
            let bufferSearchText = searchText.replacing(" ", with: "+")
            let apiKey = try webAccess.getAPIKey()
            var baseUrl = "https://api.themoviedb.org/3/search/movie"
            if searchText.isEmpty {
                baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)"
            }
            let url = URL(string: "\(baseUrl)?api_key=\(apiKey)&page=\(page)&query=\(bufferSearchText)")!
            let respond = try await webAccess.fetchMovieFromAPI(url: url, model: ListOfMovies.self)
            DispatchQueue.main.async {
                self.totalPages = respond.totalPages
                self.movies.append(contentsOf: respond.results)
            }
        } catch {
            print(error)
        }
    }
}
