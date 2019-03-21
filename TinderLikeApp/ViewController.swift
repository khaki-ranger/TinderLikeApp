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
        
        // スワイプによってカードの傾きを変えるための処理
        // 画面の中心のx座標と、カードの中心のx座標の差分
        let xFromCenter = card.center.x - view.center.x
        // x座標の差分と画面半分の長さで割ることで、距離を0から1の間に収める
        // 度数をラジアンに変換するために、最大角度45度のラジアン、0.785を掛ける
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
        // スワイプを終了（指を離した）時の処理
        if sender.state == UIGestureRecognizerState.ended {
            // 左に大きくスワイプした場合の処理
            // カードの中心のx座標が画面の左端付近を超えた場合
            // 画面の左外側に移動させる
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 250, y: card.center.y)
                })
                // カードの位置を初期値に戻す処理が発動しないように関数を抜ける
                return
            // 右に大きくスワイプした場合の処理
            // カードの中心のx座標が画面の右端付近を超えた場合
            // 画面の右外側に移動させる
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 250, y: card.center.y)
                })
                // カードの位置を初期値に戻す処理が発動しないように関数を抜ける
                return
            }
            
            // カードを初期値に戻すための処理
            // アニメーションさせる
            // 処理内容はクロージャーで記述する
            UIView.animate(withDuration: 0.2, animations: {
                // 位置を戻す
                card.center = self.centerOfCard
                // 角度を戻す
                card.transform = .identity
            })
        }
    }
    
}

