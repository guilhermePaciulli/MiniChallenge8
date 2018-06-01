//
//  ChooseCharacterViewController.swift
//  MiniChallenge8iOS
//
//  Created by Bruno Cruz on 01/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class ChooseCharacterViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate{
    
    var characters:[UIImage] = [#imageLiteral(resourceName: "characterPlaceholder"),#imageLiteral(resourceName: "characterPlaceholder"),#imageLiteral(resourceName: "characterPlaceholder"),#imageLiteral(resourceName: "characterPlaceholder")]
    var control = true
    var selectedCharacter = #imageLiteral(resourceName: "characterPlaceholder")
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
        
        self.nameTextField.delegate = self
        self.nameTextField.layer.cornerRadius = 6.0
        
        self.confirmButton.layer.cornerRadius = 6.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CharacterCollectionViewCell
        cell.characterView.image = characters[indexPath.row]
        cell.check.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for c in collectionView.visibleCells{
            if let x = c as? CharacterCollectionViewCell{
                x.check.isHidden = true
            }
        }
        
        self.selectedCharacter = characters[indexPath.row]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell{
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],animations: {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)},completion: { finished in
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5,options: .curveEaseOut,animations: {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                            cell.check.isHidden = false
                        },completion: nil)})}
        
    }
    
    
    
    // return keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // return keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func didPressConfirmButton(_ sender: Any) {
        if !(self.nameTextField.text?.isEmpty)!{
            //deal with:
            //self.selectedCharacter and self.nameTextField.text
        }else{
            let alert = UIAlertController.init(title: "Ops !", message: "Precisamos saber seu nome antes de continuar", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
