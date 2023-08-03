//
//  Coordinator.swift
//  Coordinators
//
//  Created by Christos Kaktsis on 8/5/23.
//

import Foundation
import UIKit

enum NavigationAction{
    case GO_TO_DETAIL(SHOW: TvShow)
    case GO_BACK
    case GO_TO_LIST
    case Go_TO_WEB(URL: String)
}

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set}
    
    func start()
    func eventOccured(with type: NavigationAction)
}
protocol Coordinating{
    var coordinator: Coordinator? { get set }
}
