//
//  SearchService.swift
//  top_games
//
//  Created by Mateus Padovani on 14/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Alamofire

class SearchService: Service {
    let endPoint = "search"
    
    func fetch(title: String, type: TypeMovie, page: Int = 1, response: ModelResponse<DiscoverResponse>) {
        let url = endPointURL.appendingPathComponent(type.rawValue)
        
        var params = configuration.params
        params["page"] = page
        params["query"] = title
        
        request(url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                response: response)
    }
}

