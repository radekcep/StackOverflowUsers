//
//  ErrorCoordinator.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

class ErrorCoordinator {
    private let viewController: UIViewController
    private var errorContinuation: CheckedContinuation<Void, Never>?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func start(model: ErrorUIModel) async {
        let viewModel = ErrorViewModel(model: model)
        let errorViewController = ErrorViewController(viewModel: viewModel)
        viewModel.coordinator = self
        
        errorViewController.isModalInPresentation = true
        viewController.present(errorViewController, animated: true)
        
        await withCheckedContinuation { errorContinuation = $0 }
    }
}

extension ErrorCoordinator: ErrorCoordinatorProtocol {
    func didSelectAction() {
        viewController.dismiss(animated: true)
        errorContinuation?.resume()
        errorContinuation = nil
    }
}
