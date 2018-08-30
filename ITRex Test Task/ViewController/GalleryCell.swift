//
//  GalleryCell.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 29.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var photoPreview: UIImageView!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        photoPreview.contentMode = .scaleAspectFill
    }
    
}
