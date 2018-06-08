//
//  ChooseCharacterViewController.swift
//  MiniChallenge8iOS
//
//  Created by Bruno Cruz on 01/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChooseCharacterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    private var characters: [AvatarOptions] = [AvatarOptions.init(avatar: .rapper1, image: UIImage.init(named: "rapper1.png")!),
                                               AvatarOptions.init(avatar: .rapper2, image: UIImage.init(named: "rapper2.png")!),
                                               AvatarOptions.init(avatar: .rapper3, image: UIImage.init(named: "rapper3.png")!),
                                               AvatarOptions.init(avatar: .rapper4, image: UIImage.init(named: "rapper4.png")!)]
    
    var selectedCharacter: Avatar = .rapper1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
        
        self.nameTextField.delegate = self
        self.nameTextField.layer.cornerRadius = 6.0
        
        self.confirmButton.layer.cornerRadius = 6.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MPHelper.shared.receiverDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MPHelper.shared.receiverDelegate = nil
        MPHelper.shared.connectionDelegate = nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CharacterCollectionViewCell
        cell.characterView.image = characters[indexPath.row].image
        cell.check.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for c in collectionView.visibleCells{
            if let x = c as? CharacterCollectionViewCell {
                x.check.isHidden = true
            }
        }
        
        self.selectedCharacter = characters[indexPath.row].avatar
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],animations: {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)},completion: { finished in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5,options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    cell.check.isHidden = false
                },completion: nil)})
        }
        
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
    
    
    @IBAction func didPressConfirmButton(_ sendesr: Any) {
        if let name = self.nameTextField.text, let datum = try? JSONEncoder().encode(PlayerStruct(name: name, avatar: self.selectedCharacter)) {
            MPHelper.shared.send(data: datum, dataMode: .reliable)
        } else {
            let alert = UIAlertController.init(title: "Ops !", message: "Precisamos saber seu nome antes de continuar", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private struct AvatarOptions {
        let avatar: Avatar
        let image: UIImage
    }

    
}

extension ChooseCharacterViewController: ReceiverDelegate {
    
    func receive(data: Data, from peer: MCPeerID) {
        if let screenToBeDisplayed = try? JSONDecoder().decode(DisplayScreen.self, from: data), screenToBeDisplayed.screen == .waiting {
            if let waitingViewController = self.storyboard?.instantiateViewController(withIdentifier: "waitingViewController") {
                self.present(waitingViewController, animated: true, completion: nil)
            }
        }
    }
    
    func receive(error: Error) { }
    
}
