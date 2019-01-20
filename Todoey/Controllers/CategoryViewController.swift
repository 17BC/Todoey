//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jasmin Laxamana on 1/12/19.
//  Copyright © 2019 17 B.C. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coalescing, count will be returned if categories is not nil
        //if it is nil, then 1 will be returned
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        
        return cell
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    // Persist the data into database
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving data, \(error)")
        }
        
        //Adds the category in the tableview
        tableView.reloadData()
    }
    //Fetches the data
    func loadCategory(){
//
        categories = realm.objects(Category.self)
    }
    
    //MARK: - Add New Categories

        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //what happens when the user clicks on the Add Category Button on our UIAlert
            
            /////// Uses Realm //////
            let newCategory = Category()
            newCategory.name = textfield.text!
            
            self.save(category: newCategory)
            
        }
        
            alert.addTextField { (alertTextfield) in
                alertTextfield.placeholder = "Create New Category"
            textfield = alertTextfield
        }
        
            alert.addAction(action)
        
            present(alert, animated: true, completion: nil)
        }
    
}
