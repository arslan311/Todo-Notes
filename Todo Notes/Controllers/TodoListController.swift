//
//  ViewController.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 26/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListController: UITableViewController  {
    
    var realm = try! Realm()
    
    var todoItems : Results<CellModel>?
    
    //let defaults = UserDefaults.standard
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)

        if let item = todoItems?[indexPath.row] {
            
            row.textLabel?.text = item.itemName
            row.accessoryType = item.isPressed ? .checkmark : .none
        }else{
        row.textLabel?.text = "No items added"
        }
        return row
    }
    
    //MARK - Tableview delegate methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.isPressed = !item.isPressed
                }
            }catch {
                print("error occured updating \(error)")
            }
        }
        let cell = tableView.cellForRow(at: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = .purple
        cell!.selectedBackgroundView = bgColorView
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .darkGray
        return UISwipeActionsConfiguration(actions: [closeAction])

    }

    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            do {
                try self.realm.write {
                self.realm.delete(self.todoItems![indexPath.row])
            }
            tableView.reloadData()
            success(true)
            }catch{
                print("Error deleting \(error)")
            }
            
        }
            )
        modifyAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }


    //MARK - ADD A NEW TODO LIST ITEMS ON CLICK OF + BUTTON
    
    @IBAction func todoAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
            do{
                try self.realm.write {
                    
                    let item = CellModel()
                    item.itemName = textField.text!
                    item.dateCreated = self.getDateTime()
                    currentCategory.items.append(item)
                }
            }catch{
                print("Item not saved \(error)")
            }
        }
            self.tableView.reloadData()
    }
        alert.addTextField { (todoTextField) in
            todoTextField.placeholder = "add new todo"
            textField = todoTextField
        }
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        tableView.reloadData()
    }

    func getDateTime() -> String {
        let currentDateTime = Date()
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
        // October 8, 2016 at 10:48:53 PM
    }
}

extension TodoListController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("itemName contains[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }

        }

    }
}

