//
//  MovieLabel.swift
//  Movie
//
//  Created by Elvis on 29/07/2023.
//

import SwiftUI

struct MovieLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(10)
            .background() {
                Rectangle()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
            }
    }
}

struct MovieLabel_Previews: PreviewProvider {
    static var previews: some View {
        MovieLabel(text: "Test")
    }
}
