//
//  RealmManager.swift
//  TVShows
//
//  Created by Christos Kaktsis on 16/5/23.
//

import Foundation
import RealmSwift

class RealmManager {
    let realm = try! Realm()
    
    func getTvShows() -> Results<TvShowEntity>{
        return realm.objects(TvShowEntity.self)
    }
    func insertAll(tvShows: [TvShowEntity]){
        var existingIDs: [Int?] = []
        getTvShows().forEach { tvShowEntity in
            existingIDs.append(tvShowEntity.id)
        }
        for tvShow in tvShows {
          
            if existingIDs.contains(tvShow.id){
                do{
                    try realm.write {
                        let tvShowEntity = realm.object(ofType: TvShowEntity.self, forPrimaryKey: tvShow.id)
                        tvShowEntity?.name = tvShow.name
                        tvShowEntity?.summary = tvShow.summary
                        tvShowEntity?.status = tvShow.status
                        tvShowEntity?.rating = tvShow.rating
                        tvShowEntity?.premiered = tvShow.premiered
                        tvShowEntity?.thumbUrl = tvShow.thumbUrl
                        tvShowEntity?.imageUrl = tvShow.imageUrl
                    }
                }
                catch{
                    print("Error updating data to Realm")
                }
            } else{
                do{
                
                    try realm.write{
                        realm.add(tvShow)
                    }
                } catch{
                    print("Error while writting data to Realm")
                }
            }
        }
    }
}
