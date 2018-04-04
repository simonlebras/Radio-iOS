//
//  PlayerViewController.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class PlayerViewController: UIViewController {
    @IBOutlet weak var radioLogoImageView: UIImageView!
    
    @IBOutlet weak var radioNameLabel: UILabel!
    
    @IBOutlet weak var radioDescritionLabel: UILabel!
    
    @IBOutlet weak var skipToPreviousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var skipToNextButton: UIButton!
    
    var viewModel: PlayerViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appinjector.inject(self)
        
        viewModel.playerMetadata
            .filter { $0 != nil}
            .bind { [unowned self] radio in
                self.radioNameLabel.text = radio!.name
                self.radioDescritionLabel.text = radio!.description
                self.radioLogoImageView.sd_setImage(with: URL(string: radio!.logo), placeholderImage: UIImage(named: "RadioPlaceholderIcon"))
            }
            .disposed(by: disposeBag)
        
        viewModel.playerStatus
            .bind { [unowned self] status in
                if status == .buffering || status == .playing {
                    self.playPauseButton.setImage(UIImage(named: "PauseIcon"), for: .normal)
                } else {
                    self.playPauseButton.setImage(UIImage(named: "PlayIcon"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        skipToPreviousButton.rx.tap
            .bind(onNext: { [unowned self] in
                self.viewModel.skipToPrevious()
            })
            .disposed(by: disposeBag)
        
        skipToNextButton.rx.tap
            .bind(onNext: { [unowned self] in
                self.viewModel.skipToNext()
            })
            .disposed(by: disposeBag)
        
        playPauseButton.rx.tap
            .bind(onNext: { [unowned self] in
                self.viewModel.playOrPause()
            })
            .disposed(by: disposeBag)
    }
}
