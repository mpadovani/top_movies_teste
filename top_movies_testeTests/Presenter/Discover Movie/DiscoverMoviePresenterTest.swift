//
//  DiscoverMoviePresenterTest.swift
//  top_movies_testeTests
//
//  Created by Mateus Padovani on 15/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import XCTest
@testable import top_movies_teste

class DiscoverMoviePresenterTest: XCTestCase {
    var discoverMovieViewDelegateMock: DiscoverMovieViewDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        discoverMovieViewDelegateMock = DiscoverMovieViewDelegateMock()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCancelSearch() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        
        presenter.cancelSearch()
        
        XCTAssertNil(presenter.currentPage)
        XCTAssertNil(presenter.totalPageSearch)
        XCTAssertNil(presenter.searchQuery)
        XCTAssertEqual(presenter.searchType, .default)
        XCTAssertEqual(presenter.moviesSearch.count, 0)
        XCTAssertTrue(discoverMovieViewDelegateMock.reloadDataHasBeenCalled)
    }
    
    func testMovieDefault() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = discoverServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        let movie = presenter.movie(at: 0)

        XCTAssertNotNil(movie.description)
        XCTAssertNotNil(movie.title)
        XCTAssertNotNil(movie.image)
    }
    
    func testMovieSearch() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesSearch = searchServiceMock.discoverResponse.results
        presenter.searchType = .search
        
        let movie = presenter.movie(at: 0)
        
        XCTAssertNotNil(movie.description)
        XCTAssertNotNil(movie.title)
        XCTAssertNotNil(movie.image)
    }
    
    func testFetchMovieStore() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.fetchMovieStore()
        
        XCTAssertTrue(discoverMovieViewDelegateMock.reloadDataHasBeenCalled)
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.moviesDefault.count, movieStoreDataStoreMock.movies.count)
    }
    
    func testFetchMovieStoreEmpty() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .noData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.fetchMovieStore()
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
    }
    
    func testFetchMovieStoreError() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .error)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.fetchMovieStore()
        
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
    }
    
    func testFetchDiscoverMoviesDisconnectRefreshControlFalse() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.isConnect = false
        
        presenter.fetchDiscoverMovies(false)
        
        XCTAssertTrue(discoverMovieViewDelegateMock.showDisconnectedViewHasBeenCalled)
        XCTAssertFalse(discoverMovieViewDelegateMock.endRefreshControlHasBeenCalled)
    }
    
    func testFetchDiscoverMoviesDisconnectRefreshControlTrue() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.isConnect = false
        
        presenter.fetchDiscoverMovies(true)
        
        XCTAssertTrue(discoverMovieViewDelegateMock.showDisconnectedViewHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endRefreshControlHasBeenCalled)
    }
    
    func testFetchDiscoverMovies() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.isConnect = true
        
        presenter.fetchDiscoverMovies(false)
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertNotNil(presenter.currentPage)
        XCTAssertNotNil(presenter.totalPage)
        XCTAssertEqual(presenter.moviesDefault.count, discoverServiceMock.discoverResponse.results.count)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.reloadDataHasBeenCalled)
    }
    
    func testFetchDiscoverMoviesRefreshControl() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.isConnect = true
        
        presenter.fetchDiscoverMovies(true)
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertNotNil(presenter.currentPage)
        XCTAssertNotNil(presenter.totalPage)
        XCTAssertEqual(presenter.moviesDefault.count, discoverServiceMock.discoverResponse.results.count)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endRefreshControlHasBeenCalled)
    }
    
    func testFetchDiscoverMoviesErrorRefreshControl() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .error)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.isConnect = true
        
        presenter.fetchDiscoverMovies(true)
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endRefreshControlHasBeenCalled)
    }
    
    func testFetchDiscoverMoviesError() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .error)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.isConnect = true
        
        presenter.fetchDiscoverMovies(false)
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
    }
    
    func testSaveStore() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.saveStore(discover: discoverServiceMock.discoverResponse.results)
        XCTAssertFalse(discoverMovieViewDelegateMock.presentHasBeenCalled)
    }
    
    func testSaveStoreEmpty() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .noData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.saveStore(discover: discoverServiceMock.discoverResponse.results)
        XCTAssertFalse(discoverMovieViewDelegateMock.presentHasBeenCalled)
    }
    
    func testSaveStoreError() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .error)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.saveStore(discover: discoverServiceMock.discoverResponse.results)
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
    }
    
    func testNextPagePersistence() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.nextPagePersistence(page: 2, initial: 20)
        XCTAssertEqual(presenter.currentPage, 2)
        XCTAssertTrue(discoverMovieViewDelegateMock.insertRowHasBeenCalled)
        XCTAssertFalse(presenter.isFetching)
        XCTAssertNil(presenter.nextPageTimer)
    }
    
    func testNextPagePersistenceError() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .error)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.nextPagePersistence(page: 2, initial: 20)
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
        XCTAssertFalse(presenter.isFetching)
        XCTAssertNil(presenter.nextPageTimer)
    }
    
    func testNextPageFetch() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.nextPageFetch(page: 2, initial: 20)
        XCTAssertEqual(presenter.currentPage, discoverServiceMock.discoverResponse.page)
        XCTAssertEqual(presenter.totalPage, discoverServiceMock.discoverResponse.totalPages)
        XCTAssertFalse(presenter.isFetching)
        XCTAssertNil(presenter.nextPageTimer)
    }
    
    func testNextPageFetchError() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .error)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        
        presenter.nextPageFetch(page: 2, initial: 20)
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
        XCTAssertFalse(presenter.isFetching)
        XCTAssertNil(presenter.nextPageTimer)
    }
    
    func testInsertRowsDefaultNextPage() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.searchType = .default
        presenter.moviesDefault = discoverServiceMock.discoverResponse.results
        
        presenter.insertRowsDefaultNextPage(movies: discoverServiceMock.discoverResponse.results, initial: 20)
        XCTAssertTrue(discoverMovieViewDelegateMock.insertRowHasBeenCalled)
    }
    
    func testSearch() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.isConnect = true
        
        presenter.search(title: "Poke")

        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.reloadDataHasBeenCalled)
        XCTAssertEqual(presenter.moviesSearch.count, searchServiceMock.discoverResponse.results.count)
        XCTAssertFalse(discoverMovieViewDelegateMock.showEmptyResultViewHasBeenCalled)
        XCTAssertEqual(presenter.currentPageSearch, searchServiceMock.discoverResponse.page)
        XCTAssertEqual(presenter.totalPageSearch, searchServiceMock.discoverResponse.totalPages)
    }
    
    func testSearchEmpty() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .noData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.isConnect = true
        
        presenter.search(title: "Poke")
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.reloadDataHasBeenCalled)
        XCTAssertEqual(presenter.moviesSearch.count, searchServiceMock.discoverResponseEmpty.results.count)
        XCTAssertTrue(discoverMovieViewDelegateMock.showEmptyResultViewHasBeenCalled)
        XCTAssertNil(presenter.currentPageSearch)
        XCTAssertNil(presenter.totalPageSearch)
    }
    
    func testSearchError() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .error)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.isConnect = true
        
        presenter.search(title: "Poke")
        
        XCTAssertTrue(discoverMovieViewDelegateMock.startLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.endLoadingHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.presentHasBeenCalled)
    }
    
    func testFetchMovieDisconnect() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.isConnect = false
        
        presenter.fetchMovie(at: "Poke")
        
        XCTAssertEqual(presenter.searchQuery, "Poke")
        XCTAssertEqual(presenter.searchType, .search)
        XCTAssertTrue(discoverMovieViewDelegateMock.reloadDataHasBeenCalled)
        XCTAssertTrue(discoverMovieViewDelegateMock.showDisconnectedViewHasBeenCalled)
    }
    
    
    func testFetchMovie() {
        let discoverServiceMock = DiscoverServiceMock(expectedResult: .newData)
        let searchServiceMock = SearchServiceMock(expectedResult: .newData)
        let movieStoreDataStoreMock = MovieStoreDataStoreMock(expectedResult: .newData)
        let presenter = DiscoverMoviePresenter(discoverService: discoverServiceMock, movieStoreDataStore: movieStoreDataStoreMock, searchService: searchServiceMock)
        presenter.delegate = discoverMovieViewDelegateMock
        presenter.moviesDefault = searchServiceMock.discoverResponse.results
        presenter.isConnect = true
        
        presenter.fetchMovie(at: "Poke")
        
        XCTAssertEqual(presenter.searchQuery, "Poke")
        XCTAssertEqual(presenter.searchType, .search)
    }

}
