//
//  CreditsViewModel.swift
//  Movie
//
//  Created by Elvis on 01/08/2023.
//

import Foundation

class CreditsViewModel: ObservableObject {
    private let webAccess = WebAccess()
    @Published var crews: [Crew] = []
    @Published var casts: [Cast] = []
    
    func loadCrewsAndCasts(id: Int) async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)")!
            
            let data = try await webAccess.fetchMovieFromAPI(url: url, model: Credits.self)
            DispatchQueue.main.async { [self] in
                crews = data.crew
                casts = data.cast
            }
        } catch {
            print(error)
        }
    }
}
