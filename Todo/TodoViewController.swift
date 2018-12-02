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

    var itemArray = ["Get out", "Buy chocolate", "Get some good sleep"]
    
    let  defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // populate the saved array from usersDefaults
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print(itemArray[indexPath.row])
        
        // add/remove checkmark for selected row
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
            { tableView.cellForRow(at: indexPath)?.accessoryType = .none }
        else
            { tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark }
        
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
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray") // save to users defaults
            self.tableView.reloadData()
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
    
}

