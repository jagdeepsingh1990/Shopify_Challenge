//
//  TableViewCell.swift
//  Shopify_Challenge
//
//  Created by Jagdeep on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var proviceTitleName: UILabel!
    @IBOutlet weak var ordercounterLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
