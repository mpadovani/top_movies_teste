//
//  MovieService.swift
//  top_games
//
//  Created by Mateus Padovani on 15/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Alamofire

class MovieService: Service {
    let endPoint = "movie"
    
    func fetch(id: Int, response: ModelResponse<DiscoverResponse>) {
        let url = endPointURL.appendingPathComponent(id.description)
    
        var params = configuration.params
        params["append_to_response"] = "credits"

        request(url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                response: response)
    }
}

