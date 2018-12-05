//
//  ViewController.swift
//  Todo
//
//  Created by Kaloyan Chanchev on 1.12.18.
//  Copyright © 2018 Kaloyan Chanchev. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController
{
    var itemArray = [Item]() // an array of Item objects (the model Item)
    
    var selectedCategory : Category? { // load items when selectedCategory is set
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // access the database (coredata). context is the temporary state of db
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // where the sqlite file is saved
    }
    
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    
    //MARK - Add new item section

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        // create uialert when + btn (top-right) is pressed
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        // create action for the alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicked the Add Item btn in the UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems() // save the item to db
        }
        
        // create text field in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // attach the action to the alert
        alert.addAction(action)
        
        // show alert
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK - Model manipulation methods
    
    func saveItems()
    {
        do {
            try context.save()
        }
        catch
        {
            print("Error saving data: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // with is the external param and request is the internal param (same thing, but used external (calling the method) and internal (as property, inside the method)
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data. \(error)")
        }
    }
    
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // set done, so we can add/remove the checkmark for selected row
        itemArray[indexPath.row].done = itemArray[indexPath.row].done == true ? false : true
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        saveItems() // save the item to db
        
        // deselect selected row for better user experience
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK - SearchBar methods
extension TodoViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        // for all the items in the Item array
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // look for the once where the title contains searchBar.text
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // try to fetch the results
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
