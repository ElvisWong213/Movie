//
//  ExpandText.swift
//  Movie
//
//  Created by Elvis on 28/07/2023.
//

import SwiftUI

struct ExpandText: View {
    @State private var isExpended = false
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .multilineTextAlignment(.leading)
                .lineLimit(isExpended ? nil : 3)
            Button(isExpended ? "Read Less" : "Read More") {
                isExpended.toggle()
            }
        }
        .scaleEffect()
        .animation(.easeInOut, value: isExpended)
    }
}

struct ExpandText_Previews: PreviewProvider {
    static var previews: some View {
        ExpandText(text: "When a new threat capable of destroying the entire planet emerges, Optimus Prime and the Autobots must team up with a powerful faction known as the Maximals. With the fate of humanity hanging in the balance, humans Noah and Elena will do whatever it takes to help the Transformers as they engage in the ultimate battle to save Earth.")
    }
}
