//
//  ViewDetail.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 14/01/22.
//

import UIKit

class ViewDetail: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imgPoster: UIImageView!
    var movie: Movie!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ movie: Movie) {
        
        self.movie = movie
        
        lblTitle.text = movie.original_title
        lblDate.text = movie.release_date
        lblDescription.text = movie.overview
        btnFavorite.tintColor = movie.isFavorite ? .red : .darkGray
        self.imgPoster?.sd_setImage(with: URL(string: "\(imageDownloadUrl)\(movie.poster_path)"), placeholderImage: UIImage(named: "movie_placeholder"), options: .refreshCached, context: [:])
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func actionFavorite(_ sender: UIButton) {
        
        self.movie.isFavorite = !self.movie.isFavorite
        
        
//        if self.movie.isFavorite {
//
//
//            if var favIds = UserDefaults.standard.value(forKey: "fav") as? [Int] {
//                favIds.append(self.movie.id)
//                UserDefaults.standard.setValue(favIds, forKey: "fav")
//            } else {
//                UserDefaults.standard.setValue([self.movie.id], forKey: "fav")
//                }
//        } else {
//
//            if var favIds = UserDefaults.standard.value(forKey: "fav") as? [Int] {
//                if let index = favIds.firstIndex(of: movie.id) {
//                    favIds.remove(at: index)
//                    UserDefaults.standard.setValue(favIds, forKey: "fav")
//                }
//            }
//
//        }
//
//                    self.configure(self.movie)
//
//
//
//
        
        MovieDataBaseHelper.updateFavoriteStatus(self.movie) {
            self.configure(self.movie)
        }
    }
}
