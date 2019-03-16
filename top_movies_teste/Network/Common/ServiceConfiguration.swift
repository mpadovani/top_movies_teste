//
//  ServiceConfiguration.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Alamofire

struct ServiceConfiguration {
    let baseURL: URL
    var params: Parameters
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let dateFormatter: DateFormatter
    
    static var `default`: ServiceConfiguration = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        #if DEBUG
        let baseURL = URL(string: "https://api.themoviedb.org/3/")!
        #else
        let baseURL = URL(string: "https://api.themoviedb.org/3/")!
        #endif
        
        #if DEBUG
        let apiKey = "7221f0cd988902b38544fb994c8be044"
        #else
        let apiKey = "7221f0cd988902b38544fb994c8be044"
        #endif
        
        var params: Parameters = [:]
        
        
        params = ["api_key": apiKey, "language": Locale.preferredLanguages.first!]

        return ServiceConfiguration(baseURL: baseURL,
                                    params: params,
                                    decoder: decoder,
                                    encoder: encoder,
                                    dateFormatter: dateFormatter)
    }()
}
