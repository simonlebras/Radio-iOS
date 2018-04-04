//
//  RootViewController.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 30/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var bottomPlayerViewContraint: NSLayoutConstraint!
    
    var viewModel: RootViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appinjector.inject(self)
        
        viewModel.playerMetadata
            .filter { $0 != nil}
            .take(1)
            .bind { [unowned self] _ in
                self.playerView.layer.shadowOpacity = 0.7
                self.playerView.layer.shadowOffset = CGSize(width: 0, height: 3)
                self.playerView.layer.shadowRadius = 4.0
                self.playerView.layer.shadowColor = UIColor.darkGray.cgColor
                
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0,
                    options: [.curveEaseOut],
                    animations: {
                        self.bottomPlayerViewContraint.constant += self.playerView.frame.height
                        
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            }
            .disposed(by: disposeBag)
    }
}
