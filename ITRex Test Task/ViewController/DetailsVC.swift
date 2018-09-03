//
//  DetailsVC.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 30.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var photo: Photo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        if let photo = photo {
            if let photoData = photo.photoData {
                self.imageView.image = UIImage(data: photoData)
            }
        }
    }
}
