//
//  ViewController.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.
//

import UIKit

class MovieDashboardVc: UIViewController {
    
    @IBOutlet weak var collectionPopularMovies: UICollectionView!
    @IBOutlet weak var collectionUpcomingMovies: UICollectionView!

   lazy var viewModel: MovieDashboardViewModel = {
       MovieDashboardViewModel(self)
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionPopularMovies.register(UINib(nibName: "MovieCollectionCell", bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionCell.self))
        collectionUpcomingMovies.register(UINib(nibName: "MovieCollectionCell", bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionCell.self))
        viewModel.populateMovieData()
    }
}

extension MovieDashboardVc: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionPopularMovies {
            return viewModel.arrPopularMovie.count
        } else if collectionView == collectionUpcomingMovies {
            return viewModel.arrUpComingMovie.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionCell.self), for: indexPath) as? MovieCollectionCell {
            
            if collectionView == collectionPopularMovies {
                
                if Reachability.isConnectedToNetwork() {
                    if indexPath.row == viewModel.arrPopularMovie.count - 1 {
                        if viewModel.isMorePopularDataAvailable {
                            self.viewModel.popularPageCount += 1
                            viewModel.callApiForPopularMovie()
                        }
                    }
                }
                
                cell.configure(viewModel.arrPopularMovie[indexPath.row])
                
            } else if collectionView == collectionUpcomingMovies {
                
                if Reachability.isConnectedToNetwork() {
                    if indexPath.row == viewModel.arrUpComingMovie.count - 1 {
                        if viewModel.isMoreUpComingDataAvailable {
                            self.viewModel.upComingPageCount += 1
                            viewModel.callApiForUpcomingMovie()
                        }
                    }
                }

                cell.configure(viewModel.arrUpComingMovie[indexPath.row])
            }

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var selectedMovie: Movie?
        
        if collectionView == collectionUpcomingMovies {
            selectedMovie = viewModel.arrUpComingMovie[indexPath.row]
        } else if collectionView == collectionPopularMovies {
            selectedMovie = viewModel.arrPopularMovie[indexPath.row]
        }
        
        guard let movie = selectedMovie else { return }
        viewModel.showMovieDetailView(forMovie: movie, superView: self.view)
    }
}

extension MovieDashboardVc:  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: viewModel.inset, left: viewModel.inset, bottom: viewModel.inset, right: viewModel.inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let marginsAndInsets = CGFloat(viewModel.inset * 2.0) + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + viewModel.minimumInteritemSpacing * CGFloat(viewModel.cellsPerRow - 1)

        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(viewModel.cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: collectionView.frame.height)
    }
}

extension MovieDashboardVc: MovieDashboardViewModelDelegate {

    func reloadUpComingListing() {
        self.collectionUpcomingMovies.reloadData()
    }
    func reloadPopularListing() {
        self.collectionPopularMovies.reloadData()
    }
}

