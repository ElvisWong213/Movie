//
//  MovieDetailView.swift
//  Movie
//
//  Created by Elvis on 19/07/2023.
//

import SwiftUI

struct MovieDetailView: View {
    private let webAccess = WebAccess()
    @State var data: MovieDetails? = nil
    @State var id: Int
    @State var selection = 1
    @State var isExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(data?.posterPath ?? "")")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                            Text("There was an error loading an image")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                        }
                        
                    }
                    .frame(width: 150)
                    VStack(alignment: .leading) {
                        Text(data?.title ?? "")
                            .font(.title2)
                        RatingBar(score: data?.voteAverage ?? 0)
                    }
                }
                .padding(.vertical)
                Picker(selection: $selection, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    Text("Informations").tag(1)
                    Text("Reviews").tag(2)
                }
                .pickerStyle(.segmented)
                switch(selection) {
                case 1:
                    VStack {
                        HStack {
                            Text("\(data?.genres.first?.name ?? "")")
//                                .background(.gray)
                            Text("\(data?.releaseDate ?? "")")
                            Text("\(data?.runtime ?? 0) min")
                            Spacer()
                        }
                        .padding(.bottom)
                        Group {
                            Text("\(data?.overview ?? "")")
                            Button("Test") {
                                isExpanded.toggle()
                            }
                        }
                        .lineLimit(isExpanded ? nil : 3)
                    }
                case 2:
                    Text("Review")
                default:
                    Text("Error")
                }
            }
            .padding()
        }
        .navigationTitle(data?.title ?? "Error")
        .task {
            await load()
        }
    }
    
    func load() async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")!
            
            data = try await webAccess.fetchMovieFromAPI(url: url, model: MovieDetails.self)
        } catch {
            print(error)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var movie: MovieOverview? = MovieOverview(id: 667538, title: "Transformers: Rise of the Beasts", releaseDate: "2023-06-06", overview: "When a new threat capable of destroying the entire planet emerges, Optimus Prime and the Autobots must team up with a powerful faction known as the Maximals. With the fate of humanity hanging in the balance, humans Noah and Elena will do whatever it takes to help the Transformers as they engage in the ultimate battle to save Earth.", voteAverage: 7.3, posterPath: "/gPbM0MK8CP8A174rmUwGsADNYKD.jpg")
        MovieDetailView(id: 667538)
    }
}
