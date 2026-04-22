//
//  UsersListViewController.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

enum UsersListRowUIModel: Equatable {
    case user(UserUIModel)
    case action(ActionUIModel)
}

protocol UsersListViewModelProtocol: AnyObject {
    var isLoading: Bool { get }
    var numberOfItems: Int { get }
    func viewDidLoad()
    func didFollowUser(at index: Int)
    func didSelectAction(at index: Int)
    func usersListRowUIModel(at index: Int) -> UsersListRowUIModel
}

// MARK: - UIViewController

class UsersListViewController: UIViewController {
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    private let viewModel: UsersListViewModelProtocol
    
    init(viewModel: UsersListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        constraintSubviews()
        setupSubviews()
        viewModel.viewDidLoad()
    }
}

// MARK: - UI Setup

private extension UsersListViewController {
    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    func constraintSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupSubviews() {
        navigationItem.title = Constant.pageTitle
        navigationItem.largeTitle = Constant.pageTitle
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UserCell.self)
        tableView.register(ActionCell.self)
        
        activityIndicator.style = .large
        activityIndicator.color = .tintColor
        activityIndicator.hidesWhenStopped = true
        updateActivityIndicator()
    }
}

// MARK: - UsersListViewControllerProtocol

extension UsersListViewController: UsersListViewControllerProtocol {
    func updateActivityIndicator() {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func updateRow(at index: Int) {
        tableView.reloadRows(at: [.init(row: index, section: .zero)], with: .automatic)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.usersListRowUIModel(at: indexPath.row)  {
        case let .user(model):
            let cell: UserCell = tableView.dequeueReusableCell(for: indexPath)
            cell.load(model)
            cell.onFollowClick = { [weak viewModel] in viewModel?.didFollowUser(at: indexPath.row) }
            return cell
        case let .action(model):
            let cell: ActionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.load(model)
            cell.onActionClick = { [weak viewModel] in viewModel?.didSelectAction(at: indexPath.row) }
            return cell
        }
    }
}

// MARK: - Constant

private enum Constant {
    static let pageTitle = "StackOverflow Users"
}

// MARK: - Preview

#Preview {
    class PreviewUsersViewModel: UsersListViewModelProtocol {
        private let uiModels: [UsersListRowUIModel] = [
            .user(.init(name: "Ferda Mravenec", image: UIImage(systemName: "person.circle")!, reputation: "12345", isFollowed: true)),
            .user(.init(name: "Brouk Pytlík", image: UIImage(systemName: "person.circle")!, reputation: "67890", isFollowed: false)),
            .action(.init(title: "Do not press!"))
        ]
        
        let isLoading: Bool = true
        var numberOfItems: Int { uiModels.count }
        
        func viewDidLoad() {}
        func didFollowUser(at index: Int) {}
        func didSelectAction(at index: Int) {}
        
        func usersListRowUIModel(at index: Int) -> UsersListRowUIModel {
            uiModels[index]
        }
    }

    return UsersListViewController(viewModel: PreviewUsersViewModel())
}
