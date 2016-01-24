//
//  ViewController.swift
//  Troo
//
//  Created by Emil Shirima on 12/19/15.
//  Copyright © 2015 Emil Shirima. All rights reserved.
//

import UIKit
import AVKit
import Parse
import MapKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, AVAudioPlayerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recordBtn: UIButton!
    
    let mapZoomInFactor: CLLocationDegrees = 0.5
    let locationManager = CLLocationManager()
    let animationDuration : NSTimeInterval = 5.50
    
    var localSearchCurrentLocation: String = String()
    public var lastAttemptAtLocation = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 46 / 255.0, green: 47 / 255.0, blue: 54 / 255.0, alpha: 1.0)
        self.mapView.backgroundColor = UIColor(red: 46 / 255.0, green: 47 / 255.0, blue: 54 / 255.0, alpha: 1.0)
        recordBtn.titleLabel?.textColor = UIColor.whiteColor()
        self.searchBar.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //TODO: Handle the scenario when the user has denied authorization
        //TODO: Include background as well?
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locations.count > 0
        {
            let currentLocation = locations.last
            
            let centre = CLLocationCoordinate2D(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
            
            let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: mapZoomInFactor, longitudeDelta: mapZoomInFactor))
            
            self.mapView.setRegion(region, animated: true)
            
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        //TODO: Add an alert about the location manager failure
        print("Location Manager Update Error \(error.userInfo)")
        print("Localized Description Error Message: \(error.localizedDescription)")
    }
    
    func searchBarSearchButtonClicked(_searchBar: UISearchBar)
    {
        self.mapView.showsUserLocation = false
        
        if self.mapView.annotations.count > 0
        {
            removeMapAnnotations()
        }
//         self.searchBar.resignFirstResponder()
        self.view.endEditing(true) // retracts the keyboard after address entry
        
        let localSearchRequest: MKLocalSearchRequest = MKLocalSearchRequest()

        localSearchRequest.naturalLanguageQuery = self.searchBar.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler { (localSearchResponse: MKLocalSearchResponse?, error: NSError?) -> Void in
            if error == nil
            {
                var pointAnnotations = [MKAnnotation]()
                
                for (var i = 0; i < localSearchResponse?.mapItems.count; ++i)
                {
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.title = localSearchResponse?.mapItems[i].name
                    
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: (localSearchResponse?.mapItems[i].placemark.coordinate.latitude)!, longitude: (localSearchResponse?.mapItems[i].placemark.coordinate.longitude)!)
                    
                   pointAnnotations.append(pointAnnotation)
                }
                
                print("Size: \(pointAnnotations.count)")
                
//                let pointAnnotation = MKPointAnnotation()
//                pointAnnotation.title = localSearchResponse?.mapItems.last?.name
//                
//                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: (localSearchResponse?.mapItems.last?.placemark.coordinate.latitude)!, longitude: (localSearchResponse?.mapItems.last?.placemark.coordinate.longitude)!)
//                
//                //TODO: Add a cool animation possibly for the zooming out and in?
//                //TODO: Include an adress auto-completion
//                self.mapView.centerCoordinate = pointAnnotation.coordinate
//                self.mapView.addAnnotation(pointAnnotation)
//                self.mapView.setRegion(MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: self.mapZoomInFactor, longitudeDelta: self.mapZoomInFactor)), animated: true)
                
                self.mapView.addAnnotations(pointAnnotations)
                
//                self.mapView.setRegion(MKCoordinateRegion(center: (pointAnnotations.last?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: self.mapZoomInFactor, longitudeDelta: self.mapZoomInFactor)), animated: true)
                
                UIView.animateWithDuration(self.animationDuration)
                {
                    self.mapView.setRegion(MKCoordinateRegion(center: (pointAnnotations.last?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: self.mapZoomInFactor, longitudeDelta: self.mapZoomInFactor)), animated: true)
                }
                
//                self.mapView.setRegion(MKCoordinateRegion(center: pointAnnotations.coordinate, span: MKCoordinateSpan(latitudeDelta: self.mapZoomInFactor, longitudeDelta: self.mapZoomInFactor)), animated: true)
                
                print("Number of addresses: \(localSearchResponse?.mapItems.count)")
                
//                print(localSearchResponse?.mapItems)
                
//                self.localSearchCurrentLocation = (localSearchResponse?.mapItems.last?.placemark.name)!
            }
            else
            {
                //TODO: Create an alert about the search failing
                print("Search Failed: \(error?.localizedDescription)")
                print("Seach Failed User Info: \(error?.userInfo)")
                return
            }
        }
        
    }
    
    func removeMapAnnotations()
    {
        let allMapAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allMapAnnotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("identifier")
        
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("identifier") as! MKAnnotationView
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "Restaurant Pickup-32")
            annotationView?.rightCalloutAccessoryView = UIButton(type: .InfoLight)
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("identifier") as? MKPinAnnotationView
//        if annotationView == nil
//        {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
//            annotationView?.canShowCallout = true
//            annotationView?.image = UIImage(named: "Restaurant Pickup-50")
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .InfoLight)
//        }
//        else
//        {
//            annotationView?.annotation = annotation
//        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        print("Call Out Triggered")
        
        if control == view.rightCalloutAccessoryView
        {
            performSegueWithIdentifier("segueToTVC", sender: view)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Sends you to the table view
        if (segue.identifier == "segueToTVC" )
        {
            let destinationTVC = segue.destinationViewController as! FeedBackTableVC
            
            destinationTVC.title = (sender as! MKAnnotationView).annotation!.title!
            destinationTVC.currentLocation = destinationTVC.title!
            lastAttemptAtLocation = destinationTVC.currentLocation
        }
        
        if (segue.identifier == "segueToRVC") // Sends you to the recording view
        {
            let destinationVC = segue.destinationViewController as! RecordingViewController
            
//            destinationVC.title = (sender as! MKAnnotationView).annotation!.title!
            destinationVC.userSelectedLocation = lastAttemptAtLocation
        }
    }
}