//
//  CustomCell.swift
//  Ganime
//
//  Created by Brian Rosales on 4/14/23.
//

import Foundation
import UIKit
import CoreData

class CustomCell: UITableViewCell {
    @IBOutlet weak var cellLabel:UILabel!
    @IBOutlet weak var cellImage:UIImageView!
    
    func configureCell(series: NSManagedObject) {
        let seriesName = series.value(forKey: "name") as! String
        let seriesImageData = series.value(forKey: "image") as! Data
        let newImage = UIImage(data: seriesImageData)
        
        cellLabel.text = seriesName
        cellImage.image = newImage
    }
}
