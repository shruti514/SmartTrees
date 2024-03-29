//
//  NearbyLocationsViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/29/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import GoogleMaps
//import GoogleDirections



class NearbyLocationsViewController: UIViewController ,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    var placesClient: GMSPlacesClient?
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 1000
    var routeIndex: Int = 0
    
    @IBOutlet weak var drivingDirections: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    
    var myLocation:CLLocationCoordinate2D!
    var markerLocation:GooglePlace!
    var rvc : SWRevealViewController!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    
    private var directionsAPI: GoogleDirections {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).directionsAPI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
       // rvc = self.revealViewController() as SWRevealViewController
        
      //  self.view.addGestureRecognizer(rvc.panGestureRecognizer())
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openSlideMenu(sender: AnyObject) {
        //rvc.pushFrontViewController(slideViewController, animated: true)
        rvc.revealToggle(self)
    }
    
    @IBAction func renderHome(sender: AnyObject) {
        
        
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        fetchNearbyPlaces(mapView.camera.target)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Types Segue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! TypesTableViewController
            controller.selectedTypes = searchedTypes
            controller.delegate = self
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            self.addressLabel.unlock()
            if let address = response?.firstResult() {
                let lines = address.lines! 
                self.addressLabel.text = lines.joinWithSeparator("\n")
                let labelHeight = self.addressLabel.intrinsicContentSize().height
               
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,
                    bottom: labelHeight, right: 0)
                
                UIView.animateWithDuration(0.25) {
                    //self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
                    self.view.layoutIfNeeded()
                }            }
        }
    }
    
    @IBAction func handleDirectionModeChange(sender: AnyObject) {
        calculateDirection(myLocation,to: markerLocation.coordinate)
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                let marker = LocationMarker(place: place)
                marker.map = self.mapView
            }
        }
    }
    
    func updateRoutes(results:[GoogleDirectionsRoute]) {
       //mapView.clear()
        for i in 0 ..< (results).count {
            if i != routeIndex {
                results[i].drawOnMap(mapView, strokeColor: UIColor.lightGrayColor(), strokeWidth: 3.0)
            }
        }
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(results[routeIndex].bounds!, withPadding: 150.0))
        let mode = modeFromField()
        if(mode == .Transit){
            results[routeIndex].drawOnMap(mapView, strokeColor: UIColor.brownColor(), strokeWidth: 4.0)
        }
        if(mode == .Walking){
            results[routeIndex].drawOnMap(mapView, strokeColor: UIColor.purpleColor(), strokeWidth: 4.0)
        }
        if(mode == .Driving){
            results[routeIndex].drawOnMap(mapView, strokeColor: UIColor.orangeColor(), strokeWidth: 4.0)
        }
        if(mode == .Bicycling){
            results[routeIndex].drawOnMap(mapView, strokeColor: UIColor.blueColor(), strokeWidth: 4.0)
        }
        
        results[routeIndex].drawOriginMarkerOnMap(mapView, title: "Origin", color: UIColor.greenColor(), opacity: 1.0, flat: true)
        results[routeIndex].drawDestinationMarkerOnMap(mapView, title: "Destination", color: UIColor.redColor(), opacity: 1.0, flat: true)
    }
    
    func calculateDirection(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D){
        directionsAPI.delegate = self
		directionsAPI.from = Location.CoordinateLocation(from)
		directionsAPI.to = Location.CoordinateLocation(to)
		directionsAPI.mode = modeFromField()
        directionsAPI.calculateDirections { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch response {
                case let .Error(_, error):
                    let alert = UIAlertController(title: "GoogleDirectionsSample", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                case let .Success(_, routes):
                    self.updateRoutes(routes)
                }
            })
        }}
    
    
    
    func  showPopup(){
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("DirectionTypes"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(500,600)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(100,100,0,0)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    private func modeFromField() -> GoogleDirectionsMode {
        return GoogleDirectionsMode(rawValue: drivingDirections.selectedSegmentIndex)!
    }
    
    
    @IBAction func getCurrentPlace(sender: UIButton) {
        
        placesClient?.currentPlaceWithCallback({
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress!.componentsSeparatedByString(", ")
                        .joinWithSeparator("\n")
                }
            }
        })
    }
    
}


// MARK: - TypesTableViewControllerDelegate
extension NearbyLocationsViewController: TypesTableViewControllerDelegate {
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
        fetchNearbyPlaces(mapView.camera.target)
        searchedTypes = controller.selectedTypes.sort()
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension NearbyLocationsViewController:MarkerInfoViewDelegate{
    func getDirections() {
        calculateDirection(myLocation,to: markerLocation.coordinate)
    }
}

extension NearbyLocationsViewController: GoogleDirectionsDelegate {
    func googleDirectionsWillSendRequestToAPI(googleDirections: GoogleDirections, withURL requestURL: NSURL) -> Bool {
        NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
        return true
    }
    
    func googleDirectionsDidSendRequestToAPI(googleDirections: GoogleDirections, withURL requestURL: NSURL) {
        NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
        NSLog("\(requestURL.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)")
    }
    
    func googleDirections(googleDirections: GoogleDirections, didReceiveRawDataFromAPI data: NSData) {
        NSLog("googleDirections:didReceiveRawDataFromAPI:")
        NSLog(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
    }
    
    func googleDirectionsRequestDidFail(googleDirections: GoogleDirections, withError error: NSError) {
        NSLog("googleDirectionsRequestDidFail:withError:")
        NSLog("\(error)")
    }
    
    func googleDirections(googleDirections: GoogleDirections, didReceiveResponseFromAPI apiResponse: [GoogleDirectionsRoute]) {
        NSLog("googleDirections:didReceiveResponseFromAPI:")
        NSLog("Got \(apiResponse.count) routes")
        for i in 0 ..< apiResponse.count {
            NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
        }
    }
}


extension NearbyLocationsViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
        if (gesture) {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    
    func mapView(mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let placeMarker = marker as! LocationMarker
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            
            infoView.nameLabel.text = placeMarker.location.name
            infoView.placeAddress.text = placeMarker.location.address
            markerLocation = placeMarker.location
            if let photo = placeMarker.location.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
          
            calculateDirection(myLocation,to: placeMarker.location.coordinate)
            
            
            return infoView
        } else {
            return nil
        }
    }
}

extension NearbyLocationsViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchNearbyPlaces(location.coordinate)
            myLocation = location.coordinate
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}



