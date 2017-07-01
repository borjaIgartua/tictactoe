//
//  ViewController.swift
//  TicTacToe
//
//  Created by Borja Igartua Pastor on 19/5/17.
//  Copyright © 2017 Borja Igartua Pastor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var boardButtons: [UIButton]!

    enum Turn {
        case circle, cross
    }
    
    var turn: Turn = .circle
    
    var scores = [ ["","",""], ["","",""], ["","",""] ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func squarePressed(_ sender: UIButton) {
            
        
        let currentImage = sender.image(for: .normal)
        
        if currentImage == nil {
            
            let circleImage = UIImage(named: "circle_icon.png")!.withRenderingMode(.alwaysOriginal)
            sender.setImage(circleImage, for: .normal)
        
            writeScore(sender)
            self.turn = .cross
            checkWinner()
        }
    }
    
    func checkWinner() {
        
        let score = evaluate(scores: scores)
        if let score = score {
            
            let alert = UIAlertController()
            alert.message = "El ganador es: \(score)"
            
            let reset = UIAlertAction(title: "aceptar", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
                
                self.scores = [ ["","",""], ["","",""], ["","",""] ]
                for button in self.boardButtons {
                    button.setImage(nil, for: .normal)
                    self.turn = .circle
                }
            })
            
            
            alert.addAction(reset)
            self.present(alert, animated: true, completion: nil)
            
        } else if tie() {
            
            let a
            
            let reset = UIAlertAction(title: "aceptar", style: UIAlertActionStyle.default, handler: { [unowned self] (action) in
                
                self.scores = [ ["","",""], ["","",""], ["","",""] ]
                for button in self.boardButtons {
                    button.setImage(nil, for: .normal)
                    self.turn = .circle
                }
            })
            
            
            alert.addAction(reset)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if turn == .cross {
                
                //TODO: disable interfaz while cross are painting
                Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(ViewController.drawCrossBestMove),
                                     userInfo: nil,
                                     repeats: false)
            }
        }
    }
    
    @objc func drawCrossBestMove() {
        
        let point = findBestMove(scores: &scores)
        let index = point.row*3 + point.col
        let button = self.boardButtons[index]
        
        let crossImage = UIImage(named: "cross_icon.png")!.withRenderingMode(.alwaysOriginal)
        button.setImage(crossImage, for: .normal)
        
        scores[point.row][point.col] = "X"
        self.turn = .circle
        
        checkWinner()
    }
    
    func writeScore(_ button: UIButton) {
        
        let score = self.turn == .circle ? "O" : "X"
        
        if let index = boardButtons.index(of: button) {
            let section = index / 3
            let row = index % 3            
            scores[section][row] = score
            
            print(scores)
        }
    }
    
    func tie() -> Bool {
        
        for i in scores {
            for j in i {
                if j.isEmpty {
                    return false
                }
            }
        }
        
        return true
    }
}

