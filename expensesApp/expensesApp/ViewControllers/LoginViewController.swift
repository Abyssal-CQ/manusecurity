//
//  LoginViewController.swift
//  expensesApp
//s
//  Created by Juan Mancilla on 7/15/20.
//  Copyright © 2020 Juan Mancilla. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    //Outlet Declaration

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = usernameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result, error == nil {
                    self.email = result.user.email!
                    self.performSegue(withIdentifier: "homeSegue2", sender: self.email)
                }else{
                    //Error popping an alert
                    let alertController = UIAlertController(title: "Error", message: "Credenciales incorrectas.", preferredStyle: .alert)
                        let btnOK  = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                             
                         }
                         alertController.addAction(btnOK)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        //mancor@hotmail.com
    }
    
    //Sending data to home controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "homeSegue2"{
            let siguienteVC = segue.destination as! HomeViewController
            siguienteVC.email = sender as! String
            siguienteVC.provider = .basic
        }
    }

    
}
