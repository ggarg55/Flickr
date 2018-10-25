//
//  FlickrDescriptionCollectionViewCell.swift
//  Flickr
//
//  Created by Gourav  Garg on 20/10/18.
//  Copyright © 2018 Gourav  Garg. All rights reserved.
//

import UIKit

class FlickrDescriptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    fileprivate let color = UIColor(red: 18/255.0, green: 107/255.0, blue: 251/255.0, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = color
    }
    
    func configureCell() {
        descriptionLabel.text = "Hello India"
    }
}
