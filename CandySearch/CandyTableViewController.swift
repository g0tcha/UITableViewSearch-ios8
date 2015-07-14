//
//  CandyTableViewController.swift
//  CandySearch
//
//  Created by Vincent GROSSIER on 14/07/2015.
//  Copyright (c) 2015 Kodappy. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchResultsUpdating {
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    var resultSearchController = UISearchController()
    
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
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            println("Hello")
            let controller = segue.destinationViewController as! UIViewController
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.title = candies[indexPath.row].name
            }
            
            if (self.resultSearchController.active) {
                self.resultSearchController.active = false
            }
        }
    }
    
    // MARK - Helpers methods
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredCandies = self.candies.filter({( candy: Candy ) -> Bool in
            let stringMatch = candy.name.rangeOfString(searchText)
            return stringMatch != nil
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
        filterContentForSearchText(searchController.searchBar.text)
        
        tableView.reloadData()
    }

}
