//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 10.05.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    // MARK: - Private properties
    private let cellID = "cell"
    private var taskList = StorageManager.shared.fetchData()
    //private var task: Task?
    //private var cellIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        
    }
    
    // MARK: - Private methods
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(
            with: "New Task",
            and: "What do you want to do?",
            placeholder: "New task",
            text: nil
        )
        //task = StorageManager.shared.createTaskObject()
    }
    
    
    private func showAlert(
        task: Task? = nil,
        with title: String,
        and message: String,
        placeholder: String?,
        text: String?,
        completion: (() -> Void)? = nil
        ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else { return }
            self.save(title, task: task, completion: completion)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String, task: Task?, completion: (() -> Void)? = nil) {
        
        if let task = task, let completion = completion {
            StorageManager.shared.edit(task, newTitle: taskName)
            completion()
        } else {
            let newTask = StorageManager.shared.createAndSaveTaskObject(taskName)
            guard let task = newTask else { return }
            taskList.append(task)
            let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [cellIndex], with: .automatic)
        }
        
    }
    
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showAlert(
            task: task,
            with: "Edit task",
            and: "Make changes",
            placeholder: nil,
            text: task.title) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteTaskObject(taskList[indexPath.row])
            
            taskList.remove(at: indexPath.row)
            let cellIndex = IndexPath(row: indexPath.row, section: 0)
            tableView.deleteRows(at: [cellIndex], with: .automatic)
        }
    }
    

}


