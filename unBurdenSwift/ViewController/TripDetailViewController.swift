//
//  TripDetailViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/5/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class TripDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedTrip = TripNSObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }

    

    @IBAction func deleteButtonTapped(_ sender: Any) {
        print("In deleteButtonTapped")
        var refreshAlert = UIAlertController(title: "Delete Trip", message: "Are You Sure to Delete this Trip ? ", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteTrip()

        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

            refreshAlert .dismiss(animated: true, completion: nil)


        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    /*
        Supplemental Functions
     */
    func set(inTrip: TripNSObject){
        selectedTrip = inTrip
    }
    func setUpElements(){
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 146/255, green: 189/255, blue: 163/255, alpha: 1)
        
        let start = formatDate(date: selectedTrip.getStartDate())
        let end =  formatDate(date: selectedTrip.getEndDate())
        let fullDate = "\(start) -- \(end)"
        
        nameLabel.text = selectedTrip.getName()
        dateLabel.text = fullDate
        locationLabel.text = selectedTrip.getLocation()
        descTextView.text = selectedTrip.getDesc()
        
        
    }
    func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        print(dateString)
        return dateString
    }
    func transitionToHome(){
        let newStoryBoard = UIStoryboard(name: "TripListStoryboard", bundle: nil)
        let homeViewController = newStoryBoard.instantiateViewController(identifier: "HomeVC") as! TripListTableViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        //sceneDelegate.window!.rootViewController = nav
        view.window?.rootViewController = nav
        view.window?.makeKeyAndVisible()
    }
    func deleteTrip(){
        let db = Firestore.firestore()
        let tripId = selectedTrip.getId()
        let uid = UserDefaults.standard.string(forKey: "uid")!
        
        
        db.collection("triplist").document(tripId).delete() { err in
            if let err = err {
                print("Error remocing document: \(err)")
            }
            else{
                //remove it from the user not just the trip!
                db.collection("users").document(uid).updateData(["trips": FieldValue.arrayRemove([tripId])])
                self.transitionToHome()
            }
        }
    }
    
}

