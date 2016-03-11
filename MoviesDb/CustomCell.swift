//
//  CustomCell.swift
//  MoviesDb
//
//  Created by Rodrigo on 3/11/16.
//  Copyright © 2016 Rodrigo. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var genreLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
