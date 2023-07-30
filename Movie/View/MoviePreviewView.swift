//
//  MoviePreviewView.swift
//  Movie
//
//  Created by Elvis on 20/07/2023.
//

import SwiftUI

struct MoviePreviewView: View {
    var data: MovieOverview

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w154\(data.posterPath ?? "")")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray)
                        VStack {
                            Spacer()
                            Image(systemName: "photo")
                            Text(data.title)
                            Spacer()
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .cornerRadius(5)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", data.voteAverage))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(width: 30, height: 20)
                    .padding()
                }
            }
        }
    }
}

struct MoviePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        @State var movie: MovieOverview = MovieOverview(id: 667538, title: "Transformers: Rise of the Beasts", releaseDate: "2023-06-06", overview: "When a new threat capable of destroying the entire planet emerges, Optimus Prime and the Autobots must team up with a powerful faction known as the Maximals. With the fate of humanity hanging in the balance, humans Noah and Elena will do whatever it takes to help the Transformers as they engage in the ultimate battle to save Earth.", voteAverage: 7.3, posterPath: "/gPbM0MK8CP8A174rmUwGsADNYKD.jpg")
        MoviePreviewView(data: movie)
    }
}
