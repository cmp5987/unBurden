//
//  NewTripViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/4/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NewTripViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate  {

    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripLocationTextField: UITextField!
    @IBOutlet weak var tripDescTextView: UITextView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createTripButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        self.tripNameTextField.delegate = self
        self.tripLocationTextField.delegate = self
        self.tripDescTextView.delegate = self
    }
    
    /*
     
     Supplementary Functions
     
     */
    func setUpElements(){
        //hide error label
        errorLabel.alpha = 0
    }
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        if tripNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tripLocationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tripDescTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
        
            return "Please fill in all fields"
        
        }
        
        /*if startAfterEndDate() == false{
            return "Trip must start before the end date"
        }*/
        
        //No Errors
        return nil
        
    }
    func startAfterEndDate() -> Bool? {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
        let startDate = dateFormater.string(from: startDatePicker.date)
        print(startDate)
        
        let endDate = dateFormater.string(from: endDatePicker.date)
        
        if startDate.compare(endDate) == .orderedDescending{
            //startDate is smaller than end date
            return false
        }
        else{
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        textView.resignFirstResponder()
        return false
    }

    
    
    /*
     
     Obj C Functions
     
     */
    
    /*
     
     Event Listeners
     
     */
    
    @IBAction func createButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
            //write a pop up alert
        }
        else{
            print("In Tapped Create Button and no Errors")
            let tripName = tripNameTextField.text!
            let tripLocation = tripLocationTextField.text!
            let tripDesc = tripDescTextView.text!
            let startDate = startDatePicker.date
            let endDate = endDatePicker.date
            
            //let trip
            
            /*
                This code is used to store in Firestore Database
             */
            
            let db = Firestore.firestore()
            let uid = UserDefaults.standard.string(forKey: "uid")!
            let newDocument = db.collection("triplist").document()
            
            newDocument.setData(["name":tripName, "location":tripLocation,"desc":tripDesc, "start": startDate, "end": endDate, "id": newDocument.documentID, "users":[uid], "toPack":[], "packed":[]])
            //newDocument.setData(["name":tripName, "location":tripLocation,"desc":tripDesc, "start": startDate, "end": endDate, "id": newDocument.documentID, "users":[uid]])
            
            let userDocument = db.collection("users").document(uid)
            userDocument.updateData([
                "trips": FieldValue.arrayUnion([newDocument.documentID])
            ])
            
            self.navigationController?.popToRootViewController(animated: true)
            
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
