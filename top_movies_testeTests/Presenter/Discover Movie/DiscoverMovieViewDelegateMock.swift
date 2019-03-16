//
//  DiscoverMovieViewDelegateMock.swift
//  top_movies_testeTests
//
//  Created by Mateus Padovani on 15/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit
@testable import top_movies_teste

class DiscoverMovieViewDelegateMock: DiscoverMovieViewDelegate {
    var startLoadingHasBeenCalled = false
    var endLoadingHasBeenCalled = false
    var reloadDataHasBeenCalled = false
    var insertRowHasBeenCalled = false
    var showMovieDetailsHasBeenCalled = false
    var presentHasBeenCalled = false
    var endRefreshControlHasBeenCalled = false
    var showDisconnectedViewHasBeenCalled = false
    var showEmptyResultViewHasBeenCalled = false
    
    func startLoading() {
        startLoadingHasBeenCalled = true
    }
    
    func endLoading() {
        endLoadingHasBeenCalled = true
    }
    
    func reloadData() {
        reloadDataHasBeenCalled = true
    }
    
    func present(error: Error) {
        presentHasBeenCalled = true
    }
    
    func insertRow(at indexPath: [IndexPath]) {
        insertRowHasBeenCalled = true
    }
    
    func showMovieDetails(discoverDataView: MoviesDataView) {
        showMovieDetailsHasBeenCalled = true
    }
    
    func endRefreshControl() {
        endRefreshControlHasBeenCalled = true
    }
    
    func showDisconnectedView() {
        showDisconnectedViewHasBeenCalled = true
    }
    
    func showEmptyResultView() {
        showEmptyResultViewHasBeenCalled = true
    }
}
