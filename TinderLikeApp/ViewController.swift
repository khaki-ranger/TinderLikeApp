//
//  ViewController.swift
//  TinderLikeApp
//
//  Created by 寺島 洋平 on 2019/03/20.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var basicCard: UIView!
    
    var centerOfCard:CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centerOfCard = basicCard.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: methods
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        // スワイプを終了（指を離した）時の処理
        if sender.state == UIGestureRecognizerState.ended {
            // アニメーションさせる
            // 処理内容はクロージャーで記述する
            UIView.animate(withDuration: 0.2, animations: {
                // カードの位置を初期値に戻す
                card.center = self.centerOfCard
            })
        }
    }
    
}

