//
//  ViewController.swift
//  Todoey
//
//  Created by gopalakrishna on 02/03/19.
//  Copyright © 2019 gopalakrishna. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
//    let defaults = UserDefaults.standard

    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //: Mark - Table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items list"
        }
        
        return cell
    }
    
    //: MARK - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error updating item,\(error)")
            }
        }
        tableView.reloadData()
    }
    
    
    @IBAction func barBtnPressed(_ sender: UIBarButtonItem) {
        
        var txtFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = txtFld.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                        }
                }catch{
                    print("Error saving,\(error)")
                }
                }
        self.tableView.reloadData()
        }
        alert.addTextField { (alertTxtFld) in
            txtFld = alertTxtFld
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
}

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request,predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0){
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }

    }
}

