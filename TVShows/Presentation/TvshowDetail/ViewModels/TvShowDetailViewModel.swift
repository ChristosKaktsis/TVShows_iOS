//
//  TvShowDetailViewModel.swift
//  TVShows
//
//  Created by Christos Kaktsis on 11/5/23.
//

import Foundation
import Alamofire

protocol TvShowDetailDelegate {
    func didLoadTvShow()
}

class TvShowDetailViewModel{
    var tvShow: TvShow
    
    var delegate: TvShowDetailDelegate?
    
    
    init(tvShow: TvShow){
        self.tvShow = tvShow
        delegate?.didLoadTvShow()
    }
    var name: String {
        return tvShow.name
    }
    var summary: String {
        return tvShow.summary
    }
    var rating: String {
        if let val = tvShow.rating{
            return String(val)
        }
        else {
            return ""
        }
    }
//    var genreString: String {
//
//        var value = ""
//        let genres = tvShow.genres
//
//        for genre in genres{
//            value += "\(genre), "
//        }
//
//        return value
//    }
    var status: String {
        return tvShow.status
    }
    var started: String {
        return tvShow.premiered
    }
    var officialSiteUrl: String? {
        return tvShow.website
    }
    var imageUrl: String? {
        return tvShow.imageUrl
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
