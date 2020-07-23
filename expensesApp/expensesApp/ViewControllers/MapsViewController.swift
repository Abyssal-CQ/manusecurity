//
//  MapsViewController.swift
//  expensesApp
//
//  Created by Juan Mancilla on 7/22/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class MapsViewController: UIViewController {

    @IBOutlet weak var mapsView: MKMapView!
    
    var coordenates: [Coordenate] = []
    
    
    func createAnnotations(){
        for coordinate in self.coordenates{
            let annotation = MKPointAnnotation()
            annotation.title = coordinate.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(coordinate.lattitude)!, longitude: Double(coordinate.longitude)!)
            self.mapsView.addAnnotation(annotation)
        }
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: -16.402174, longitude: -71.517271)
        let region = MKCoordinateRegion.init(center:coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        self.mapsView.setRegion(region, animated: true)
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Database.database().reference().child("coordinates").observe(DataEventType.childAdded, with: {(snapshot) in
            let coordenate=Coordenate()
            coordenate.title = (snapshot.value as! NSDictionary)["title"] as! String
            coordenate.lattitude = (snapshot.value as! NSDictionary)["lattitude"] as! String
            coordenate.longitude = (snapshot.value as! NSDictionary)["longitude"] as! String
            print((snapshot.value as! NSDictionary)["lattitude"] as! String)
            self.coordenates.append(coordenate)
            }//End Snapshot query
        )//End Database query

    }
   */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Database.database().reference().child("coordinates").observe(DataEventType.childAdded, with: {(snapshot) in
            let coordenate=Coordenate()
            coordenate.title = (snapshot.value as! NSDictionary)["title"] as! String
            coordenate.lattitude = (snapshot.value as! NSDictionary)["lattitude"] as! String
            coordenate.longitude = (snapshot.value as! NSDictionary)["longitude"] as! String
            print((snapshot.value as! NSDictionary)["lattitude"] as! String)
            self.coordenates.append(coordenate)
            
            for coordinate in self.coordenates{
                let annotation = MKPointAnnotation()
                annotation.title = coordinate.title
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(coordinate.lattitude)!, longitude: Double(coordinate.longitude)!)
                self.mapsView.addAnnotation(annotation)
            }
            
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: -16.40152, longitude: -71.52817)
            let region = MKCoordinateRegion.init(center:coordinate, latitudinalMeters: 6000, longitudinalMeters: 6000)
            self.mapsView.setRegion(region, animated: true)
            
            }//End Snapshot query
        )//End Database query
        //print(coordenates[0].title)  //NO index found
        //createAnnotations()
        //print(self.coordenates,"AEA")
    }
    



}
