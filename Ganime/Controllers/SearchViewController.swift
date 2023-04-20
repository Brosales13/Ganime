//
//  SearchViewController.swift
//  Ganime
//
//  Created by Brian Rosales on 2/9/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var dataManager = DataManager()
    var animeModel: AnimeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        dataManager.delegate = self
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favoriteViewController = storyboard.instantiateViewController(withIdentifier: "favorite_controller") as! FavoriteViewController
        self.present(favoriteViewController, animated: true, completion: nil)
    }
}

//MARK: - DataManagerDelegate (returns Data for URL)
extension SearchViewController: DataManagerDelegate {
    func didUpdateAnime(animeUpdated: AnimeModel) {
        DispatchQueue.main.async {
            self.animeModel = animeUpdated
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let displayViewController = storyboard.instantiateViewController(withIdentifier: "display_controller") as! DisplayViewController
            displayViewController.setup(seriesInfo: self.animeModel!)
            self.present(displayViewController, animated: true, completion: nil)
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate (all about the search bar)
extension SearchViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    //The text field calls this method whenever the user taps the return button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    //Asks the delegate whether to stop editing in the specified text field.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Name of Anime"
            return false
        }
    }
    //Tells the delegate when editing stops for the specified text field.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let animeTitle = textField.text {
            dataManager.reformatTitle(oldFormat: animeTitle)
        }
        searchTextField.text = ""
    }
}
