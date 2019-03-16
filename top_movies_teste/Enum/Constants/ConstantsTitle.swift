//
//  ConstantsTitle.swift
//  top_games
//
//  Created by Mateus Padovani on 14/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

enum ConstantsTitle {
    case offline, tryAgain
    
    var localizedString: String {
        switch self {
        case .offline:
            return NSLocalizedString("Offline", comment: "Offline title")
        case .tryAgain:
            return NSLocalizedString("Try again", comment: "Try again title")
        }
    }
}
