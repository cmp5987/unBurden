//
//  UnPackedViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/6/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UnPackedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var suggList : [Suggestion] = []
    var selectedTrip = TripNSObject()
    var toPackItems: Array<String> = []
    var packedItems: Array<String> = []
    private var tripRef : DocumentReference?

    //@IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var packItemsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                let unpacked = tripData!["toPack"] as? Array<String> ?? []
                self.selectedTrip.set(toPack: unpacked)
                self.toPackItems = unpacked
            }
            self.table.reloadData()
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.table.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.destination)
        let suggestView:SuggestionViewController = segue.destination as! SuggestionViewController
        suggestView.set(inTrip: selectedTrip)
        //print("in this unwanted segue")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toPackItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellText = ""

        cellText = toPackItems[indexPath.row]

        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = cellText
        
        if packedItems.contains(cellText) == true{
            cell.accessoryType = .checkmark
        }
        return cell
             
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = table.cellForRow(at: indexPath){
            guard let text = cell.textLabel!.text else  {return}
            
            if cell.accessoryType == .checkmark{
                //If cell is unclicked we need to remove it from selected
                
                if let index = packedItems.firstIndex(of: text){
                    packedItems.remove(at: index)
                }
                cell.accessoryType = .none
            }
            else{
                //If cell is newly clicked we need to add it to selectedSuggestions
                if packedItems.contains(text) == false{
                    packedItems.append(text)
                }
                cell.accessoryType = .checkmark
            }
        }
        //print(selectedSuggestions)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
    */
    /*
     Action  Listeners
     */
    @IBAction func filterButtonTapped(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func packButtonTapped(_ sender: Any) {
        print("In pack it up")
        let currentlyPacked = selectedTrip.getPacked()
        let currentlyUnPacked = selectedTrip.getToPack()
        let fullUnPacked = Array(Set(currentlyUnPacked).subtracting(packedItems))
        let fullPacked = currentlyPacked + packedItems
        
        tripRef!.updateData([
            "packed": fullPacked]){ err in
                if let err = err{
                    print("Error updateing document: \(err)")
                }
                
        }
        tripRef!.updateData([
            "toPack": fullUnPacked]){ err in
                if let err = err{
                    print("Error updateing document: \(err)")
                }
                
        }
        selectedTrip.set(packed: fullPacked)
        selectedTrip.set(toPack: fullUnPacked)
        
        let otherNav =  (self.navigationController?.tabBarController?.viewControllers![2])! as! UINavigationController as UINavigationController
        let childView = otherNav.viewControllers[0] as! PackedViewController
        childView.set(inTrip: selectedTrip)
        table.reloadData()
        transitionToPacked()
    }
    
    
    /*
     
     Supplementary Functions
     
     */
    func set(inTrip: TripNSObject){
        selectedTrip = inTrip
    }
    func setUpElements(){
        view.backgroundColor = .white
        navigationItem.title = "To-Pack Items"
        //self.registerTableViewCells()
        table.reloadData()
    }
    func transitionToPacked(){
        self.tabBarController?.selectedIndex = 2
    
    }

}
