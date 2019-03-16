//
//  UIImageView+Extension.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImage(withURL url: URL?, placeholderImage: UIImage?) {
        self.image = placeholderImage
        guard let url = url else { return }
        self.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
    
    func cancelImageRequest() {
        self.af_cancelImageRequest()
    }
    
}
