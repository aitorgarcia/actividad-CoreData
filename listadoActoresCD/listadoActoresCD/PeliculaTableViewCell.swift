//
//  PeliculaTableViewCell.swift
//  listadoActoresCD
//
//  Created by Aitor Garcia on 13/12/17.
//  Copyright © 2017 Aitor García Luiz. All rights reserved.
//

import UIKit

class PeliculaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tituloPeliculaLB: UILabel!
    @IBOutlet weak var anioPeliculaLB: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
