//
//  FavoriteViewController.swift
//  Ganime
//
//  Created by Brian Rosales on 4/13/23.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var models: [basicSeriesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoriteSeries()
        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }
    
    func fetchFavoriteSeries() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Series>(entityName: "Series")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let nameValue = result.name {
                        if let imageValue = result.image {
                            let uiImage: UIImage = UIImage(data: imageValue) ?? UIImage(named: "Ganime")!
                            models.append(basicSeriesModel(name: nameValue, image: uiImage))
                        }
                    }
                }
            } catch {
                print("No Info")
            }
        }
    }
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let curSeries = models[indexPath.row]
            container.viewContext.delete(curSeries)
            commits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            saveContext()
        }
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier") as? CustomCell {
            cell.configureCell(series: models[indexPath.row])
            return cell
              }
           return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        models.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    @IBAction func didTapSort() {
        if table.isEditing {
            table.isEditing = false
        } else {
            table.isEditing = true
        }
    }
}
