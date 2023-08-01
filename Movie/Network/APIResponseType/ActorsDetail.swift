//
//  ActorsDetail.swift
//  Movie
//
//  Created by Elvis on 01/08/2023.
//

import Foundation

struct ActorsDetail: Decodable {
    let name: String?
    let birthday: String?
    let biography: String?
    let gender: Int?
    let profilePath: String?
    let placeOfBirth: String?
    let homepage: String?
    let knownForDepartment: String?
}
