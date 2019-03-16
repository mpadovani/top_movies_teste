//
//  MovieStoreDataStoreMock.swift
//  top_movies_testeTests
//
//  Created by Mateus Padovani on 16/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation
@testable import top_movies_teste

class MovieStoreDataStoreMock: MovieStoreDataStore {
    
    var expectedResult: ExpectedResult? = .error
    
    lazy var error: Error = FakeError.fake
    
    lazy var movies: [Movies] = {
        var movies = Movies(id: 1, title: "teste", posterPath: "teste", releaseDate: "teste", overview: "teste", genres: [], homepage: nil, status: nil, isDetails: nil)
        return Array(repeating: movies, count: 20)
    }()
    
    init(expectedResult: ExpectedResult?) {
        super.init()
        self.expectedResult = expectedResult
    }
    
    override func fetchMovieStore(offset: Int, success: @escaping ([Movies]) -> Void, failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
        guard let expectedResult = expectedResult else {
            fatalError("set the expectedResult")
        }
        
        switch expectedResult {
        case .newData:
            success(movies)
            break
        case .noData:
            success([])
            break
        case .error:
            failure(FakeError.fake)
            break
        }
        completion()
    }
    
    override func save(discover: [Movies], success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        guard let expectedResult = expectedResult else {
            fatalError("set the expectedResult")
        }
        
        switch expectedResult {
        case .newData:
            success()
            break
        case .noData:
            success()
            break
        case .error:
            failure(FakeError.fake)
            break
        }
        completion()
    }
    
    override func update(discover: Movies, success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        guard let expectedResult = expectedResult else {
            fatalError("set the expectedResult")
        }
        
        switch expectedResult {
        case .newData:
            success()
            break
        case .noData:
            success()
            break
        case .error:
            failure(FakeError.fake)
            break
        }
        completion()
    }
}
