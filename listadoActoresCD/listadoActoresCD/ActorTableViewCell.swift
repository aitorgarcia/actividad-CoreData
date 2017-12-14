//
//  ActorTableViewCell.swift
//  listadoActoresCD
//
//  Created by Aitor Garcia on 13/12/17.
//  Copyright © 2017 Aitor García Luiz. All rights reserved.
//

import UIKit

class ActorTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nombreActorLB: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
