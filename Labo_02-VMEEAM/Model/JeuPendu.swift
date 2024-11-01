//
//  JeuDuPendu.swift
//  Labo_02-VMEEAM
//
//  Created by Veronica Mendoza - Escobar on 2024-10-08.
//

//
//  JeuPendu.swift
//  Labo2_JeuDuPendu
//
//  Created by Emilie Albert-Moisan (Étudiant) on 2024-10-28.
//

import Foundation

class JeuPendu{
	//Singleton instance
	static let shared = JeuPendu()
	
	private init() {}
	
	//attributs
	public var chaineCachee: String = ""
	public var chaineTab: [Character] = []
	public var chaineTabFiltred: [Character] = []
	public var chaineVue: String = ""
	public var lettresEssayees: [Character] = []
	public var nbErreurs: Int = 0
	public let nbErreursMax: Int = 7
	public var image: String = ""
	public var msgErreur = ""
	
	//Méthode pour initialiser le en récupérant un film 🍿
	func chargerFilm(completion: @escaping (Bool) -> Void) {
		GestionnaireDeFilms.shared.startDownloading{ [weak self] titreFilm in
			guard let self = self, let titreFilm = titreFilm else {
				completion(false)
				return
			}
			initialiserJeu(avec: titreFilm)
			completion(true)
			
		}
	}
	
	// Méthode pour initialiser le jeu avec le titre récupéré
	private func initialiserJeu(avec titre: String){
		chaineCachee = titre
		chaineTab = Array(chaineCachee)
		chaineTabFiltred = chaineCachee.map { $0.isLetter ? "_" : $0 }
		chaineVue = String(chaineTabFiltred)
		lettresEssayees = []
		nbErreurs = 0
		image = imageNamesSequence[0]
		msgErreur = ""
		
	}
	
	//Méthode pour vérifier une lettre et mettre à jour le jeu
	func verifierLettre(_ lettre: String?){
		if let entree = lettre, entree.count == 1, let lettre = entree.first, lettre.isLetter{
			msgErreur = ""
			let lettreMinuscule = lettre.lowercased()
			if chaineTab.contains(where: { $0.lowercased() == lettreMinuscule }) {
				for (index, element) in chaineTab.enumerated() {
					if element.lowercased() == lettreMinuscule {
						chaineTabFiltred[index] = element
					}
				}
				chaineVue = String(chaineTabFiltred)
			} else {
				if !lettresEssayees.contains(lettre) {
					nbErreurs += 1
					image = imageNamesSequence[nbErreurs]
					lettresEssayees.append(lettre)
				}
			}
		} else {
			msgErreur = "Veuillez entrer une lettre."
		}
		
	}
	
	func finDePartie() -> String? {
		var msg: String? = nil
		
		if(chaineVue == chaineCachee){
			msg = "Vous avez gagné!"
		}
		if(nbErreurs == nbErreursMax) {
			msg = "Vous avez perdu!"
		}
		
		if let message = msg {
			msg = "\(message)\nLe film était: \(chaineCachee)"
		}
		
		return msg
	}
	
}
