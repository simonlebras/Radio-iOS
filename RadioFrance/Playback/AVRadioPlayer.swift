//
//  RadioPlayer.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

class AVRadioPlayer: NSObject, RadioPlayer {
    let playerStatus = BehaviorRelay<PlayerStatus>(value: .none)
    let playerMetadata = BehaviorRelay<Radio?>(value: nil)
    
    private lazy var avPlayer = AVPlayer(playerItem: nil)
    
    private var currentRadio: Radio?
    private var itemStatusDisposable: Disposable?
    
    deinit {
        itemStatusDisposable?.dispose()
    }
    
    func play(radio: Radio) {
        playerStatus.accept(.buffering)
        
        if radio != currentRadio || avPlayer.error != nil {
            currentRadio = radio
            
            playerMetadata.accept(radio)
            
            itemStatusDisposable?.dispose()
            
            let item = AVPlayerItem(url: URL(string: radio.stream)!)
            itemStatusDisposable = item.rx.observe(AVPlayerStatus.self, "status")
                .filter {                  
                    switch $0 {
                    case .readyToPlay?:
                        return true
                    case .failed?:
                        return true
                    default:
                        return false
                    }
                }
                .map({ status -> PlayerStatus in
                    switch status {
                    case .readyToPlay?:
                        return .playing
                    case .failed?:
                        return .error
                    default:
                        preconditionFailure()
                    }
                })
                .bind(to: playerStatus)
            
            avPlayer.replaceCurrentItem(with: item)
        }
        
        avPlayer.play()
    }
    
    func pause() {
        avPlayer.pause()
        
        playerStatus.accept(.paused)
    }
}
