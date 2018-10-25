//
//  FlickrCollectionViewCell.swift
//  Flickr
//
//  Created by Gourav  Garg on 19/10/18.
//  Copyright © 2018 Gourav  Garg. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var flickrImageView: UIImageView!
    @IBOutlet weak private var arrowImageView: UIImageView!
    
    fileprivate let color = UIColor(red: 18/255.0, green: 107/255.0, blue: 251/255.0, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrowImageView.tintColor = .red
        
    }
    
    func configureCell(_ image: UIImage) {
        flickrImageView.image = image
    }
    
    func setBordor(show: Bool) {
        flickrImageView.layer.borderWidth = show ? 2.0 : 0.0
        flickrImageView.layer.borderColor = show ? color.cgColor : UIColor.white.cgColor
        arrowImageView.isHidden = show ? false : true
    }
    
}
