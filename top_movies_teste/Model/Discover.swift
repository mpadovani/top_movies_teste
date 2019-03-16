//
//  Discover.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

struct DiscoverResponse: Codable {
    let totalPages: Int
    let page: Int
    let results: [Movies]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case totalPages = "total_pages"
        case page = "page"
    }
}
