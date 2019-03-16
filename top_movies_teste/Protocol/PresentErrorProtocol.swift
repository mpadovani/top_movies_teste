//
//  PresentErrorProtocol.swift
//  top_games
//
//  Created by Mateus Padovani on 14/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation
import UIKit

protocol PresentErrorProtocol {
    func present(error: Error)
}

extension PresentErrorProtocol where Self: UIViewController {
    func present(error: Error) {
        let title = NSLocalizedString("Error", comment: "Error alert title")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
