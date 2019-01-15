//
//  ViewController.swift
//  Todoey
//
//  Created by Jasmin Laxamana on 1/3/19.
//  Copyright © 2019 17 B.C. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        //this block of code gets called only after selectedCategory has been
        //given a value
        didSet{
            loadItems()
        }
    }
    
    // For CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // For NSCoder use
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        //sets the done property of item, toggles between true or false
        // this is also the 'UPDATE' part of 'CRUD'
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //DELETE operation in CRUD
        //removes the selected item in itemArray and context
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        //makes the selected row go back to white after selecting
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when the user clicks on the Add Item Button on our UIAlert
            print(textField.text!)
            
            
            /////// Uses the CoreData ///////////
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Persists the data into database
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        
        //Adds the item in the tableView
        self.tableView.reloadData()
    }
    
    
    // 'READ' operation in CRUD
    //using the default value Item.fetchRequest(), it allows the user to call
    //this function without a parameter. It fetches all the data with no filter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        /*sets the value of request.predicate to NSCompoundPredicate w/c is [categoryPredicate, additionalPredicate], only if additional predicate is not nil
        */
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

//querying and fetching data from the database
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //filter for the request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //format of the returned data, in this case, sorted
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //this method gets triggered for every character typed in the searchbar
        //only until the user type something in the searchbar that this function will be triggered
        //that's why we need to check the text count in cases that the user typed something
        //and then cancelled it
        if searchBar.text?.count == 0{
            loadItems()//loads all the items with no filter
            
            //updates the state of searchbar in the background
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()//takes away the focus on searchbar
            }
            
        }
        
    }
}

