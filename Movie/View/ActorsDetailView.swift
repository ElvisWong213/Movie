//
//  ActorsDetailView.swift
//  Movie
//
//  Created by Elvis on 01/08/2023.
//

import SwiftUI

struct ActorsDetailView: View {
    private let webAccess = WebAccess()
    @State var data: ActorsDetail?
    
    var id: Int
    
    var body: some View {
        VStack {
            if let data {
                ScrollView {
                    VStack {
                        CacheAsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(data.profilePath ?? "")")!) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                Text("There was an error loading an image")
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 200)
                        HStack {
                            MovieLabel(text: data.knownForDepartment ?? "")
                            MovieLabel(text: data.birthday ?? "")
                            MovieLabel(text: convertGender())
                        }
                        Text(data.placeOfBirth ?? "")
                        if data.homepage != nil {
                            Link("Home Page", destination: URL(string: data.homepage ?? "")!)
                        }
                        Text(data.biography ?? "")
                    }
                    .padding()
                }
                .navigationTitle(data.name ?? "")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .task {
            await loadDetail()
        }
    }
    
    func convertGender() -> String {
        switch data?.gender {
        case 0:
            return "Not set / not specified"
        case 1:
            return "Female"
        case 2:
            return "Male"
        case 3:
            return "Non-binary"
        default:
            return "Error"
        }
    }
    
    func loadDetail() async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/person/\(id)?api_key=\(apiKey)")!
            data = try await webAccess.fetchMovieFromAPI(url: url, model: ActorsDetail.self)
        } catch {
            print(error)
        }
    }
}

struct ActorsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActorsDetailView(id: 1560244)
    }
}
