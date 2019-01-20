//
//  ViewController.swift
//  Todoey
//
//  Created by Jasmin Laxamana on 1/3/19.
//  Copyright © 2019 17 B.C. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        //this block of code gets called only after selectedCategory has been
        //given a value
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    //Updating the Data - CRUD
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    //realm.delete(item)//this line deletes the item while the line below toggles
                                      //the check mark of the item
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status. \(error)")
            }
        }
        
        tableView.reloadData()
        
        
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
            
            
            /////// Uses Realm ///////////
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new item, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // 'READ' operation in CRUD
    //using the default value Item.fetchRequest(), it allows the user to call
    //this function without a parameter. It fetches all the data with no filter
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()
    }
    
    
}

//querying and fetching data from the database
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()

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

