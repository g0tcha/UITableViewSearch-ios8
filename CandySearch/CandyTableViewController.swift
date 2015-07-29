//
//  CandyTableViewController.swift
//  CandySearch
//
//  Created by Vincent GROSSIER on 14/07/2015.
//  Copyright (c) 2015 Kodappy. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    var resultSearchController = UISearchController()
    var selectedScope = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sample Data for candyArray
        self.candies = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
            controller.searchBar.delegate = self
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            let controller = segue.destinationViewController as! UIViewController
            let candy: Candy
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                
                if resultSearchController.active {
                    candy = filteredCandies[indexPath.row]
                } else {
                    candy = candies[indexPath.row]
                }
                
                controller.title = candy.name
            }
            
            if (self.resultSearchController.active) {
                self.resultSearchController.active = false
            }
        }
    }
    
    // MARK - Helpers methods
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredCandies = self.candies.filter({( candy: Candy ) -> Bool in
            var categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    // MARK: - TableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredCandies.count
        } else {
            return self.candies.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let candy: Candy
        if (self.resultSearchController.active) {
            candy = self.filteredCandies[indexPath.row]
        } else {
            candy = self.candies[indexPath.row]
        }
        
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    // MARK: - UISearchControllerDelegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredCandies.removeAll(keepCapacity: false)
        filterContentForSearchText(searchController.searchBar.text, scope: selectedScope)
        
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            self.selectedScope = "All"
            break
        case 1:
            self.selectedScope = "Chocolate"
            break
        case 2:
            self.selectedScope = "Hard"
            break
        case 3:
            self.selectedScope = "Other"
            break
        default:
            self.selectedScope = "All"
            break
        }
    }

}
