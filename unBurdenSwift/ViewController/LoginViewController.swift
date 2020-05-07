//
//  LoginViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/3/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //emailTextField.delegate = self
        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    

    /*
        Supplementary Function
     */

    func setUpElements(){
        //hide error label
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {

        //Check all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        
        }
        return  nil
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        //Programatically change rootcontroller to welcome
        //Programatically change rootcontroller to welcome
        /*let newStoryBoard = UIStoryboard(name: "TripListStoryboard", bundle: nil)
        
        let homeViewController = newStoryBoard.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? TripListTableViewController
        
        view.window?.rootViewController = homeViewController
        //this shows home as the new view controller
        view.window?.makeKeyAndVisible()
        */
        
        //let sceneDelegate = UIApplication.shared.delegate as! SceneDelegate
        let newStoryBoard = UIStoryboard(name: "TripListStoryboard", bundle: nil)
        let homeViewController = newStoryBoard.instantiateViewController(identifier: "HomeVC") as! TripListTableViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        //sceneDelegate.window!.rootViewController = nav
        view.window?.rootViewController = nav
        view.window?.makeKeyAndVisible()
    }
    
    /*
        Objc supported methods
     */
    
    @objc func keyboardWillChange(notification: Notification){
        
        view.frame.origin.y = -300
    }
    
    /*
        Event Action Listener
     */
    
    @IBAction func signInTapped(_ sender: Any) {
        //Check Auth
        //Validate Text Fields
        let error = validateFields()
        
        if error != nil {
            //there was an error, show error message
            showError(error!)
        }
        else{
            let email =  emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign in User
            Auth.auth().signIn(withEmail: email, password: password){ (result, err) in
                if err != nil{
                    //Couldn't sign in
                    self.showError(err!.localizedDescription)
                }
                else{
                    //check if user is in database incase error occured saving them, create new
                    
                    //sign in successful
                    UserDefaults.standard.set(result!.user.uid, forKey:"uid")
                    self.transitionToHome()
                }
            }
        }
    }
    
}
