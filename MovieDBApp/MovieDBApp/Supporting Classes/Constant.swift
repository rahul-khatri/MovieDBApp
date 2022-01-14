//
//  Constant.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.
//

import Foundation

let api_key = "1a50c16d2fdfd2ce09e7e5f7d0760e21"
let language = "en-US"
let keyFavorite = "fav"
let imageDownloadUrl = "https://image.tmdb.org/t/p/original/"

class ApiConstant {

    private static let base_url = "https://api.themoviedb.org/3/movie/"
    static let upComingMovies = base_url + "upcoming"
    static let popularMovies = base_url + "popular"
}
