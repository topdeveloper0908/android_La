//
//  ProgrammaTableViewCell.swift
//  streamingSong
//
//  Created by Kurt Warson on 02/07/2018.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit

class ProgrammaTableViewCell: UITableViewCell {
    
   
   
    
    @IBOutlet weak var uurLabel: UILabel!
    
    
    @IBOutlet weak var programmaLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
