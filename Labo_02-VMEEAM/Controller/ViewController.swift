//
//  ViewController.swift
//  Labo_02-VMEEAM
//
//  Created by Veronica Mendoza - Escobar on 2024-10-04.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var textFieldLettre: UITextField!
	@IBOutlet weak var labelMsgErreur: UILabel!
	@IBOutlet weak var labelLettresEssayees: UILabel!
	@IBOutlet weak var viewBonhommePendu: UIImageView!
	@IBOutlet weak var labelPointage: UILabel!
	@IBOutlet weak var labelMotTrouve: UILabel!
	
	override func viewDidLoad() {
			super.viewDidLoad()
			//Initialisation du jeu
			JeuPendu.shared.chargerFilm{ [weak self] success in
				guard let self = self, success else {return}
				
				self.labelMotTrouve.text = JeuPendu.shared.chaineVue
				self.labelMotTrouve.addCharacterSpacing()
				self.viewBonhommePendu.image = UIImage(named: JeuPendu.shared.image)
				
			}
		}

		@IBAction func btnValidation(_ sender: UIButton) {
			
			JeuPendu.shared.verifierLettre(textFieldLettre.text)
			labelMsgErreur.text = JeuPendu.shared.msgErreur
			labelMotTrouve.text = JeuPendu.shared.chaineVue
			labelMotTrouve.addCharacterSpacing()
			
			textFieldLettre.text = ""
			labelLettresEssayees.text = String(JeuPendu.shared.lettresEssayees)
			labelPointage.text = "Pointage: \(JeuPendu.shared.nbErreurs) / \(JeuPendu.shared.nbErreursMax)"
			viewBonhommePendu.image = UIImage(named: JeuPendu.shared.image)
			
			if let fin = JeuPendu.shared.finDePartie(){
				let alert = UIAlertController(title: "Game Over", message: "\(fin)", preferredStyle: .alert)
						
				let OkAction = UIAlertAction(title: "ok", style: .default, handler: nil)
				
				alert.addAction(OkAction)
				self.present(alert, animated: true)
			}
			
		}
		
		@IBAction func btnRejouer(_ sender: UIButton) {
			//Charger un nouveau film et réinitialiser le jeu
			JeuPendu.shared.chargerFilm{ [weak self] success in
				guard let self = self, success else {
					return
				}
				self.labelMotTrouve.text = JeuPendu.shared.chaineVue
				self.labelMotTrouve.addCharacterSpacing()
				self.labelLettresEssayees.text = ""
				self.labelPointage.text = "Pointage: \(JeuPendu.shared.nbErreurs) / \(JeuPendu.shared.nbErreursMax)"
				self.viewBonhommePendu.image = UIImage(named: JeuPendu.shared.image)
				self.labelMsgErreur.text = ""
				
			}
		}
	}

	extension UILabel{
		
		func addCharacterSpacing(kernValue: Double = 3){
			
			if let labelText = text, labelText.isEmpty == false{
				let attributedString = NSMutableAttributedString(string: labelText)
			
				attributedString.addAttribute(NSAttributedString.Key.kern,
											   value : kernValue,
											   range: NSRange(location: 0, length: attributedString.length - 1))
				attributedText = attributedString
			}
		}
		
		
	}


