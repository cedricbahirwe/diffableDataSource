//
//  UsersTableViewController.swift
//  Diffable Data Source
//
//  Created by Cedric Bahirwe on 11/24/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit


struct User: Hashable {
    var name: String
}

fileprivate typealias UserDataSource = UITableViewDiffableDataSource<UsersTableViewController.Section, User>
fileprivate typealias UserSnapShot = NSDiffableDataSourceSnapshot<UsersTableViewController.Section, User>

class UsersTableViewController: UITableViewController {
    
    
    private var alertService = AlertService()
    private var dataSource: UserDataSource!
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        
    }
    
    
    @IBAction func didPressAddButton(_ sender: UIBarButtonItem) {
        let alert =  alertService.createAlert(completion: { [weak self] name in
            if !name.isEmpty  { self?.addNewUser(with: name) }
        })
        
        present(alert, animated: true)
        
    }
    
    private func configureDataSource() {
        dataSource = UserDataSource(tableView: tableView) { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = user.name
            return cell
        }
    }
    
    private func addNewUser(with name: String) {
        
        let user = User(name: name)
        self.users.append(user)
        createSnapShot(from: self.users)
    }
    
    private func createSnapShot(from users: [User]) {
        var snapShot = UserSnapShot()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(users)
        
        dataSource.apply(snapShot)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        print(user.name)
    }
    
    
}


extension UsersTableViewController {
    fileprivate enum Section {
        case main
    }
}

class AlertService {
    
    func createAlert(completion: @escaping(String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Create User", message: nil, preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: { $0.placeholder = "Enter user name" })
        let action = UIAlertAction(title: "Done", style: .default, handler: { _ in
            let userName = alert.textFields?.first?.text ?? ""
            completion(userName)
        })
        
        alert.addAction(action)
        
        return alert
    }
}
