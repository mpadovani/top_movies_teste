//
//  MovieCollectionViewController.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit

class DiscoverMovieCollectionViewController: UICollectionViewController, PresentErrorProtocol {
    lazy var presenter: DiscoverMoviePresenterDelegate = {
        let context = CoreDataStackSingleton.shared.persistentContainer.viewContext
        let presenter = DiscoverMoviePresenter(discoverService: DiscoverService(),
                                               movieStoreDataStore: MovieStoreDataStore(context: context),
                                               searchService: SearchService())
        presenter.delegate = self
        return presenter
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovieData), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigation()
        
        presenter.viewDidLoad()
    }
    
    func setupCollectionView() {
        let nibCell = UINib(nibName: "MoviesCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        
        let movieCollectionViewLayout = MoviesCollectionViewLayout()
        collectionView?.collectionViewLayout = movieCollectionViewLayout
        
        collectionView.refreshControl = refreshControl
        
    }

    func setupNavigation() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = true
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    @objc func refreshMovieData() {
        presenter.refreshMovieData()
    }
    
    // MARK: - Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
    
        cell.setup(discoverDataView: presenter.movie(at: indexPath.row))
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameDetails" {
            let destination = segue.destination as? MovieDetailsViewController
            destination?.discoverDataView = sender as? MoviesDataView
        }
    }
}

extension DiscoverMovieCollectionViewController: DiscoverMovieViewDelegate {
    func showDisconnectedView() {
        let disconnectEmptyView = EmptyView()
        disconnectEmptyView.setupWithDisconnetView()
        disconnectEmptyView.delegate = self
        collectionView.backgroundView = disconnectEmptyView
    }
    
    func showEmptyResultView() {
        let emptyResultView = EmptyView()
        emptyResultView.setup(title: "Sem resultado :(",
                              description: "Nenhum resultadon encontrado tente outro título na pesquisa",
                              isActionHidden: true)
        collectionView.backgroundView = emptyResultView
    }
    
    func endRefreshControl() {
        refreshControl.endRefreshing()
    }
    
    func showMovieDetails(discoverDataView: MoviesDataView) {
        performSegue(withIdentifier: "showGameDetails", sender: discoverDataView)
    }
    
    func insertRow(at indexPath: [IndexPath]) {
        collectionView.insertItems(at: indexPath)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func startLoading() {
        collectionView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
    
    func endLoading() {
        activityIndicatorView.stopAnimating()
        collectionView.backgroundView = nil
    }
}

extension DiscoverMovieCollectionViewController: EmptyViewDelegate {
    func didTapActionButton(_ button: UIButton) {
        collectionView.backgroundView = nil
        presenter.tryReconnect()
    }
}

extension DiscoverMovieCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.fetchMovie(at: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cancelSearch()
    }
}
