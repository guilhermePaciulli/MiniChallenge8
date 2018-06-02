//
//  ConnectedPlayersCollectionViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 01/06/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectedPlayersCollectionViewController: UICollectionViewController {
    
    let reuseIdentifier = "connectedPlayersCollectionViewCell"
    
    var connectedPlayers: [Player] = [Player.init(name: "MC Capivara", avatar: .rapper1, peerID: MCPeerID.init(displayName: "whatever")),
                                      Player.init(name: "Erickonha", avatar: .rapper2, peerID: MCPeerID.init(displayName: "whatever")),
                                      Player.init(name: "Bruno the monge", avatar: .rapper3, peerID: MCPeerID.init(displayName: "whatever")),]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(ConnectedPlayersCollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView?.delegate = self
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.connectedPlayers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? ConnectedPlayersCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cellPlayer = self.connectedPlayers[indexPath.row]
        cell.innerView = UINib.init(nibName: "ConnectedPlayersCellView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ConnectedPlayersView
        cell.innerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size)
        cell.addSubview(cell.innerView)
        cell.innerView.rapperName.text = cellPlayer.name
        cell.innerView.rapperImage.image = cellPlayer.avatar
        return cell
    }
    
}

extension ConnectedPlayersCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
