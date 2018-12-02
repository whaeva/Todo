//
//  ViewController.swift
//  Todo
//
//  Created by Kaloyan Chanchev on 1.12.18.
//  Copyright © 2018 Kaloyan Chanchev. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController
{

    var itemArray = [Item]() // an array of Item objects (the model Item)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // convert Items array to a plist file
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadItems()
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
    
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // set done, so we can add/remove the checkmark for selected row
        itemArray[indexPath.row].done = itemArray[indexPath.row].done == true ? false : true
        
        saveItems() // save the item to db
        
        // deselect selected row for better user experience
        tableView.deselectRow(at: indexPath, animated: true)
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
        // convert data to .plist
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            // convert from .plist to a items array
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error \(error)")
            }
        }
    }
    
}

