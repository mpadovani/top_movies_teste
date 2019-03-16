//
//  DiscoverServiceMock.swift
//  top_movies_testeTests
//
//  Created by Mateus Padovani on 15/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation
@testable import top_movies_teste

class DiscoverServiceMock: DiscoverService {
    
    let expectedResult: ExpectedResult
    
    lazy var error: Error = FakeError.fake
    
    lazy var discoverResponse: DiscoverResponse = {
      let movie = Movies(id: 1, title: "Teste", posterPath: "teste", releaseDate: "teste", overview: "teste", genres: [], homepage: "teste", status: "teste", isDetails: false)
        
        let movies: [Movies] = Array(repeating: movie, count: 20)

        return DiscoverResponse(totalPages: 1000, page: 1, results: movies)
    }()
    
    lazy var discoverResponseEmpty: DiscoverResponse = {
        return DiscoverResponse(totalPages: 1000, page: 1, results: [])
    }()
    
    init(expectedResult: ExpectedResult) {
        self.expectedResult = expectedResult
    }
    
    override func fetch(type: TypeMovie, page: Int, response: (success: (DiscoverResponse) -> (), failure: (Error) -> (), completion: () -> ())) {
        switch expectedResult {
        case .newData:
            response.success(discoverResponse)
            break
        case .noData:
            response.success(discoverResponseEmpty)
            break
        case .error:
            response.failure(FakeError.fake)
            break
        }
        response.completion()
    }
}
