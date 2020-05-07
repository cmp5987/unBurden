//
//  SignUpViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/3/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        //Programatically change rootcontroller to welcome
        /*let newStoryBoard = UIStoryboard(name: "TripListStoryboard", bundle: nil)
        
        let TripListViewController = newStoryBoard.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? TripListTableViewController
        
        view.window?.rootViewController = TripListViewController
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
    
    func validateFields() -> String? {

        //Check all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            checkPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please fill in all fields"
        
        }
        //Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedCheck = checkPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure you have eight characters, a number, and special chracter"
        }
        
        if cleanedPassword != cleanedCheck {
            return "Plese make sure that your password is the same in both fields."
        }
        
        return  nil
    }
    
    /*
     
        Objc supported methods
     
     */
    
    @objc func keyboardWillChange(notification: Notification){
        
        view.frame.origin.y = -300
    }
    
    /*
     
        Event Action Listeners
     
     */
    
    @IBAction func createAccountTapped(_ sender: Any) {
        //Check Email Validation
        let error = validateFields()
        
        if error != nil {
            //there was an error, show error message
            showError(error!)
        }
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            Auth.auth().createUser(withEmail: email, password: password) { (results, err) in
             //check for errors
                if err != nil{
                    self.showError("Error Creating User")
                }
                else{
                    //User was created sucessfully
                    let db = Firestore.firestore()
                        db.collection("users").document(results!.user.uid).setData(["email":email, "uid":results!.user.uid, "trips":[]]) { (error) in
                            
                            if error != nil {
                                //even if error occurs here, user would be still created sucessfully
                                self.showError("User was creted but User data was not stored.")
                            }
                        }
                        //store localuser for reference
                        UserDefaults.standard.set(results!.user.uid, forKey:"uid")
                        //transition to home screen
                        self.transitionToHome()
                        
                }
            }
        }
    }

}
