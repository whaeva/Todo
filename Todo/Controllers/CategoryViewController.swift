//
//  CategoryViewController.swift
//  Todo
//
//  Created by Kaloyan Chanchev on 4.12.18.
//  Copyright © 2018 Kaloyan Chanchev. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController
{
    var categoriesArray = [Category]() // an array of Item objects (the model Item)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // access the database (coredata). context is the temporary state of db
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadItems()
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoriesArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    
    //MARK - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        // create uialert when + btn (top-right) is pressed
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        // create action for the alert
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen when the user clicked the Add Category btn in the UIAlert
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoriesArray.append(newCategory)
            
            self.saveItems() // save the item to db
        }
        
        // create text field in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
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
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do {
            categoriesArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data. \(error)")
        }
    }
    
    
}
