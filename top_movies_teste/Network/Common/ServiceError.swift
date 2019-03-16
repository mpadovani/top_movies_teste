//
//  ServiceError.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

struct ErrorsResponse: Codable, LocalizedError {
    let error: ServiceError
    
    var errorDescription: String? {
        return error.statusMessage
    }
}

struct ServiceError: Codable, LocalizedError {
    let statusCode: Int
    let statusMessage: String
    
    var errorDescription: String? {
        return statusMessage
    }
}

