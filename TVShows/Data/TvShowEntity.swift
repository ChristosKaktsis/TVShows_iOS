//
//  TvShowEntity.swift
//  TVShows
//
//  Created by Christos Kaktsis on 16/5/23.
//

import Foundation
import RealmSwift

class TvShowEntity: Object,Codable, Comparable{
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String
    @Persisted var summary: String
    @Persisted var rating: Double?
    @Persisted var thumbUrl: String
    @Persisted var imageUrl: String
    @Persisted var website: String?
    @Persisted var premiered: String
    @Persisted var status: String
    public static func < (lhs: TvShowEntity, rhs: TvShowEntity) -> Bool {
           
           guard let m1 = lhs.id, let m2 = rhs.id else { return false }
           return m1 < m2
       }
}
extension TvShowEntity {
    func asDomainModel() -> TvShow{
        return TvShow(
            id: id,
            name: name,
            summary: summary,
            rating: rating,
            thumbUrl: thumbUrl,
            imageUrl: imageUrl,
            status: status,
            premiered: premiered,
            website: website
        )
    }
}
