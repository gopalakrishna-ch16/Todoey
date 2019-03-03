//
//  ViewController.swift
//  Todoey
//
//  Created by gopalakrishna on 02/03/19.
//  Copyright © 2019 gopalakrishna. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {
    
//    let defaults = UserDefaults.standard

    
    var itemarray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        loadItems()
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func barBtnPressed(_ sender: UIBarButtonItem) {
        
        var txtFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item()
            item.title = txtFld.text!
            self.itemarray.append(item)
            self.saveItems()
        }
        alert.addTextField { (alertTxtFld) in
            txtFld = alertTxtFld
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemarray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error occur to write data:\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
    if let data = try? Data(contentsOf: dataFilePath!) {
        
        let decoder = PropertyListDecoder()
        do{
        itemarray =  try decoder.decode([Item].self, from: data)
        }catch{
            print("error retriving data:\(error)")
        }
    }
    }
}

