//
//  FlickrService.swift
//  Flickr
//
//  Created by Gourav  Garg on 20/10/18.
//  Copyright © 2018 Gourav  Garg. All rights reserved.
//

import UIKit

class FlickrService {
    
    static let shared: FlickrService = FlickrService()
    var images: [UIImage] = []
    var imageDescription: [String] = []
    var flickr: Flickr?
    fileprivate let apiKey = "f6fe6174654e7bd01dc95db8ce683bdb"
    
    //GET Flickr Image API URL
    func flickrURL() -> URL? {
        return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=Historical+Places&format=json&nojsoncallback=1")
    }
    
    //GET Image URL for Flickr Struct Object
    func imageURL(_ photo: Photo) -> URL? {
        if let farm = photo.farm, let server = photo.server, let id = photo.id, let secret = photo.secret {
            let urlString = "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
            if let url = URL(string: urlString) {
                return url
            }
        }
        return nil
    }
    
    //GET Flickr Images for Historical Places.
    func getFlickrImage(success:@escaping ()->(), failure:@escaping (_ message: String)->()) {
        let session = URLSession.shared
        if let url = flickrURL() {
            let request = URLRequest(url: url, cachePolicy:.returnCacheDataElseLoad, timeoutInterval: 50000) //todo change the time
            let task = session.dataTask(with: request) {[weak self] (data, response, error) in
                if error == nil{
                    let status = (response as! HTTPURLResponse).statusCode
                    if status < 200 || status > 300 {
                        failure("Server Error")
                    }
                } else {
                    failure((error?.localizedDescription)!)
                }
                
                guard let data = data else {
                    failure("Data Rresponse is nil")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    self?.flickr = try decoder.decode(Flickr.self, from: data)
                    if self?.flickr?.stat == "fail" {
                        DispatchQueue.main.async {
                            failure("Flickr API Status: Fail")
                        }
                        return
                    }
                    self?.images.removeAll() //TODO: Remove on paging
                    if let flickrPhotos = self?.flickr?.photos?.photo {
                        for photo in flickrPhotos {
                            if let url = self?.imageURL(photo) {
                                guard let imageData = try? Data(contentsOf: url) else {
                                    failure("Image Parsing Error")
                                    return
                                }
                                if let image = UIImage(data: imageData) {
                                    self?.images.append(image)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            success()
                        }
                    } else {
                        failure("Flickr Photos not found")
                    }
                    
                }  catch {
                    failure(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}
