//
//  SearchView.swift
//  Movie
//
//  Created by Elvis on 21/07/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            List(selection: $searchViewModel.selectedMovie) {
                Section(searchViewModel.searchText.isEmpty ? "Popular" : "Results") {
                    ForEach(searchViewModel.movies) { movie in
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
                                if searchViewModel.currentPage <= searchViewModel.totalPages ?? 0 {
                                    searchViewModel.currentPage += 1
                                    await searchViewModel.updateMoviesList(page: searchViewModel.currentPage)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchViewModel.searchText)
            .navigationTitle(TopMenuCategory.search.rawValue)
        }
        .task {
            await searchViewModel.updateMoviesList(page: searchViewModel.currentPage)
        }
        .onChange(of: searchViewModel.searchText) { _ in
            Task {
                searchViewModel.movies.removeAll()
                searchViewModel.currentPage = 1
                await searchViewModel.updateMoviesList(page: searchViewModel.currentPage)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
