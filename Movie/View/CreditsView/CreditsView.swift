//
//  CreditsView.swift
//  Movie
//
//  Created by Elvis on 31/07/2023.
//

import SwiftUI

struct CreditsView: View {
    @StateObject var creditsViewModel = CreditsViewModel()
    var id: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast & Crew")
                .font(.title)
                .bold()
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 20) {
                    ForEach(creditsViewModel.casts) { cast in
                        NavigationLink {
                            ActorsDetailView(id: cast.id)
                        } label: {
                            ActorsPreview(profilePath: cast.profilePath ?? "", name: cast.name, position: cast.character)
                        }
                    }
                    ForEach(creditsViewModel.crews) { crew in
                        NavigationLink {
                            ActorsDetailView(id: crew.id)
                        } label: {
                            ActorsPreview(profilePath: crew.profilePath ?? "", name: crew.name, position: crew.department)
                        }
                    }
                }
            }
            .scaledToFit()
        }
        .task {
            await creditsViewModel.loadCrewsAndCasts(id: id)
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView(id: 667538)
    }
}
