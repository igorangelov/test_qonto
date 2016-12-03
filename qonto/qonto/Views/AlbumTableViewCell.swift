//
//  AlbumTableViewCell.swift
//  qonto
//
//  Created by Igor Angelov on 02/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumTitleLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var albumViewModel : AlbumViewModel?{
        didSet{
            guard let albumVM = albumViewModel else { return }
            self.albumTitleLabel.text = albumVM.titleText
        }
    }
    
}
