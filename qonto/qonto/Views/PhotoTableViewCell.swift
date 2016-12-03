//
//  PhotoTableViewCell.swift
//  qonto
//
//  Created by Igor Angelov on 02/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    var viewModel : PhotoViewModel?{
        didSet{
            guard let photoVM = viewModel else { return }
            photoImageView.downloadedFrom(link: photoVM.urlPhoto)
        }
    }
}
