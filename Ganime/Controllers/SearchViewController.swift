//
//  SearchViewController.swift
//  Ganime
//
//  Created by Brian Rosales on 2/9/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var animeTitle = ""
    var dataManager = DataManager()
    var animeModel: AnimeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        dataManager.delegate = self
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult"{
            let destinationVC = segue.destination as! DisplayViewController
            //this is what ties info to displayViewController
            destinationVC.animeModel = animeModel
        }
        
        if segue.identifier == "favorite" {
            guard let vc = segue.destination as? FavoriteViewController else { return }
                
        }
    }
     */
    
    @IBAction func segueButtonPressed(_ sender: Any) {
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
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(self.searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Name of Anime"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let animeTitle = textField.text{
            dataManager.reformatTitle(oldFormat: animeTitle)
        }
        searchTextField.text = ""
    }
}
