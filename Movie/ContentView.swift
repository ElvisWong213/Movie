//
//  ContentView.swift
//  Movie
//
//  Created by Elvis on 18/07/2023.
//

import SwiftUI

enum TopMenuCategory: String, CaseIterable, Identifiable, Hashable {
    var id: String { UUID().uuidString }
    
    case nowPlaying = "Now Playing"
    case search = "Search"
    case trending = "Trending"
}

struct ContentView: View {
    @State private var selectedCategory: TopMenuCategory = .nowPlaying
    
    var body: some View {
        TabView(selection: $selectedCategory) {
            GridMoviesView(selectedCategory: TopMenuCategory.nowPlaying)
                .tabItem {
                    Label(TopMenuCategory.nowPlaying.rawValue, systemImage: "play.fill")
                }
                .tag(TopMenuCategory.nowPlaying)
            GridMoviesView(selectedCategory: TopMenuCategory.trending)
                .tabItem {
                    Label(TopMenuCategory.trending.rawValue, systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(TopMenuCategory.trending)
            SearchView()
                .tabItem {
                    Label(TopMenuCategory.search.rawValue, systemImage: "magnifyingglass")
                }
                .tag(TopMenuCategory.search)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
