
//  Created by Brian Rosales on 2/9/22.
//

import UIKit
protocol DataManagerDelegate {
    func didUpdateAnime(animeUpdated: AnimeModel)
    func didFailWithError(error: Error)
}

struct DataManager {
    let baseURL = "https://kitsu.io/api/edge/anime?filter[text]="
    var delegate: DataManagerDelegate?
    
    
    func reformatTitle(oldFormat: String) {
        var newFormat = ""
        for char in oldFormat {
            if char != " " {
                newFormat += String(char)
            } else {
                newFormat += "%20"
            }
        }
        fetchAnime(animeTitle: newFormat)
    }
    
    func fetchAnime(animeTitle: String) {
        let Title = animeTitle
        let urlString = "\(baseURL)\(Title)"
        print(urlString)
        preformRequest(with: urlString)
        
    }
    
    func preformRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error)
                    return
                }
                if let safeData = data {
                    if let animeUpdated = self.parseJSON(currentData: safeData) {
                        self.delegate?.didUpdateAnime(animeUpdated: animeUpdated)
                    }
                }
            }
        task.resume()
        }
    }
    
    func parseJSON(currentData: Data) -> AnimeModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(AnimeData.self, from: currentData)
            let name = decodedData.data![0].attributes!.canonicalTitle!
            let summary = decodedData.data![0].attributes!.synopsis!
            let status = decodedData.data![0].attributes!.status!
            let score = decodedData.data![0].attributes!.averageRating!
            let age = decodedData.data![0].attributes!.ageRating!
            let poster = decodedData.data![0].attributes!.posterImage!.small!
            
            let animeUpdated = AnimeModel(animeTitle: name, synopsis: summary, status: status, rating: score, ageRating: age, animeImage: poster)
            return animeUpdated
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
      }
    }

