//
//  TripListCell.swift
//  unBurdenSwift
//
//  Created by catie on 5/5/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation
import UIKit

class TripListCell: UITableViewCell{

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureTripCell(trip: TripNSObject){
        cellLabel.text = trip.getName()
        cellImage.image = UIImage(named: "tent")
        
    }
    
}
