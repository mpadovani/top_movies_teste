//
//  DiscoverService.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Alamofire

class DiscoverService: Service {
    let endPoint = "discover"
    
    func fetch(type: TypeMovie, page: Int = 1, response: ModelResponse<DiscoverResponse>) {
        let url = endPointURL.appendingPathComponent(type.rawValue)
        
        var params = configuration.params
        params["page"] = page

        request(url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                response: response)
    }
}

