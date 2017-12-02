//
//  LoginViewController.swift
//  Live Playlist
//
//  Created by Alejandro Cano on 10/26/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController{

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rectangleBackground: UIView!
    @IBOutlet weak var fbLogInBttn: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(FIRAuth.auth()?.currentUser?.email)
    
        // Customization
        rectangleBackground.layer.cornerRadius = 10.0
        fbLogInBttn.layer.cornerRadius = 24.0
        logInButton.layer.cornerRadius = 24.0
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.black.cgColor
        
    }

    @IBAction func facebookLogInButton(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print(error!)
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("Something went wrong with our FB user:", error ?? "")
                return
            }
            print("Successfully logged in with our user:", user ?? "")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        })
    }
    
    // Login with username and password
    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            if segmentControl.selectedSegmentIndex == 0 // Login user
            {
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    if user != nil
                    {
                        // Sign in successful
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    }
                })
            }
            else // Sign up user
            {
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error) in
                    if user != nil
                    {
                        guard let uid = user?.uid else {
                            return
                        }
                        
                        // Sign up successful
                        let ref = FIRDatabase.database().reference()
                        let usersReference = ref.child("Users").child(uid)
                        let values = ["email": self.emailTextField.text]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                            else
                            {
                                print("Saved user successfully")
                            }
                        })
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    }
                })
            }
        }
        
        //self.performSegue(withIdentifier: "loginSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
