//
//  ViewController.swift
//  expensesApp
//
//  Created by Juan Mancilla on 7/15/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class ViewController: UIViewController , GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil  {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                //
                if let result = result, error == nil {
                    self.email = result.user.email!
                    print("Login exitoso")
                    print(result.user.uid)
                    let usuario = ["photoURL": result.user.photoURL?.absoluteString, "displayName" : result.user.displayName, "email": result.user.email, "sex": " ", "age":" ", "photoID":" ","DNI": " "]
                 
                    let ref = Database.database().reference()
                    ref.child("usuarios").child(result.user.uid).observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.exists(){
                         print("El registro existe y no se necesita agregar nuevamente")
                        }else{
                            print("El registro no existe y se registra")
                        Database.database().reference().child("usuarios").child(result.user.uid).setValue(usuario)
                        }
                    }
              
        
                    
                    self.performSegue(withIdentifier: "defaultsSegue", sender: self.email)
                }else{
                    //Error popping an alert
                    let alertController = UIAlertController(title: "Error", message: "Credenciales incorrectas.", preferredStyle: .alert)
                        let btnOK  = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                             self.dismiss(animated: true, completion: nil)
                         }
                         alertController.addAction(btnOK)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

    }

    //Outlet creation
    @IBOutlet weak var googleButton: UIButton!
    var email:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Checking if user has defaults stored
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
            let provider = defaults.value(forKey: "provider") as? String {
            self.email = email
            self.performSegue(withIdentifier: "defaultsSegue", sender: provider)
        }
        
        //Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    //Action creations for buttons
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    //Sending data to home controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "defaultsSegue"{
            let siguienteVC = segue.destination as! HomeViewController
            siguienteVC.email = sender as! String
            siguienteVC.provider = .google
        }
    }
    
}

/* Tutorial deprecated not working
extension AuthViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                //
                if let result = result, error == nil {
                    self.email = result.user.email!
                    print("Login exitoso")
                    self.performSegue(withIdentifier: "defaultsSegue", sender: self.email)
                }else{
                    //Error popping an alert
                    let alertController = UIAlertController(title: "Error", message: "Credenciales incorrectas.", preferredStyle: .alert)
                        let btnOK  = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                             self.dismiss(animated: true, completion: nil)
                         }
                         alertController.addAction(btnOK)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
 */

