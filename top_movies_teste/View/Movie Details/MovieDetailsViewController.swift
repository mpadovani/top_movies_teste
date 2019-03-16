//
//  MovieDetailsViewController.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var discoverDataView: MoviesDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieImageView.setImage(withURL: discoverDataView.image, placeholderImage: #imageLiteral(resourceName: "placeholder-image-icon-14.jpg"))
        movieTitleLabel.text = discoverDataView.title
        movieDescriptionLabel.text = discoverDataView.description
    }
}
