//
//  MovieDashboardViewModel.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 14/01/22.
//

import Foundation
import UIKit


protocol MovieDashboardViewModelDelegate: AnyObject {
    func reloadUpComingListing()
    func reloadPopularListing()
}

class MovieDashboardViewModel: NSObject {
    
    var arrUpComingMovie: [Movie] = []
    var arrPopularMovie: [Movie] = []
    
    var upComingPageCount = 1
    var isMoreUpComingDataAvailable = true

    var popularPageCount = 1
    var isMorePopularDataAvailable = true
    
    let inset: CGFloat = 8
    let minimumLineSpacing: CGFloat = 8
    let minimumInteritemSpacing: CGFloat = 8
    let cellsPerRow = 3
    
    var delegate: MovieDashboardViewModelDelegate?
    
    private override init() { }
    
    init(_ delegate: MovieDashboardViewModelDelegate) {
        self.delegate = delegate
    }
    
    func populateMovieData() {
        
        if Reachability.isConnectedToNetwork() {
            callApiForPopularMovie()
            callApiForUpcomingMovie()
        } else {
            arrUpComingMovie = MovieDataBaseHelper.getList(MovieType.upcoming.rawValue)
            arrPopularMovie = MovieDataBaseHelper.getList(MovieType.popular.rawValue)
            delegate?.reloadPopularListing()
            delegate?.reloadUpComingListing()
        }
    }

    func callApiForUpcomingMovie() {
        
        let param: [String: Any] = [
            "api_key": api_key,
            "language": language,
            "page": upComingPageCount
        ]
        
        ApiManager.shared.executeApiWithRequestUrl(urlStr: ApiConstant.upComingMovies, dicParams: param, method: .kMethodGet, isShowingLoader: true) { response, error in
            print(response)
            
            if let dictResponse = response as? [String: Any] {
                
                if let arrResults = dictResponse["results"] as? [[String: Any]] {
                    
                    for x in arrResults {
                        self.arrUpComingMovie.append(Movie(x, MovieType.upcoming.rawValue))
                    }
                    
                    if self.upComingPageCount == 1 {
                        MovieDataBaseHelper.addMovieArray(movies: self.arrUpComingMovie)
                    }
                    self.delegate?.reloadUpComingListing()
                } else {
                    self.isMoreUpComingDataAvailable = false
                    
                    
                }
            }
        }
    }
    
    func callApiForPopularMovie() {
        
        let param: [String: Any] = [
            "api_key": api_key,
            "language": language,
            "page": popularPageCount
        ]

        ApiManager.shared.executeApiWithRequestUrl(urlStr: ApiConstant.popularMovies, dicParams: param, method: .kMethodGet, isShowingLoader: true) { response, error in
            print(response)
            
            if let dictResponse = response as? [String: Any] {
                
                if let arrResults = dictResponse["results"] as? [[String: Any]] {
                    
                    for x in arrResults {
                        self.arrPopularMovie.append(Movie(x, MovieType.popular.rawValue))
                    }
                    
                    if self.popularPageCount == 1 {
                        MovieDataBaseHelper.addMovieArray(movies: self.arrPopularMovie)
                    }
                    
                    self.delegate?.reloadPopularListing()
                }
            }
        }
    }
    
    func showMovieDetailView(forMovie movie: Movie, superView: UIView) {
        
        if let viewDetail = Bundle.main.loadNibNamed("ViewDetail", owner: self, options: nil)?[0] as? ViewDetail {
            viewDetail.frame = superView.frame
            viewDetail.configure(movie)
            superView.addSubview(viewDetail)
        }
    }
 }
