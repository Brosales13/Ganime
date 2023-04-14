//
//  CustomCell.swift
//  Ganime
//
//  Created by Brian Rosales on 4/14/23.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var cellLabel:UILabel!
    @IBOutlet weak var cellImage:UIImageView!
    
    func configureCell(series: basicSeriesModel) {
        cellLabel.text = series.name
       cellImage.image = series.image
    }
}
