//
//  JeuDuPendu.swift
//  Labo_02-VMEEAM
//
//  Created by Veronica Mendoza - Escobar on 2024-10-08.
//

import Foundation

func jeuPendu(){
	
	var isGamerunning = true
	
	MovieDownloader.shared.startDownloading { chaineCachee in
		guard let chaineCachee = chaineCachee else {
			print("Erreur: impossible de récupérer le titre du film.")
			isGamerunning = false
			return
		}
		
		let chaineTab = Array(chaineCachee)
		var chaineTabFiltred = chaineCachee.map { character -> Character in
			
			if character.isLetter {
				return "_"
			} else {
				return character
			}
		}
		var chaineVue = String(chaineTabFiltred)
		
		var lettresEssayees: [Character] = []
		var nbErreurs = 0
		let nbErreursMax = 7
		
		func trouve(lettre: Character) {
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
					lettresEssayees.append(lettre)
				}
			}
		}
		
		func perdu() -> Bool {
			return nbErreurs == nbErreursMax
		}
		
		func gagne() -> Bool {
			return chaineVue == chaineCachee
		}
		
		print("Bienvenue au jeu du bonhomme pendu!")
		print("Mot cachee: " + chaineCachee)
		while (!gagne() && !perdu()) {
			print("Lettres essayées: \(lettresEssayees)")
			print("Pointage: \(nbErreurs)/\(nbErreursMax)")
			print("Mot à trouver: \(chaineVue)")
			print("Entrez une lettre: ")
			
			if let entree = readLine(), entree.count == 1, let lettre = entree.first, lettre.isLetter {
				trouve(lettre: lettre)
			} else {
				print("Veuillez entrer une lettre.")
			}
		}
		
		if gagne() {
			print("Gagné!!!!!")
			print("Le film était \(chaineCachee)")
		} else if perdu() {
			print("Perdu!!!!!")
			print("Le film était \(chaineCachee)")
		}
		
		isGamerunning = false
	}
	
	RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
}
