//
//  ReciptElememtTableViewCell.swift
//  ProjectFoodApp
//
//  Created by Rupika on 2020-05-31.
//  Copyright © 2020 Rupika. All rights reserved.
//

import UIKit

class ReciptElememtTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var mealNameValue : UILabel!
    
    @IBOutlet weak var skvValue : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
