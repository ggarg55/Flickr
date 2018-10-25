//
//  ViewController.swift
//  Flickr
//
//  Created by Gourav  Garg on 18/10/18.
//  Copyright © 2018 Gourav  Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flickrCollectionView: UICollectionView!
    
    fileprivate var isDescriptionShow: Bool = false
    fileprivate var isImageSelected: Bool = false
    fileprivate var selectedImageIndex = -1
    fileprivate var descriptionIndex = -3
    var flickerImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlickrService.shared.getFlickrImage(success: { [weak self] in
            if let strongSelf = self {
                strongSelf.getImages()
            }
        }) {[weak self] (error) in
            self?.displayAlert(error)
        }
        self.flickrCollectionView.showsVerticalScrollIndicator = false
    }
    
    func displayAlert(_ message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImages() {
        if isImageSelected {
            let dummyImage = UIImage()
            flickerImages.insert(dummyImage, at: descriptionIndex)
        } else {
            flickerImages = FlickrService.shared.images
        }
        flickrCollectionView.reloadData()
    }
}


//MARK:- Collection View Data Source and Delegate Methods
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isImageSelected  && indexPath.item == descriptionIndex {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrDescriptionCollectionViewCell", for: indexPath) as! FlickrDescriptionCollectionViewCell
            // selectedImageIndex use for image decription
            cell.configureCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCollectionViewCell", for: indexPath) as! FlickrCollectionViewCell
            cell.configureCell(flickerImages[indexPath.item])
            cell.setBordor(show: selectedImageIndex == indexPath.row ? true : false)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedImageIndex == indexPath.item {
            selectedImageIndex = -1
            isImageSelected = false
            isDescriptionShow = false
        } else {
            selectedImageIndex = indexPath.item
            isImageSelected = true
        }
        if flickerImages.count > FlickrService.shared.images.count {
            flickerImages.remove(at: descriptionIndex)
        }
        getDescriptionIndex()
        getImages()
    }
    
    func getDescriptionIndex() {
        if isImageSelected {
            if isDescriptionShow {
                if selectedImageIndex > descriptionIndex  {
                    selectedImageIndex = selectedImageIndex - 1
                }
            } else {
                isDescriptionShow = true
            }
            if selectedImageIndex % 2 == 0 {
                descriptionIndex = selectedImageIndex + 2
            } else {
                descriptionIndex = selectedImageIndex + 1
            }
        } else {
            descriptionIndex = -3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow = 2.0
        let widthPerItem = self.view.frame.width / CGFloat(itemsPerRow)
        if descriptionIndex == indexPath.item {
            return CGSize(width: 2 * widthPerItem - 15, height: widthPerItem)
        }
        return CGSize(width: widthPerItem - 5, height: widthPerItem)
    }
    
}

