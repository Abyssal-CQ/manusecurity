//
//  PurchaseListViewController.swift
//  expensesApp
//
//  Created by Juan Mancilla on 7/16/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import Firebase

class PurchaseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var reportes:[Reporte] = []
    
    //Table view implementations ----------------------
    @IBOutlet weak var tablaReportes: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reportes.count == 0 {
            return 1
        }else{return reportes.count}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if reportes.count == 0{
            cell.textLabel?.text = "No se han generado reportes."
            cell.detailTextLabel?.text = " "
        }else{
            let reporte = reportes[indexPath.row]
            cell.textLabel?.text = reporte.description
            cell.detailTextLabel?.text = reporte.type
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reporte = reportes[indexPath.row]
        performSegue(withIdentifier: "verReporteSegue", sender: reporte)
    }
    //---------------END table view methods -----------//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaReportes.delegate = self
        tablaReportes.dataSource = self
        Database.database().reference().child("reportes").observe(DataEventType.childAdded, with: {(snapshot) in
            let reporte = Reporte()
            reporte.description = (snapshot.value as! NSDictionary)["description"] as! String
            reporte.distanceFromEvent = (snapshot.value as! NSDictionary)["distanceFromEvent"] as! String
            reporte.imageURL = (snapshot.value as! NSDictionary)["imageURL"] as! String
            reporte.largeDescription = (snapshot.value as! NSDictionary)["largeDescription"] as! String
            reporte.type = (snapshot.value as! NSDictionary)["type"] as! String
            reporte.latitud = (snapshot.value as! NSDictionary)["lattitude"] as! String
            reporte.longitud = (snapshot.value as! NSDictionary)["longitude"] as! String
            reporte.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
            reporte.audioURL = (snapshot.value as! NSDictionary)["audioURL"] as! String
            self.reportes.append(reporte)
            self.tablaReportes.reloadData()
        })//End dataBase fetch
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "verReporteSegue"{
            let siguienteVC = segue.destination as! SingleReportViewController
            siguienteVC.reporte = sender as! Reporte
        }
    }



}
