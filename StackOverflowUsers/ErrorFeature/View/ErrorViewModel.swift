//
//  ErrorViewModelProtocol.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

protocol ErrorCoordinatorProtocol: AnyObject {
    func didSelectAction()
}

// MARK: - ViewModel

class ErrorViewModel: ErrorViewModelProtocol {
    let model: ErrorUIModel
    
    weak var coordinator: ErrorCoordinatorProtocol?
    
    init(model: ErrorUIModel) {
        self.model = model
    }
    
    func didSelectAction() {
        coordinator?.didSelectAction()
    }
}
