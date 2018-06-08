//
//  ConnectedPlayersCollectionViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 01/06/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectedPlayersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    let reuseIdentifier = "connectedPlayersCollectionViewCell"
    
    var connectedPlayers: [Player] = []
    
    let minimumPlayers = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(ConnectedPlayersCollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MPHelper.shared.receiverDelegate = self
        MPHelper.shared.connectionDelegate = self
        MPHelper.shared.startAdvertesing()
        
        let appleTVPlayer = Player.init(name: "mc t-vos",
                                        avatar: Avatar(rawValue: "rapper\((arc4random_uniform(4) + 1)).png")!,
                                        peerID: MCPeerID.init(displayName: "Hey"))
        self.connectedPlayers.append(appleTVPlayer)
        self.updateStartButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MPHelper.shared.connectionDelegate = nil
        MPHelper.shared.receiverDelegate = nil
        MPHelper.shared.stopAdvertising()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.connectedPlayers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? ConnectedPlayersCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let innerView = cell.innerView { innerView.removeFromSuperview() }
        cell.innerView = UINib.init(nibName: "ConnectedPlayersCellView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ConnectedPlayersView
        cell.innerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size)
        cell.addSubview(cell.innerView)

        let cellPlayer = self.connectedPlayers[indexPath.row]
        cell.innerView.rapperName.text = cellPlayer.name
        cell.innerView.rapperImage.image = cellPlayer.avatar

        return cell
    }
    
    @IBAction func didPressStart(_ sender: Any) {
        if self.connectedPlayers.count >= self.minimumPlayers {
            if let preBattleViewController = self.storyboard?.instantiateViewController(withIdentifier: "preBattleViewController") as? PreBattleViewControllerTVOS {
                self.connectedPlayers = self.connectedPlayers.filter({ $0.name != "conectando..." })
                preBattleViewController.championship = Championship(players: self.connectedPlayers)
                self.present(preBattleViewController, animated: true, completion: nil)
            }
        }
    }
    
    func updateStartButton() {
        let filtered = self.connectedPlayers.filter({ $0.name != "conectando..." })
        if filtered.count < self.minimumPlayers {
            self.instructionsLabel.text = "use o app no iphone para entrar - mínimo são 3 jogadores"
            self.startButton.isEnabled = false
        } else if filtered.count <= 6 {
            self.instructionsLabel.text = "use o app no iphone para entrar"
            self.startButton.isEnabled = true
        } else {
            self.instructionsLabel.text = "pressione o botão do controle para começar"
            self.startButton.isEnabled = true
        }
    }
}

extension ConnectedPlayersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }
        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset
        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        guard totalCellWidth < contentWidth else { return insets }
        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width / 7, height: self.view.frame.size.width / 7)
    }
}

extension ConnectedPlayersViewController: ConnectionDelegate {
    
    func didBeginConnection(to peerID: MCPeerID) {}
    
    func isConnecting(to peerID: MCPeerID) {}
    
    func didEstablishConnection(with peerID: MCPeerID) {
        let notDefinedPlayer = Player(name: "conectando...", avatar: .notDefined, peerID: peerID)
        self.connectedPlayers.append(notDefinedPlayer)
        
        if let editCharData = try? JSONEncoder().encode(DisplayScreen(screen: .characterEditing)) {
            MPHelper.shared.send(data: editCharData, dataMode: .reliable, for: [peerID])
        }
        
        self.collectionView?.reloadData()
    }
    
    func didLostConnection(with peerID: MCPeerID) {
        self.connectedPlayers = self.connectedPlayers.filter({ $0.peerID != peerID })
        self.collectionView?.reloadData()
        self.updateStartButton()
    }
    
}

extension ConnectedPlayersViewController: ReceiverDelegate {
    
    func receive(data: Data, from peer: MCPeerID) {
        if let playerDataAdded = self.connectedPlayers.filter({ $0.peerID == peer }).first,
           let playerData = try? JSONDecoder().decode(PlayerStruct.self, from: data),
           let waitScreenData = try? JSONEncoder().encode(DisplayScreen(screen: .waiting)) {
            
            playerDataAdded.name = playerData.name
            playerDataAdded.setAvatar(avatar: playerData.avatar)
            MPHelper.shared.send(data: waitScreenData, dataMode: .reliable, for: [peer])
            self.collectionView?.reloadData()
            self.updateStartButton()
        }
    }
    
    func receive(error: Error) { }
    
}
