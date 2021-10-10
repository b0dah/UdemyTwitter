//
//  ExploreController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit

fileprivate let userCellIdentifier = "UserCellIdentifier"

class ExploreController: UITableViewController {
    
    // MARK:- Properties
    
    private var users = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var filteredUsers = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.configureUI()
        
        self.configureSearchController()
        self.fetchusers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK:- Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Explore"
    }
    
    private func configureTableView()  {
        tableView.register(UserCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    private func configureSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = self.searchController
        definesPresentationContext = false
    }
    
    // MARK:- API
    
    private func fetchusers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
}

// MARK:- UITableView Datasource

extension ExploreController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier, for: indexPath) as! UserCell
        
        let index = indexPath.row
        let user = inSearchMode ? filteredUsers[index] : users[index]
        
        cell.user = user
        return cell
    }
}

// MARK:- UITableView Delegate

extension ExploreController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let user = inSearchMode ? filteredUsers[index] : users[index]
        let controller = ProfileController(user: user)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK:- UISearchResultsUpdating

extension ExploreController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter {
            $0.username.contains(searchText) || $0.fullname.contains(searchText)
        }
        
        tableView.reloadData()
    }
    
}
