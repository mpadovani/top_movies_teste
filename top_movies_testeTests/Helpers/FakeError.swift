//
//  FakeError.swift
//  top_movies_testeTests
//
//  Created by Mateus Padovani on 15/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

enum FakeError: LocalizedError {
    
    case fake
    
    var errorDescription: String? {
        return "Error Mock"
    }
    
}
