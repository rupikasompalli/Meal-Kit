//
//  HistoryElementTableViewCell.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-31.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit

class HistoryElementTableViewCell: UITableViewCell {

    
    @IBOutlet weak var historyMeal : UILabel!
    @IBOutlet weak var historyOrderId : UILabel!
    @IBOutlet weak var historyTotal : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
