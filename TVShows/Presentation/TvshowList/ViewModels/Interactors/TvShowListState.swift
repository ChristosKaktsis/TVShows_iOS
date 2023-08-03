//
//  TvShowListState.swift
//  TVShows
//
//  Created by Christos Kaktsis on 15/5/23.
//

import Foundation

class TvShowListState{
    var isLoading: Bool
    var tvShows: [TvShow]
    
    init(isLoading: Bool, tvShows: [TvShow]) {
        self.isLoading = isLoading
        self.tvShows = tvShows
    }
    
    func copy(isLoading: Bool? = nil, tvShows: [TvShow]? = nil) -> TvShowListState{
        return TvShowListState(isLoading: isLoading ?? self.isLoading, tvShows: tvShows ?? self.tvShows )
    }
}
