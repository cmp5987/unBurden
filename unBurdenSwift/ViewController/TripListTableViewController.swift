//
//  TripListTableViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/3/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class TripListTableViewController: UITableViewController {


    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var addTripButton: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    
    
   //variables
    private var trips = [TripNSObject]()
    private var tripIds = [String]()
    private var uid = UserDefaults.standard.string(forKey: "uid")
    private var tripCollRef : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripCollRef = Firestore.firestore().collection("triplist")
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        tripCollRef.getDocuments { (snapshot, error) in
            if let err = error {
                print("Error fetching docs: \(error)")
            }
            else{
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let tripData = document.data()
                    let documentId = document.documentID
                    let users = tripData["users"] as? Array<String> ?? []
                    
                    if self.tripIds.contains(documentId) == false{

                        if users.contains(self.uid!){
    
                            //trip is one that we need to show
                            let name = tripData["name"] as? String ?? "Undefined"
                            let location = tripData["location"] as? String ?? "No Location Specified"
                            let startDate = tripData["start"] as? Date ?? Date()
                            let endDate = tripData["end"] as? Date ?? Date()
                            let desc = tripData["desc"] as? String ?? "Missing a description"
                            let id = tripData["id"] as? String ?? "Missing trip id"
                            let toPack = tripData["toPack"] as? Array<String> ?? []
                            let packed = tripData["packed"] as? Array<String> ?? []

                            
                            let newTrip = TripNSObject(name: name, location: location, startDate: startDate, endDate: endDate, desc: desc, id: documentId, users: users, toPack: toPack, packed: packed)
                            //let newTrip = TripNSObject(name: name, location: location, startDate: startDate, endDate: endDate, desc: desc, id: documentId, users: users)
                            self.trips.append(newTrip)
                            self.tripIds.append(documentId)
                        }
                    }
                }
            }//end of if else
            self.tableView.reloadData()
        }//end get document
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(trips.count)
        return trips.count
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        print("In Logout")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Made it past signOut")
                UserDefaults.standard.set(nil, forKey: "uid")
                transitionToLoginScreen()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
    }

    @IBAction func addTripTapped(_ sender: Any) {
        
    }
    
    func transitionToLoginScreen(){
        //let sceneDelegate = UIApplication.shared.delegate as! SceneDelegate
        let newStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let starterViewController = newStoryBoard.instantiateViewController(identifier: "StarterVC") as! StarterViewController
        let nav = UINavigationController(rootViewController: starterViewController)
        //sceneDelegate.window!.rootViewController = nav
        view.window?.rootViewController = nav
        view.window?.makeKeyAndVisible()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:TripListCell = tableView.dequeueReusableCell(withIdentifier: "tripcell", for: indexPath) as! TripListCell{
            
        
            cell.cellImage.image = UIImage(named: "tent")
            cell.cellLabel.text = trips[indexPath.row].getName()
            
            cell.configureTripCell(trip: trips[indexPath.row])
            return cell
        }
        else{
            let cell: UITableViewCell = UITableViewCell()
            cell.textLabel?.text = "Here I Am"
            return cell
        }

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UITableViewCell{
            let tabBarController = segue.destination as? UITabBarController
            let tripNav = tabBarController?.viewControllers![0] as! UINavigationController
            let toPackNav = tabBarController?.viewControllers![1] as! UINavigationController
            let packedNav = tabBarController?.viewControllers![2] as! UINavigationController
            
            let detailView = tripNav.viewControllers[0] as! TripDetailViewController
            let toPackView = toPackNav.viewControllers[0] as! UnPackedViewController
            let packedView = packedNav.viewControllers[0] as! PackedViewController
            
            let selectedRow = table.indexPathForSelectedRow!.row
            let trip = trips[selectedRow]
            
            detailView.set(inTrip: trip)
            toPackView.set(inTrip: trip)
            packedView.set(inTrip: trip)
            
        }
    }

}
