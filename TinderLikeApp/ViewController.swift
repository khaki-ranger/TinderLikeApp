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
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    
    var centerOfCard:CGPoint!
    // 実際に表示されるカードを格納する配列
    var people = [UIView]()
    // ベースに関連づけるカードを制御するための変数
    var selectedCardCount: Int = 0
    
    let name = ["ほのか", "あかね", "みほ", "カルロス"]
    var likedName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centerOfCard = basicCard.center
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func likebuttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 500, y: self.people[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0
        likedName.append(name[selectedCardCount])
        // カードの中身を変更するための処理
        selectedCardCount += 1
        // 最後のカードがスワイプされた時の処理
        if selectedCardCount >= people.count {
            performSegue(withIdentifier: "PushList", sender: self)
        }
    }
    
    @IBAction func dislikebuttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 500, y: self.people[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0
        // カードの中身を変更するための処理
        selectedCardCount += 1
        // 最後のカードがスワイプされた時の処理
        if selectedCardCount >= people.count {
            performSegue(withIdentifier: "PushList", sender: self)
        }
    }
    
    func resetCard() {
        // 位置を戻す
        basicCard.center = self.centerOfCard
        // 角度を戻す
        basicCard.transform = .identity
    }
    
    // セグエを実装する前にする処理
    // Likeに選択したカードの配列を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushList" {
            let vc = segue.destination as! ListViewController
            vc.likedName = likedName
        }
    }

    // MARK: methods
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // カードの位置をベースと同期させる
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        // スワイプによってカードの傾きを変えるための処理
        // 画面の中心のx座標と、カードの中心のx座標の差分
        let xFromCenter = card.center.x - view.center.x
        // x座標の差分と画面半分の長さで割ることで、距離を0から1の間に収める
        // 度数をラジアンに変換するために、最大角度45度のラジアン、0.785を掛ける
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        // カードの角度をベースと同期させる
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785)
        
        // BadもしくはGoodの画像を表示させるための処理
        if xFromCenter > 0 {
            likeImageView.image = #imageLiteral(resourceName: "good")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.red
        } else if xFromCenter < 0 {
            likeImageView.image = #imageLiteral(resourceName: "bad")
            likeImageView.alpha = 1
            likeImageView.tintColor = UIColor.blue
        }
        
        // スワイプを終了（指を離した）時の処理
        if sender.state == UIGestureRecognizerState.ended {
            // 左に大きくスワイプした場合の処理
            // カードの中心のx座標が画面の左端付近を超えた場合
            // 画面の左外側に移動させる
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 250, y: self.people[self.selectedCardCount].center.y)
                })
                likeImageView.alpha = 0
                // カードの中身を変更するための処理
                selectedCardCount += 1
                // 最後のカードがスワイプされた時の処理
                if selectedCardCount >= people.count {
                    performSegue(withIdentifier: "PushList", sender: self)
                }
                // カードの位置を初期値に戻す処理が発動しないように関数を抜ける
                return
            // 右に大きくスワイプした場合の処理
            // カードの中心のx座標が画面の右端付近を超えた場合
            // 画面の右外側に移動させる
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.resetCard()
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 250, y: self.people[self.selectedCardCount].center.y)
                })
                likeImageView.alpha = 0
                likedName.append(name[selectedCardCount])
                // カードの中身を変更するための処理
                selectedCardCount += 1
                // 最後のカードがスワイプされた時の処理
                if selectedCardCount >= people.count {
                    performSegue(withIdentifier: "PushList", sender: self)
                }
                // カードの位置を初期値に戻す処理が発動しないように関数を抜ける
                return
            }
            
            // 初期値に戻すための処理
            // アニメーションさせる
            // 処理内容はクロージャーで記述する
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                self.people[self.selectedCardCount].transform = .identity
            })
            likeImageView.alpha = 0
        }
    }
    
}

