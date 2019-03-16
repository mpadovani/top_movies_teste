//
//  Movies.swift
//  top_games
//
//  Created by Mateus Padovani on 15/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let id: Int
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    let genres: [Genres]?
    let homepage: String?
    let status: String?
    let isDetails: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview = "overview"
        case genres = "genres"
        case homepage = "homepage"
        case status = "status"
        case isDetails = "isDetails"
    }
}

extension Movies {
    init(result: MovieStore) {
        id = Int(result.id)
        title = result.title ?? ""
        posterPath = result.posterPath ?? ""
        releaseDate = result.releaseDate
        overview = result.overview
        genres = result.genres?.compactMap({ Genres(name: $0) })
        homepage = result.homepage
        status = result.status
        isDetails = result.isDetails
    }
}

