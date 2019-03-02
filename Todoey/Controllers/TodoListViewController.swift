//
//  ViewController.swift
//  Todoey
//
//  Created by gopalakrishna on 02/03/19.
//  Copyright © 2019 gopalakrishna. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard

    
    var itemarray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "Find Milk"
        itemarray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemarray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgan"
        itemarray.append(newItem3)
        if let items = defaults.array(forKey: "TodolistArray") as? [Item] {
            itemarray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //: Mark - Table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemarray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemarray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //: MARK - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemarray[indexPath.row].done = !itemarray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func barBtnPressed(_ sender: UIBarButtonItem) {
        
        var txtFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item()
            item.title = txtFld.text!
            self.itemarray.append(item)
            self.defaults.set(self.itemarray, forKey: "TodolistArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTxtFld) in
            txtFld = alertTxtFld
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

