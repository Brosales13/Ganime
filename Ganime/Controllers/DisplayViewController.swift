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
    private var navigationBar: UINavigationBar!
    private var customNavigationItem: UINavigationItem!
    var dataManager = DataManager()
    var animeModel: AnimeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        self.setNavigationBar()
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
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request : NSFetchRequest<Series> = Series.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", titleLabel.text!)
            let numberOfRecords = try context.count(for: request)
        
            if numberOfRecords == 0 {
                let jpegImageData = newImage.jpegData(compressionQuality: 1.0)
                let data = NSEntityDescription.insertNewObject(forEntityName: "Series", into: context)
                data.setValue(titleLabel.text, forKey: "name")
                data.setValue(jpegImageData, forKey: "image")
                
                try context.save()
                let alertController = UIAlertController(title: "Series Saved.", message: "This Series has been saved to device storage.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok",style: .default))
                present(alertController, animated: true, completion: nil)
                print("Saved\t \(titleLabel.text)")
            } else {
                // pop-up must appear
                let alertController = UIAlertController(title: "Series Already Saved.", message: "This Series has already been saved to device storage.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok",style: .default))
                present(alertController, animated: true, completion: nil)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func setup(seriesInfo: AnimeModel) {
        self.animeModel = seriesInfo
    }
    
    func setNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        navigationBar.backgroundColor = .black
        view.addSubview(navigationBar)
        customNavigationItem = UINavigationItem()
        customNavigationItem.title = "Ganime"
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(done))
        customNavigationItem.leftBarButtonItem = leftBarButton
        navigationBar.items = [customNavigationItem]
        self.view.addSubview(navigationBar)
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
        print("done")
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
