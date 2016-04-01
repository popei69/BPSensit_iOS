//
//  DeviceCell.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 13/03/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
