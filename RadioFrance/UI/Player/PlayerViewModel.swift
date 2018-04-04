//
//  PlayerViewModel.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift
import RxCocoa

class PlayerViewModel {
    var playerStatus: BehaviorRelay<PlayerStatus> {
        return playbackManager.playerStatus
    }
    var playerMetadata: BehaviorRelay<Radio?> {
        return playbackManager.playerMetadata
    }
    
    private let playbackManager: PlaybackManager
    
    init(playbackManager: PlaybackManager) {
        self.playbackManager = playbackManager
    }
    
    func playOrPause() {
        if playerStatus.value == .playing || playerStatus.value == .buffering {
            playbackManager.pause()
        } else {
            playbackManager.play()
        }
    }
    
    func skipToNext() {
        playbackManager.skipToNext()
    }
    
    func skipToPrevious() {
        playbackManager.skipToPrevious()
    }
}
