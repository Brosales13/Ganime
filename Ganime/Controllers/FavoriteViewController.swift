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
    var models: [NSManagedObject] = []
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoriteSeries()
        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }
    
    func fetchFavoriteSeries() {
        DispatchQueue.main.async {
            self.context.performAndWait {
                // Setup a fetchRequest
                let fetchRequest = Series.fetchRequest()
                
                //Update money array with the new data
                self.models = try! self.context.fetch(fetchRequest)
            }
            self.table.reloadData()
        }
    }
    
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let objectToRemove = self.models[indexPath.row]
            self.context.delete(objectToRemove)
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
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
