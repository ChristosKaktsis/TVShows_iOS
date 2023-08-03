//
//  TvShow.swift
//  TVShows
//
//  Created by Christos Kaktsis on 16/5/23.
//

import Foundation

class TvShow: Equatable{
    static func == (lhs: TvShow, rhs: TvShow) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int?
    var name: String
    var summary: String
    var rating: Double?
    var thumbUrl: String
    var imageUrl: String
    var status: String
    var premiered: String
    var website: String?
    init(id: Int?, name: String, summary: String, rating: Double?, thumbUrl: String, imageUrl: String, status: String, premiered: String, website: String?) {
        self.id = id
        self.name = name
        self.summary = summary
        self.rating = rating
        self.thumbUrl = thumbUrl
        self.imageUrl = imageUrl
        self.status = status
        self.website = website
        self.premiered = premiered
    }
}

class TvShowContainer {
    var networkTvShows: [TVMazeDTOElement]
    init(networkTvShows: [TVMazeDTOElement]) {
        self.networkTvShows = networkTvShows
    }
    func asDomainModel() -> [TvShow]{
        var list: [TvShow] = []
        for show in networkTvShows{
            list.append(
                TvShow(
                    id: show.id,
                    name: show.name,
                    summary: show.summary,
                    rating: show.rating.average,
                    thumbUrl: show.image.medium,
                    imageUrl: show.image.original,
                    status: show.status.rawValue,
                    premiered: show.premiered,
                    website: show.officialSite
                ))
        }
        return list
    }
    func asDatabaseModel() -> [TvShowEntity]{
        var list: [TvShowEntity] = []
        for show in networkTvShows{
            let tvShow = TvShowEntity()
            tvShow.id = show.id
            tvShow.name = show.name
            tvShow.summary = show.summary
            tvShow.rating = show.rating.average
            tvShow.thumbUrl = show.image.medium
            tvShow.imageUrl = show.image.original
            tvShow.status = show.status.rawValue
            tvShow.premiered = show.premiered
            tvShow.website = show.officialSite
            
            list.append(tvShow)
        }
        return list
    }
}
