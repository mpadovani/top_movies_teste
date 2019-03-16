//
//  EmptyView.swift
//  top_games
//
//  Created by Mateus Padovani on 14/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit

protocol EmptyViewDelegate: class {
    func didTapActionButton(_ button: UIButton)
}

class EmptyView: UIView, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var delegate: EmptyViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func setup(title: String?, description: String?, isActionHidden: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        actionButton.isHidden = isActionHidden
    }
    
    func setupWithDisconnetView() {
        titleLabel.text = ConstantsTitle.offline.localizedString
        descriptionLabel.text = ConstantsMessage.offline.localizedString
        actionButton.setTitle(ConstantsTitle.tryAgain.localizedString, for: .normal)
    }
    
    @IBAction func tapActionButton(_ sender: UIButton) {
        delegate?.didTapActionButton(sender)
    }
}
