//
//  TvShowListViewModel.swift
//  TVShows
//
//  Created by Christos Kaktsis on 10/5/23.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol TvShowListDelegate{
    func didGetData()
}

class TvShowListViewModel {
    
    let realm = RealmManager()
    
    internal let state: BehaviorRelay<TvShowListState>
    var stateObserver: Observable<TvShowListState> {
        return state.asObservable()
    }
    
    var coordinator: Coordinator?
    
    init() {
        self.state = BehaviorRelay(value: TvShowListState(isLoading: false, tvShows: []))
    }
    
    func fetchTVShows() {
        let url = "https://api.tvmaze.com/shows"
        self.state.accept(self.state.value.copy(isLoading: true))
        AF.request(url).validate().responseDecodable(of: TVMazeDTO.self) { [weak self] response in
            guard let self = self else{
                return
            }
            if let result = response.value {
                let tvShowContainer = TvShowContainer(networkTvShows: result)
                let databaseItem = tvShowContainer.asDatabaseModel()
                realm.insertAll(tvShows: databaseItem)
                
            }
            changeStateFromDB()
        }
    }
    func fetchData(){
        if realm.getTvShows().isEmpty {
            fetchTVShows()
        }
        else {
            changeStateFromDB()
        }
    }
    private func changeStateFromDB(){
        let databaseItems = realm.getTvShows()
        var tvShows: [TvShow] = []
        for show in databaseItems{
            tvShows.append(show.asDomainModel())
        }
    
    }
    
    func getTvShow(index: Int) -> TvShow{
        return state.value.tvShows[index]
    }
    
    func fetchImage(url: String?, completion: @escaping ((Data?) -> Void)) {
        
        guard let url = url else {
            completion(nil)
            return
        }
        
        AF.request(url, method: .get).response{ response in
            
            switch response.result {
            case .success(let responseData):
                completion(responseData)
                
            case .failure(let error):
                completion(nil)
                print("error--->",error)
            }
        }
    }
    
}
extension TvShowListViewModel: Coordinating {
    func handleAction(action: NavigationAction){
        coordinator?.eventOccured(with: action)
    }
}
