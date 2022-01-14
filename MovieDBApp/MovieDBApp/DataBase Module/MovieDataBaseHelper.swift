//
//  MovieDataBaseModdel.swift
//  MovieDBApp
//
//  Created by RWS Macbook on 13/01/22.
//

import Foundation
import UIKit

import CoreData

open class MovieDataBaseHelper: NSObject {
    
    private static let MovieInstance = "MovieInstance"

    public static func addMovie(movie: Movie, completion:@escaping(Bool) -> Void){
        
        let context = self.getManagedObjectContext()
        
        context.performAndWait {
            
            let entity = NSEntityDescription.entity(forEntityName: MovieInstance, in: context)
            let contact = NSManagedObject(entity: entity!, insertInto: context)
            
            contact.setValue(movie.id, forKey: "id")
            contact.setValue(movie.original_title, forKey: "original_title")
            contact.setValue(movie.overview, forKey: "overview")
            contact.setValue(movie.poster_path, forKey: "poster_path")
            contact.setValue(movie.release_date, forKey: "release_date")
            contact.setValue(movie.movieType, forKey: "movieType")

            do {
                try context.save()
            }catch{
                NSLog("Failed saving")
            }
            completion(true)
        }
    }
    
    static func clearAllData(_ type: String, _ onComplete: () -> Void) {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: MovieInstance)
        
        request.predicate = NSPredicate(format: "movieType == %@", type)

        let context = self.getManagedObjectContext()

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batchDeleteRequest)
            onComplete()
        } catch(let error) {
            print(error)
        }
    }

    public static func addMovieArray(movies: [Movie]) {
        
        MovieDataBaseHelper.clearAllData(movies.first?.movieType ?? "") {
            for i in movies {
                MovieDataBaseHelper.addMovie(movie: i) { _ in
                }
            }
        }
    }
    
    public static  func getFavStatus(_ id: Int) -> Bool {

        if let favIds = UserDefaults.standard.value(forKey: keyFavorite) as? [Int] {
            
            if favIds.contains(id) {
                return true
            } else {
                return false
            }
        }
        return false
    }

    public static  func getList(_ type: String) -> [Movie] {
                
        var arrList: [Movie] = []

        let context = self.getManagedObjectContext()
        context.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: MovieInstance)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "movieType == %@", type)

            
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if let id = data.value(forKey: "id") as? Int,
                    let original_title = data.value(forKey: "original_title") as? String,
                    let overview = data.value(forKey: "overview") as? String,
                    let poster_path = data.value(forKey: "poster_path") as? String,
                    let release_date = data.value(forKey: "release_date") as? String {

                        let favStatus = getFavStatus(id)

                        arrList.append(Movie(id: id, original_title: original_title, overview: overview, poster_path: poster_path, release_date: release_date, isFavorite: favStatus))
                    }
                }
            } catch {
                
                print("Failed")
            }
        }

        return arrList
    }
    
    public  static  func updateFavoriteStatus(_ movie: Movie, completion:@escaping() -> Void) {
        
        if movie.isFavorite {
            
            if var favIds = UserDefaults.standard.value(forKey: keyFavorite) as? [Int] {
                favIds.append(movie.id)
                UserDefaults.standard.setValue(favIds, forKey: keyFavorite)
            } else {
                UserDefaults.standard.setValue([movie.id], forKey: keyFavorite)
            }
        } else {
            
            if var favIds = UserDefaults.standard.value(forKey: keyFavorite) as? [Int] {
                if let index = favIds.firstIndex(of: movie.id) {
                    favIds.remove(at: index)
                    UserDefaults.standard.setValue(favIds, forKey: keyFavorite)
                }
            }
            
        }
        completion()
    }

    private  static func getManagedObjectContext() -> NSManagedObjectContext{
        
        let context = persistentContainer.viewContext
        return context
        
    }
    private static var persistentContainer: NSPersistentContainer = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer
    }()
}

enum MovieType: String {
    case popular = "popular"
    case upcoming = "upcoming"
}
