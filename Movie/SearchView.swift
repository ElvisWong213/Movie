//
//  SearchView.swift
//  Movie
//
//  Created by Elvis on 21/07/2023.
//

import SwiftUI

struct SearchView: View {
    private let webAccess = WebAccess()
    @State private var totalPages: Int?
    @State private var currentPage = 1
    
    @State var searchText: String = ""
    @State var movies: [MovieOverview] = []
    @State var selectedMovie: MovieOverview?
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedMovie) {
                Section(searchText.isEmpty ? "Popular" : "Results") {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetailView(id: movie.id)
                        } label: {
                            HStack {
                                MoviePreviewView(data: movie)
                                    .frame(width: 80)
                                Text(movie.title)
                            }
                        }
                        .onAppear() {
                            Task {
                                if currentPage <= totalPages ?? 0 {
                                    currentPage += 1
                                    await updateMoviesList(page: currentPage)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle(TopMenuCategory.search.rawValue)
        }
        .task {
            await updateMoviesList(page: currentPage)
        }
        .onChange(of: searchText) { _ in
            Task {
                movies.removeAll()
                currentPage = 1
                await updateMoviesList(page: currentPage)
            }
        }
    }
    
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
            totalPages = respond.totalPages
            movies.append(contentsOf: respond.results)
        } catch {
            print(error)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
