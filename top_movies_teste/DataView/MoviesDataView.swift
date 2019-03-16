//
//  DiscoverDataView.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

struct MoviesDataView {
    let model: Movies
    
    var title: String? {
        return model.title
    }
    
    var image: URL? {
        guard let posterPath = model.posterPath, let baseURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return nil }
        
        return baseURL
    }
    
    var description: String? {
        guard let overview = model.overview, !overview.isEmpty else { return NSLocalizedString("No description", comment: "No description message")}
        return overview
    }
}
