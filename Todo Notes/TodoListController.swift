//
//  ViewController.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 26/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import UIKit

class TodoListController: UITableViewController {

    
    var itemsArray = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        row.textLabel?.text = itemsArray[indexPath.row]
        return row
    }
    
    //MARK - Tableview delegate methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        let cell = tableView.cellForRow(at: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = .purple
        cell!.selectedBackgroundView = bgColorView

        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [closeAction])

    }

    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        //modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }


    //MARK - ADD A NEW TODO LIST ITEMS ON CLICK OF + BUTTON
    
    @IBAction func todoAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemsArray.append(textField.text!)
            
            self.tableView.reloadData()
        }
        alert.addTextField { (todoTextField) in
            todoTextField.placeholder = "add new todo"
            textField = todoTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
}

