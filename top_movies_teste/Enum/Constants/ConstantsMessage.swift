//
//  ConstantsMessage.swift
//  top_games
//
//  Created by Mateus Padovani on 14/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

enum ConstantsMessage {
    case offline
    
    var localizedString: String {
        switch self {
        case .offline:
            return NSLocalizedString("Your connection is offline try reconnecting to download the movie list.", comment: "Your connection is offline try reconnecting to download the movie list message")
           // Sua conexão está offline tente reconectar para baixar a lista de filmes
        }
    }
}
