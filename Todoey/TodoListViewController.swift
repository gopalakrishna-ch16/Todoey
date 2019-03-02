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

    
    var itemarray = ["Find Milk","Buy Eggs","Destroy Demogorgan"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodolistArray") as? [String] {
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
        
        cell.textLabel?.text = itemarray[indexPath.row]
        
        return cell
    }
    
    //: MARK - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func barBtnPressed(_ sender: UIBarButtonItem) {
        
        var txtFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemarray.append(txtFld.text!)
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

