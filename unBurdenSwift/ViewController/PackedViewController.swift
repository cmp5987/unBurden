//
//  PackedViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/6/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PackedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    //Variables
    var selectedTrip = TripNSObject()
    var packedItems: Array<String> = []
    private var tripRef : DocumentReference?

    
    override func viewDidLoad() {
        super.viewDidLoad()
            //packedItems = selectedTrip.getPacked()
            
            self.table.dataSource = self
            self.table.delegate = self
            self.table.register(UITableViewCell.self, forCellReuseIdentifier: "suggcell")
            tripRef = Firestore.firestore().collection("triplist").document(selectedTrip.getId())
        }
        
    override func viewWillAppear(_ animated: Bool) {
        tripRef?.getDocument(completion: { (snapshot, error) in
            if let err = error {
                print("Error fetching docs: \(error)")
            }
            else{
                guard let document = snapshot else { return }
                let tripData = document.data()
                let packed = tripData!["packed"] as? Array<String> ?? []
                self.selectedTrip.set(toPack: packed)
                self.packedItems = packed
            }
            self.table.reloadData()
        })
    }


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return packedItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellText = ""

        cellText = packedItems[indexPath.row]

        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = cellText
        
        return cell
             
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let itemToRemove = packedItems[indexPath.row]
            tripRef!.updateData([
                "packed": FieldValue.arrayRemove([itemToRemove])
            ])
            
            packedItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }

        
    }

    /*
     
     Supplementary Functions
     
     */
    
    func set(inTrip: TripNSObject){
        selectedTrip = inTrip
        print("Here in: \(selectedTrip)")
    }
    
}

 

