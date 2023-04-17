//
//  DisplayViewController.swift
//  Ganime
//
//  Created by Brian Rosales on 2/12/22.
//

import UIKit
import CoreData

class DisplayViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var statusRating: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    var newImage: UIImage = UIImage(named: "Ganime")!
    
    var dataManager = DataManager()
    var animeModel: AnimeModel?
    
    init(selectedAnime: AnimeModel) {
        self.animeModel = selectedAnime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = animeModel?.animeTitle
        synopsisLabel.text = animeModel?.synopsis
        ratingLabel.text = animeModel?.rating
        ageRating.text = animeModel?.ageRating
        statusRating.text = animeModel?.status
        if let url = URL(string: animeModel!.animeImage) {
            posterImageView.load(url: url)
            grabImage(url: url)
        }
    }
    
    @IBAction func saveSeries(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let jpegImageData = newImage.jpegData(compressionQuality: 1.0)
        let data = NSEntityDescription.insertNewObject(forEntityName: "Series", into: context)
        data.setValue(titleLabel.text, forKey: "name")
        data.setValue(jpegImageData, forKey: "image")
        
        do {
            try context.save()
            print("Saved\t \(titleLabel.text)")
        } catch {
            print("Could not save. \(error)")
        }
    }

    func grabImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.newImage = image
                    }
                }
            }
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
