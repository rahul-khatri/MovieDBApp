//
//  MovieCollectionCell.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.
//

import UIKit
import SDWebImage

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ movie: Movie) {
        self.lblTitle?.text = movie.original_title
        self.imgPoster?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgPoster?.sd_setImage(with: URL(string: "\(imageDownloadUrl)\(movie.poster_path)"), placeholderImage: UIImage(named: "movie_placeholder"), options: .refreshCached, context: [:])
    }
    
    
}
