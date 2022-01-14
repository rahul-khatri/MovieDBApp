//
//  Movie.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 14/01/22.
//

import Foundation

public class Movie {
    
    var adult: Bool = false
    var backdrop_path: String = ""
    var id: Int = 0
    var original_language: String = ""
    var original_title: String = ""
    var overview: String = ""
    var popularity: Double = 0.0
    var poster_path: String = ""
    var release_date: String = ""
    var title: String = ""
    var video: Bool = false
    var vote_average: Double = 0.0
    var vote_count: Int = 0
    var isFavorite: Bool = false
    var movieType: String = ""
    
    init(_ dict: [String: Any], _ movieType: String) {

        self.adult = dict["adult"] as? Bool ?? false
        self.backdrop_path = dict["backdrop_path"] as? String ?? ""
        self.id = dict["id"] as? Int ?? 0
        self.original_language = dict["original_language"] as? String ?? ""
        self.original_title = dict["original_title"] as? String ?? ""
        self.overview = dict["overview"] as? String ?? ""
        self.popularity = dict["popularity"] as? Double ?? 0.0
        self.poster_path = dict["poster_path"] as? String ?? ""
        self.release_date = dict["release_date"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.video = dict["video"] as? Bool ?? false
        self.vote_average = dict["vote_average"] as? Double ?? 0.0
        self.vote_count = dict["vote_count"] as? Int ?? 0
        self.isFavorite = MovieDataBaseHelper.getFavStatus(self.id)
        self.movieType = movieType
    }
    
    init(id: Int, original_title: String, overview: String, poster_path: String, release_date: String, isFavorite: Bool) {
        
        self.id = id
        self.original_title = original_title
        self.overview = overview
        self.poster_path = poster_path
        self.release_date = release_date
        self.isFavorite = isFavorite
    }
}
