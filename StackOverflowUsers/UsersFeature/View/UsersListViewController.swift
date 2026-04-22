//
//  UsersListViewController.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

enum UserRowUIModel {
    case user(UserUIModel)
    case action(ActionUIModel)
}

protocol UsersListViewModelProtocol: AnyObject {
    var rows: [UserRowUIModel] { get }
    
    func viewDidLoad()
    func willDisplayCell(at index: Int)
    func didFollowUser(at index: Int)
    func didSelectAction(at index: Int)
}

// MARK: - UIViewController

class UsersListViewController: UIViewController {
    private let tableView: UITableView
    private let viewModel: UsersListViewModelProtocol
    
    init(viewModel: UsersListViewModelProtocol) {
        self.tableView = UITableView()
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
    }
    
    func constraintSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupSubviews() {
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UserCell.self)
        tableView.register(ActionCell.self)
    }
}

// MARK: - UITableViewDataSource

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.rows[indexPath.row] {
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

// MARK: - Preview

#Preview {
    class PreviewUsersViewModel: UsersListViewModelProtocol {
        let rows: [UserRowUIModel] = [
            .user(.init(name: "Ferda Mravenec", isFollowed: true)),
            .user(.init(name: "Brouk Pytlík", isFollowed: false)),
            .action(.init(title: "Do not press!"))
        ]
        
        func viewDidLoad() {}
        func willDisplayCell(at index: Int) {}
        func didFollowUser(at index: Int) {}
        func didSelectAction(at index: Int) {}
    }

    return UsersListViewController(viewModel: PreviewUsersViewModel())
}
