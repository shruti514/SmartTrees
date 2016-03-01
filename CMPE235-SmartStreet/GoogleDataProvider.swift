//
//  GoogleDataProvider.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/29/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

class GoogleDataProvider {
    var photoCache = [String:UIImage]()
    var placesTask: NSURLSessionDataTask?
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func fetchPlacesNearCoordinate_old(coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: (([GooglePlace]) -> Void)) -> ()
    {
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&radius=500&types=food&name=cruise&key=AIzaSyBob-IeBDk1h-1lPGC2Gw_u6pjEkRz59t8", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(String("******RESPONSE*****",response.response)) // URL response
                print(String("******Data*****",response.data))     // server data
                print(String("******Result*****",response.result))   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }

        
    }
    
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: (([GooglePlace]) -> Void)) -> ()
    {
        
        var urlString="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=AIzaSyBob-IeBDk1h-1lPGC2Gw_u6pjEkRz59t8"
        
        //var urlStringold = "http://localhost:10000/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
       // var urlString="http://localhost:8000/nearbyplaces"
        let typesString = types.count > 0 ? types.joinWithSeparator("|") : "food"
        urlString += "&types=\(typesString)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        if let task = placesTask where task.taskIdentifier > 0 && task.state == .Running {
            task.cancel()
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var locationArray = [GooglePlace]()
            if let aData = data {
                let json = JSON(data:aData, options:NSJSONReadingOptions.MutableContainers, error:nil)
                if let results = json["results"].arrayObject as? [[String : AnyObject]] {
                    for rawPlace in results {
                        let place = GooglePlace(dictionary: rawPlace, acceptedTypes: types)
                        locationArray.append(place)
                        if let reference = place.photoReference {
                            self.fetchPhoto(reference) { image in
                                place.photo = image
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(locationArray)
            }
        }
        placesTask?.resume()
    }
    
    
    func fetchPhoto(reference: String, completion: ((UIImage?) -> Void)) -> () {
        if let photo = photoCache[reference] as UIImage? {
            completion(photo)
        } else {
            //https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=AIzaSyBob-IeBDk1h-1lPGC2Gw_u6pjEkRz59t8
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&key=AIzaSyBob-IeBDk1h-1lPGC2Gw_u6pjEkRz59t8&photoreference=\(reference)"
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            session.downloadTaskWithURL(NSURL(string: urlString)!) {url, response, error in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let url = url {
                    let downloadedPhoto = UIImage(data: NSData(contentsOfURL: url)!)
                    self.photoCache[reference] = downloadedPhoto
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(downloadedPhoto)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(nil)
                    }
                }
                }.resume()
        }
    }
}
