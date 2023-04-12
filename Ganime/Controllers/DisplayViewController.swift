//
//  DisplayViewController.swift
//  Ganime
//
//  Created by Brian Rosales on 2/12/22.
//

import UIKit

class DisplayViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var statusRating: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    var dataManager = DataManager()
    var animeModel: AnimeModel?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = animeModel?.animeTitle
        synopsisLabel.text = animeModel?.synopsis
        ratingLabel.text = animeModel?.rating
        ageRating.text = animeModel?.ageRating
        statusRating.text = animeModel?.status
        if let url = URL(string: animeModel!.animeImage) {
            posterImageView.load(url: url)
        }
    }
}
//MARK: - UIImageView(converts to URL and retrieves Image)
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
