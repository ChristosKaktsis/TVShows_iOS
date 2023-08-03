//
//  MainCoordinator.swift
//  Coordinators
//
//  Created by Christos Kaktsis on 8/5/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator{
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = TvShowListViewModel()
        viewModel.coordinator = self
        let vc = TvShowListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func eventOccured(with type: NavigationAction) {
        switch type{
        case .GO_TO_DETAIL(let tvShow):
            let vm = TvShowDetailViewModel(tvShow: tvShow)
            let vc = TvShowDetailViewController(viewModel: vm)
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        case .GO_BACK:
            break
        case .GO_TO_LIST:
            break
        case .Go_TO_WEB(let url):
            let vm = WebViewViewModel(url: url)
            let vc = WebViewViewController(viewModel: vm)
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
}

