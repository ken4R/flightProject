//
//  StandardTableViewCell.swift
//  FlightCoreData
//
//  Created by Ken 4B on 23/07/2020.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import UIKit

class StandardTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
