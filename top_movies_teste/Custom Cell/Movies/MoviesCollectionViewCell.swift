//
//  MoviesCollectionViewCell.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(discoverDataView: MoviesDataView) {
        movieImageView.setImage(withURL: discoverDataView.image, placeholderImage: #imageLiteral(resourceName: "placeholder-image-icon-14.jpg"))
    }

    override func prepareForReuse() {
        movieImageView.cancelImageRequest()
    }
}
