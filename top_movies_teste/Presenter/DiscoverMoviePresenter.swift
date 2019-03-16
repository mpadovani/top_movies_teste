//
//  DiscoverMoviePresenter.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation

protocol DiscoverMovieViewDelegate: class {
    func startLoading()
    func endLoading()
    func reloadData()
    func insertRow(at indexPath: [IndexPath])
    func showMovieDetails(discoverDataView: MoviesDataView)
    func present(error: Error)
    func endRefreshControl()
    func showDisconnectedView()
    func showEmptyResultView()
}

protocol DiscoverMoviePresenterDelegate {
    var delegate: DiscoverMovieViewDelegate? { get set }
    var numberOfRows: Int { get }
    func viewDidLoad()
    func movie(at row: Int) -> MoviesDataView

    
    func willDisplayCell(at indexPath: IndexPath)
    func didSelectItem(at row: Int)
    func refreshMovieData()
    func cancelSearch()
    func fetchMovie(at title: String?)
    func tryReconnect()
}


class DiscoverMoviePresenter: DiscoverMoviePresenterDelegate {
    weak var delegate: DiscoverMovieViewDelegate?
    private var discoverService: DiscoverService
    private var movieStoreDataStore: MovieStoreDataStore
    private var searchService: SearchService
    
    // MARK: Common
    var searchType: SearchType = .default
    var nextPageTimer: Timer? = nil
    var isFetching: Bool = false
    var isConnect: Bool = ReachabilityTest.isConnectedToNetwork()
    
    // MARK: Default
    var currentPage: Int?
    var totalPage: Int?
    var moviesDefault: [Movies] = []

    // MARK: Search
    var currentPageSearch: Int?
    var totalPageSearch: Int?
    var moviesSearch: [Movies] = []
    var performDataRequest: Timer? = nil
    var searchQuery: String? = nil

    init(discoverService: DiscoverService, movieStoreDataStore: MovieStoreDataStore, searchService: SearchService) {
        self.discoverService = discoverService
        self.movieStoreDataStore = movieStoreDataStore
        self.searchService = searchService
    }
    
    // MARK: Common
    
    var numberOfRows: Int {
        switch searchType {
        case .default:
            return moviesDefault.count
        case .search:
            return moviesSearch.count
        }
    }
    
    func movie(at row: Int) -> MoviesDataView {
        switch searchType {
        case .default:
            return MoviesDataView(model: moviesDefault[row])
        case .search:
            return MoviesDataView(model: moviesSearch[row])
        }
    }
    
    func viewDidLoad() {
        fetchMovieStore()
    }

    func tryReconnect() {
        switch searchType {
        case .default:
            fetchMovieStore()
            break
        case .search:
            fetchMovie(at: searchQuery)
            break
        }
    }
    
    func setCurrentPage(discoverResponse: DiscoverResponse) {
        self.currentPage = discoverResponse.page
        self.totalPage = discoverResponse.totalPages
        
        session.totalPage = discoverResponse.totalPages
    }
    
    func isConnect(_ isConnect: Bool) -> Bool {
        return isConnect
    }
    
    func didSelectItem(at row: Int) {
        self.delegate?.showMovieDetails(discoverDataView: movie(at: row))
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if !isFetching && numberOfRows - 1 == indexPath.row {
            self.isFetching = true
            
            let fetchBlock = { [weak self] in
                self?.nextPage()
            }
            
            nextPageTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (timer) in
                fetchBlock()
            })
        }
    }
    
    @objc func nextPage() {
        switch searchType {
        case .default:
            nextPageDefault(currentPage: currentPage, totalPage: totalPage)
            break
        case .search:
            nextPageIsSearch(currentPage: currentPageSearch, totalPage: totalPageSearch, query: searchQuery)
            break
        }
    }
    
    // MARK: Default
    
    func refreshMovieData() {
        if !isConnect(ReachabilityTest.isConnectedToNetwork()) {
            self.delegate?.endRefreshControl()
            self.delegate?.present(error: CommonErrorHandler.notConnected)
            return
        }
        
        performDataRequest?.invalidate()

        movieStoreDataStore.deleteAll(success: {
            currentPage = nil
            totalPage = nil
            self.moviesDefault = []
            self.delegate?.reloadData()
            fetchDiscoverMovies(true)
        }, failure: { (error) in
            self.delegate?.present(error: error)
        }) { }
    }
    
    func fetchMovieStore() {
        movieStoreDataStore.fetchMovieStore(offset: moviesDefault.count + 20, success: { [weak self] (discover) in
            if discover.count > 0 {
                self?.currentPage = 1
                self?.totalPage = session.totalPage
                self?.moviesDefault = discover
                self?.delegate?.reloadData()
                return
            }
            
            self?.fetchDiscoverMovies(false)
            
            }, failure: { [weak self] (error) in
                self?.delegate?.present(error: error)
        }) { }
    }
    
    func fetchDiscoverMovies(_ refreshControl: Bool) {
        if !isConnect(isConnect) {
            self.delegate?.showDisconnectedView()
            
            if refreshControl {
                self.delegate?.endRefreshControl()
            }
            
            return
        }
        
        self.delegate?.startLoading()

        
        discoverService.fetch(type: TypeMovie.movie, response: (success: { [weak self] discoverResponse in
            self?.setCurrentPage(discoverResponse: discoverResponse)
            self?.moviesDefault = discoverResponse.results
            self?.saveStore(discover: discoverResponse.results)
            self?.delegate?.reloadData()
            }, failure: { [weak self] error in
                self?.delegate?.present(error: error)
            }, completion: { [weak self] in
                self?.delegate?.endLoading()
                
                if refreshControl {
                    self?.delegate?.endRefreshControl()
                }
        }))
    }
    
    func saveStore(discover: [Movies]) {
        movieStoreDataStore.save(discover: discover, success: {
        }, failure: { (error) in
            self.delegate?.present(error: error)
        }) { }
    }
    
    func nextPageDefault(currentPage: Int?, totalPage: Int?) {
        guard let currentPage = currentPage, let totalPage = totalPage else { return }
        
        if currentPage < totalPage {
            let initial = numberOfRows
            
            nextPagePersistence(page: currentPage + 1, initial: initial)
        }
    }

    func nextPagePersistence(page: Int, initial: Int) {
        movieStoreDataStore.fetchMovieStore(offset: page * 20, success: { [weak self] movies in
            if movies.count > 0 {
                self?.currentPage = page
                self?.insertRowsDefaultNextPage(movies: movies, initial: initial)
                return
            }
            
            self?.nextPageFetch(page: page, initial: initial)
            
        }, failure: { [weak self] error in
            self?.delegate?.present(error: error)
        }) { [weak self] in
            self?.isFetching = false
            self?.nextPageTimer?.invalidate()
            self?.nextPageTimer = nil
        }
    }
    
    func nextPageFetch(page: Int, initial: Int) {
        discoverService.fetch(type: TypeMovie.movie, page:  page, response: (success: { [weak self] discoverResponse in
            self?.setCurrentPage(discoverResponse: discoverResponse)
            self?.saveStore(discover: discoverResponse.results)
            
            self?.insertRowsDefaultNextPage(movies: discoverResponse.results, initial: initial)
        }, failure: { [weak self] error in
            self?.delegate?.present(error: error)
        }, completion: { [weak self] in
            self?.isFetching = false
            self?.nextPageTimer?.invalidate()
            self?.nextPageTimer = nil
        }))
    }
    
    func insertRowsDefaultNextPage(movies: [Movies], initial: Int) {
        self.moviesDefault.append(contentsOf: movies)
        
        let indexPath: [IndexPath] = (initial..<movies.count + initial).compactMap { item in
            return IndexPath(item: item, section: 0)
        }
        
        self.delegate?.insertRow(at: indexPath)
    }
    
    // MARK: Search
    
    func fetchMovie(at title: String?) {
        self.searchQuery = title
        self.searchType = .search
        
        if !isConnect(isConnect) {
            self.delegate?.reloadData()
            self.delegate?.showDisconnectedView()
            return
        }
  
        performDataRequest?.invalidate()
        
        let fetchBlock = { [weak self] in
            guard let title = title, !title.isEmpty else {
                return
            }
            
            self?.search(title: title)
        }
        
        performDataRequest = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            fetchBlock()
        }
    }
    
    func search(title: String) {
        self.delegate?.startLoading()

        self.searchService.fetch(title: title, type: .movie, response: (success: { [weak self] discoverResponse in
            if discoverResponse.results.count > 0 {
                self?.currentPageSearch = discoverResponse.page
                self?.totalPageSearch = discoverResponse.totalPages
                self?.moviesSearch = discoverResponse.results
                self?.delegate?.endLoading()
                self?.delegate?.reloadData()
                return
            }
            
            self?.delegate?.endLoading()
            self?.currentPageSearch = nil
            self?.totalPageSearch = nil
            self?.moviesSearch = []
            self?.delegate?.reloadData()
            self?.delegate?.showEmptyResultView()
        }, failure: { [weak self] error in
            self?.delegate?.endLoading()
            self?.delegate?.present(error: error)
        }, completion: {
            
        }))
    }

    func cancelSearch() {
        self.currentPageSearch = nil
        self.totalPageSearch = nil
        self.moviesSearch = []
        self.searchQuery = nil
        self.searchType = .default
        
        self.delegate?.reloadData()
    }
    
    func nextPageIsSearch(currentPage: Int?, totalPage: Int?, query: String?) {
        guard let currentPage = currentPage, let totalPage = totalPage, let query = query else { return }
        
        if currentPage < totalPage {
            let initial = numberOfRows
            
            searchService.fetch(title: query, type: .movie, page: currentPage + 1, response: (success: { [weak self] discoverResponse in
                self?.moviesSearch.append(contentsOf: discoverResponse.results)

                let indexPath: [IndexPath] = (initial..<discoverResponse.results.count + initial).compactMap { item in
                    return IndexPath(item: item, section: 0)
                }
                
                self?.delegate?.insertRow(at: indexPath)
                
                }, failure: { [weak self] error in
                    self?.delegate?.present(error: error)
                }, completion: { [weak self] in
                    self?.isFetching = false
                    self?.nextPageTimer?.invalidate()
                    self?.nextPageTimer = nil
            }))
        }
    }
}
