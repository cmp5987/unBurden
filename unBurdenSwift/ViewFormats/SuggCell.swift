//
//  SuggCell.swift
//  unBurdenSwift
//
//  Created by catie on 5/6/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit

class SuggCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    func configureSuggCell(imageString: String, sugg: String){
        cellLabel.text = sugg
        cellImage.image = UIImage(named: imageString)
    }
    

}
