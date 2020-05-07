//
//  SuggestionViewController.swift
//  unBurdenSwift
//
//  Created by catie on 5/6/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SuggestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var suggestionSegment: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addItemButton: UIButton!
    
    
    var limitSection: Suggestion?
    var selectedTrip = TripNSObject()
    var selectedSuggestions = [String]()
    private var tripRef : DocumentReference?
    
    var suggestions = SuggestionList()
    //var locationManager = CLLocationManager()
    var suggestionList : [Suggestion] { //front end for LandmarkList model object
        get {
            return self.suggestions.suggestionList
        }
        set(val) {
            self.suggestions.suggestionList = val
        }
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "suggcell")
        tripRef = Firestore.firestore().collection("triplist").document(selectedTrip.getId())

        // Do any additional setup after loading the view.
        suggestions.suggestionList = Utilities.loadSuggestData()
        //print(suggestions.suggestionList)
        //print(suggestions)
        //table.reloadData()
        setUpElements()
        
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
                self.selectedSuggestions = unpacked
            }
            self.table.reloadData()
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if limitSection == nil{
            return suggestions.suggestionList.count
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if limitSection == nil{
            let category = suggestions.suggestionList[section]
            //print(category.getSuggestions())
            return category.getSuggestions().count
        }
        else{
            return limitSection!.getSuggestions().count
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = table.cellForRow(at: indexPath){
            guard let text = cell.textLabel!.text else  {return}
            
            if cell.accessoryType == .checkmark{
                //If cell is unclicked we need to remove it from selected
                
                if let index = selectedSuggestions.firstIndex(of: text){
                    selectedSuggestions.remove(at: index)
                }
                cell.accessoryType = .none
            }
            else{
                //If cell is newly clicked we need to add it to selectedSuggestions
                if selectedSuggestions.contains(text) == false{
                    selectedSuggestions.append(text)
                }
                cell.accessoryType = .checkmark
            }
        }
        //print(selectedSuggestions)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var imageString = ""
        var suggText = ""
        
        if limitSection == nil {
            let activeCategory = suggestions.suggestionList[indexPath.section]
            imageString = activeCategory.getImage()
            suggText = activeCategory.getSuggestions()[indexPath.row]
        }
        else{
            imageString = limitSection!.getImage()
            suggText = limitSection!.getSuggestions()[indexPath.row]
            
        }

        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = suggText
        
        if selectedSuggestions.contains(suggText) == true{
            cell.accessoryType = .checkmark
        }
        return cell
         
    }
    
    /*
        Event Action listener
     */
    @IBAction func suggSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            limitSection = nil
        case 1:
            limitSection = getSuggestionByCategory(category: "shelter")
        case 2:
            limitSection = getSuggestionByCategory(category: "clothing")
        case 3:
            limitSection = getSuggestionByCategory(category: "cooking")
        case 4:
            limitSection = getSuggestionByCategory(category: "meals")
        case 5:
            limitSection = getSuggestionByCategory(category: "firstaid")
        case 6:
            limitSection = getSuggestionByCategory(category: "hygiene")
        default:
            limitSection = nil
        }
        
        table.reloadData()
    }
    
    @IBAction func addItemSelected(_ sender: Any) {
        let db = Firestore.firestore()
        let tripId = selectedTrip.getId()
        print(tripId)
        db.collection("triplist").document(tripId).updateData([
            "toPack": selectedSuggestions]){ err in
                if let err = err{
                    print("Error updateing document: \(err)")
                }
                
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
        Supplementary Functions
     */
    func set(inTrip: TripNSObject){
        selectedTrip = inTrip
    }
    func getSuggestionByCategory(category: String) -> Suggestion{
        var finalSug = Suggestion()
        
        for sugItem in suggestions.suggestionList{
            if sugItem.getCategory() == category{
                finalSug = sugItem
            }
        }
        return finalSug
    }
    
    func setUpElements(){
        view.backgroundColor = .white
        navigationItem.title = "Select Items Needing Packing"
        //self.registerTableViewCells()
        table.reloadData()
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
