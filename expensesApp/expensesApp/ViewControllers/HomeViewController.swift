//
//  HomeViewController.swift
//  expensesApp
//
//  Created by Juan Mancilla on 7/15/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

enum ProviderType: String{
    case basic
    case google
}

class HomeViewController: UIViewController {
    
    
  
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var closeSessionButtton: UIButton!
    //Initialization for enum Variable
    var email:String = ""
    var provider:ProviderType = .basic
    init(email: String, provider: ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName:nil, bundle:nil)
    }
    /*
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var usuario = User()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //navigation.setHidesBackButton(true, animated:false)
    Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).observe(DataEventType.value, with: {(snapshot) in
                
                if let value = snapshot.value as? [String:Any]{
                    //print(value["displayName"] as! String)
                    let user = User()
                    user.displayName = value["displayName"] as! String
                    user.email = value["email"] as! String
                    user.photoURL = value["photoURL"] as! String
                    user.uid = Auth.auth().currentUser!.uid
                    user.photoID = value["photoID"] as! String
                    user.edad = value["age"] as! String
                    user.DNI = value["DNI"] as! String
                    self.sentUser = user
                    
                    }
                }//End Snapshot query
        )//End Database query
        
    
        
  
            
        // Storing User data similar to CoreData
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    

    
    
    //Action buttons section
    @IBAction func closeSessionButtonAction(_ sender: Any) {
        //Deleting data once logout happens
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider {
        case .basic:
            firebaseLogOut()
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogOut()
        }
    }
    
    
    @IBAction func newRegistryAction1(_ sender: Any) {
        performSegue(withIdentifier: "newProductSegue", sender: nil)
    }
    
    @IBAction func showPuchaseListAction(_ sender: Any) {
        performSegue(withIdentifier: "purchaseListSegue", sender: nil)
    }
    
    
    var sentUser = User()
    @IBAction func editUserActionTapped(_ sender: Any) {
        let user = self.sentUser
        performSegue(withIdentifier: "editUserSegue", sender: user)
    }
    
    
    @IBAction func showMapsActionButton(_ sender: Any) {
        performSegue(withIdentifier: "mapsSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editUserSegue"{
            let siguienteVC = segue.destination as! EditUserViewController
            siguienteVC.user = sender as! User
        }
    }
 
 

    
    //Externalized logout function for Firebase
    private func firebaseLogOut(){
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "returnSegue", sender: nil)
            
        } catch {
            //Error during logout
        }
    }
    
}
