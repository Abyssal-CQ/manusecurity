//
//  SingleReportViewController.swift
//  expensesApp
//
//  Created by Juan Mancilla on 7/20/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit
import AVFoundation

class SingleReportViewController: UIViewController, UITextViewDelegate {

    var audioURL:URL?
    var reporte = Reporte()
    
    //Outlets reference
    @IBOutlet weak var typeTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var distanceTextLabel: UILabel!
    @IBOutlet weak var largeDescriptionTextLabel: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MapKit Outlet Reference
    @IBOutlet weak var mapView: MKMapView!
    func createAnnotations(){
        
        let annotations = MKPointAnnotation()
            annotations.title = reporte.description
            annotations.coordinate = CLLocationCoordinate2D(latitude: Double(reporte.latitud)!, longitude: Double(reporte.longitud)! )
            
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(reporte.latitud)!, longitude: Double(reporte.longitud)!)
        
        let region = MKCoordinateRegion.init(center:coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)

        mapView.addAnnotation(annotations)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createAnnotations()
        
        typeTextLabel.text = reporte.type
        descriptionTextLabel.text = reporte.description
        distanceTextLabel.text = reporte.distanceFromEvent
        largeDescriptionTextLabel.text = reporte.largeDescription
        photoImageView.sd_setImage(with: URL(string: reporte.imageURL), completed: nil)

        
        /*
        let audioID = reporte.audioID
        let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let pathComponents = [basePath, "\(audioID).m4a"]
        
        audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
        print("ESta es la url ",audioURL!)
        */
        //Audio database Fetch
        let url = URL(string: reporte.audioURL)
        loadFiles(url: url!, completion: {(path, error)in
            self.audioURL = URL(string: path!)
            print("Archivos cargados en el path\(path!)")
            print("ESTA es la AUDIO URL", self.audioURL)
        })
        
        
        //TextField Delegate for coloring
        largeDescriptionTextLabel.delegate = self
        largeDescriptionTextLabel.textColor = .lightGray
    }
    
    //---------Audio download and play------
    
    var reproducirAudio:AVAudioPlayer?
    
    
    @IBAction func playAudioActionButton(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: self.audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
            
        }catch{
            
        }
    }
    
    func loadFiles(url: URL, completion: @escaping (String?, Error?) -> Void){
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentURL.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationURL.path){
            print("El archivo ya existe en el path destino")
            completion(destinationURL.path, nil)
        }
        
        else if let dataFromURL = NSData(contentsOf: url){
            
            if dataFromURL.write(to: destinationURL, atomically: true){
                print("Archivo guardado en: \(destinationURL.path)")
                completion(destinationURL.path, nil)
            }else{
                print("Error guardando el archivo")
                let error = NSError(domain: "Error guardando el file", code: 1001, userInfo: nil)
                completion(destinationURL.path, error)
            }
        }
    }//End function


}
