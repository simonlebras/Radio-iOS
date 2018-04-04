//
//  AppInjector.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 31/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

class AppInjector {
    private var appSchedulers: AppSchedulers?
    
    private var radioSource: RadioSource?
    
    private var playbackManager: PlaybackManager?
    
    // MARK: AppSchedulers
    func resolveAppSchedulers() -> AppSchedulers {
        appSchedulers = AppSchedulers()
        
        return appSchedulers!
    }
    
    // MARK: Playback
    func resolvePlaybackManager(radioPlayer: RadioPlayer, queueManager: QueueManager) -> PlaybackManager {
        playbackManager = PlaybackManager(radioPlayer: radioPlayer, queueManager: queueManager)
        
        return playbackManager!
    }
    
    func resolveRadioPlayer() -> RadioPlayer {
        return AVRadioPlayer()
    }
    
    func resolveQueueManager(radioSource: RadioSource) -> QueueManager {
        return QueueManager(radioSource: radioSource)
    }
    
    // MARK: RadioSource
    func resolveRadioSource(appSchedulers: AppSchedulers) -> RadioSource {
        radioSource = RemoteRadioSource(appSchedulers: appSchedulers)
        
        return radioSource!
    }
    
    // MARK: RootViewController
    func inject(_ viewController: RootViewController) {
        let appSchedulers = self.appSchedulers ?? resolveAppSchedulers()
        let radioSource = self.radioSource ?? resolveRadioSource(appSchedulers: appSchedulers)
        let playbackManager = self.playbackManager ?? resolvePlaybackManager(radioPlayer: resolveRadioPlayer(), queueManager: resolveQueueManager(radioSource: radioSource))
        let viewModel = resolveRootViewModel(playbackManager: playbackManager)
        
        viewController.viewModel = viewModel
    }
    
    func resolveRootViewModel(playbackManager: PlaybackManager) -> RootViewModel {
        return RootViewModel(playbackManager: playbackManager)
    }
    
    // MARK: PlayerViewController
    func inject(_ viewController: PlayerViewController) {
        let appSchedulers = self.appSchedulers ?? resolveAppSchedulers()
        let radioSource = self.radioSource ?? resolveRadioSource(appSchedulers: appSchedulers)
        let playbackManager = self.playbackManager ?? resolvePlaybackManager(radioPlayer: resolveRadioPlayer(), queueManager: resolveQueueManager(radioSource: radioSource))
        let viewModel = resolvePlayerViewModel(playbackManager: playbackManager)
        
        viewController.viewModel = viewModel
    }
    
    func resolvePlayerViewModel(playbackManager: PlaybackManager) -> PlayerViewModel {
        return PlayerViewModel(playbackManager: playbackManager)
    }
    
    // MARK: RadioListViewController
    func inject(_ viewController: RadioListViewController) {
        let appSchedulers = self.appSchedulers ?? resolveAppSchedulers()
        let radioSource = self.radioSource ?? resolveRadioSource(appSchedulers: appSchedulers)
        let playbackManager = self.playbackManager ?? resolvePlaybackManager(radioPlayer: resolveRadioPlayer(), queueManager: resolveQueueManager(radioSource: radioSource))
        let viewModel = resolveRadioListViewModel(radioSource: radioSource, playbackManager: playbackManager, appSchedulers: appSchedulers)
        
        viewController.viewModel = viewModel
        viewController.appSchedulers = appSchedulers
    }
    
    func resolveRadioListViewModel(radioSource: RadioSource, playbackManager: PlaybackManager, appSchedulers: AppSchedulers) -> RadioListViewModel {
        return RadioListViewModel(radioSource: radioSource, playbackManager: playbackManager, appSchedulers: appSchedulers)
    }
}
