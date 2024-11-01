//
//  GestionnaireDeFilms.swift
//  test_jeupendu
//
//  Created by Veronica Mendoza - Escobar on 2024-10-27.
//
//
//  GestionnaireDeFilms.swift
//  Labo2_JeuDuPendu
//
//  Created by Emilie Albert-Moisan (Étudiant) on 2024-10-28.
//

import Foundation

struct Movie: Decodable {
	let Title: String
}

class GestionnaireDeFilms {
	
	//Singleton instance
	static let shared = GestionnaireDeFilms()
	
	private init() {}
	
	let apiKey = "1e488ee3"
	let baseURL = "https://www.omdbapi.com/?apikey="
	
	// Fonction pour récupérer les détails d'un film par son imdbID
	func fetchMovie(imdbID: String, completion: @escaping (Movie?) -> Void) {
		guard let url = URL(string: "\(baseURL)\(apiKey)&i=\(imdbID)") else {
			print("URL non valide pour l'id: \(imdbID)")
			completion(nil)
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				print("Erreur de requête: \(error)")
				completion(nil)
				return
			} else if let data = data {
				let decoder = JSONDecoder()
				do {
					let movie = try decoder.decode(Movie.self, from: data)
					DispatchQueue.main.async {
						completion(movie)
					}
				} catch {
					print("Erreur de décodage: \(error)")
					completion(nil)
				}
			}
		}
		task.resume()
	}
	
	// Télécharger les informations de plusieurs films
	func startDownloading(completion: @escaping (String?) -> Void) {
		let imdbIDs = listeFilms
		let randomIndex = Int.random(in: 0..<imdbIDs.count)
		let imdbID = imdbIDs[randomIndex]
		fetchMovie(imdbID: imdbID) { movie in
			if let movie = movie {
				print("Titre: \(movie.Title)")
				completion(movie.Title)
			} else {
				completion(nil)
			}
		}
	}
}
