//
//  CommonErrorHandler.swift
//  top_games
//
//  Created by Mateus Padovani on 14/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

enum CommonErrorHandler: LocalizedError {
    case notConnected
    
    var errorDescription: String? {
        switch self {
        case .notConnected:
            return NSLocalizedString("Connection time out", comment: "Connection time out error description")
        }
    }
}
