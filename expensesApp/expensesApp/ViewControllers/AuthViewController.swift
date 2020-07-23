//
//  AuthViewController.swift
//  expensesApp
//
//  Created by Juan Mancilla on 7/15/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
//mancor@hotmail.com

class AuthViewController: UIViewController {
    
    //Outlet creation
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    var email:String = ""
    //Action buttons
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let result = result, error == nil {
                    self.email = result.user.email!
                //Database.database().reference().child("usuarios").child(result.user.uid).child("email").setValue(result.user.email)
                    
                    let userData = ["displayName": self.nombreTextField.text!, "email":self.emailTextField.text!, "photoURL":"https://www.1stwallsend.org.uk/wp-content/uploads/2019/08/profile-placeholder-150x150.png", "sex": " ", "age":" ", "photoID":" ","DNI": " "]
                Database.database().reference().child("usuarios").child(result.user.uid).setValue(userData)
                    
                    self.performSegue(withIdentifier: "homeSegue", sender: self.email)
                }else{
                    //Error popping an alert
                    let alertController = UIAlertController(title: "Error", message: "No se puede ingresar es problable que el usuario \(self.emailTextField.text!) ya exista.", preferredStyle: .alert)
                    
                        let btnCancelar  = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                             
                         }
                         alertController.addAction(btnCancelar)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        //Retornar
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "homeSegue"{
            let siguienteVC = segue.destination as! HomeViewController
            siguienteVC.email = sender as! String
            siguienteVC.provider = .basic
    }
        
        

    }

}
