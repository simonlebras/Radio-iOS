//
//  PlaybackManager.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxCocoa

class PlaybackManager {
    var playerStatus: BehaviorRelay<PlayerStatus> {
        return radioPlayer.playerStatus
    }
    var playerMetadata: BehaviorRelay<Radio?> {
        return radioPlayer.playerMetadata
    }
    
    private let radioPlayer: RadioPlayer
    private let queueManager: QueueManager
    
    init(radioPlayer: RadioPlayer, queueManager: QueueManager) {
        self.radioPlayer = radioPlayer
        self.queueManager = queueManager
    }
    
    func play(radio: Radio) {
        guard queueManager.currentRadio != radio || radioPlayer.playerStatus.value != .playing else {
            return
        }
        
        queueManager.currentRadio = radio
        
        radioPlayer.play(radio: queueManager.currentRadio!)
    }
    
    func play() {
        radioPlayer.play(radio: queueManager.currentRadio!)
    }
    
    func pause() {
        radioPlayer.pause()
    }
    
    func skipToNext() {
        queueManager.skipToNext()
        
        radioPlayer.play(radio: queueManager.currentRadio!)
    }
    
    func skipToPrevious() {
        queueManager.skipToPrevious()
        
        radioPlayer.play(radio: queueManager.currentRadio!)
    }
}
