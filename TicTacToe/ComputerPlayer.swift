//
//  ComputerPlayer.swift
//  TicTacToe
//
//  Created by Borja Igartua Pastor on 28/5/17.
//  Copyright © 2017 Borja Igartua Pastor. All rights reserved.
//

func isMovesLeft(scores: [[String]]) -> Bool{
    for line in scores {
        for el in line {
            if(el.isEmpty) {
                return true
            }
        }
    }
    return false
}

/**
 * Evaluate if any player has wone
 *
 * @return 10 or -1O if there are a winner, 0 otherwise
 */
func evaluate(scores: [[String]]) -> String? {
    
    //search winner horizontaly
    for line in scores {
        let jointLine = line.joined()
        if !jointLine.isEmpty {
            if line[0] == line[1] && line[0] == line[2] {
                return line[0]
            }
        }
    }
    
    //search winner verticaly
    for n in 0...2 {
        
        if !scores[0][n].isEmpty {
            let a = scores[0][n]
            let b = scores[1][n]
            let c = scores[2][n]
            
            if a == b && a == c {
                return a
            }
        }
    }
    
    // Checking for Diagonals
    if scores[0][0] == scores[1][1] &&
       scores[1][1] == scores[2][2] {
        
        if (!(scores[0][0].isEmpty || scores[1][1].isEmpty || scores[2][2].isEmpty)) {
            return scores[0][0]
        }
    }
    if scores[2][0] == scores[1][1] &&
       scores[1][1] == scores[0][2] {
        
        if (!(scores[2][0].isEmpty || scores[1][1].isEmpty || scores[0][2].isEmpty)) {
            return scores[2][0]
        }
    }
    
    return nil
}



func minimax(scores: inout [[String]], depth: Int, isMax: Bool) -> Int {
    
    let score = evaluate(scores: scores)
    
    if score == "X" {
        return 10
    }
    
    if score == "O" {
        return -10
    }
    
    
    if isMovesLeft(scores: scores) == false {
        return 0
    }
    
    if isMax {
        
        var best = -1000
        for i in 0...scores.endIndex-1 {
            let line = scores[i]
            for j in 0...line.endIndex-1 {
                let el = line[j]
                if el.isEmpty {
                    
                    scores[i][j] = "X"
                    best = max(best, minimax(scores: &scores, depth: depth+1, isMax: !isMax))
                    scores[i][j] = ""
                }
            }
        }
        return best
        
    } else {
        
        var best = 1000
        
        for i in 0...scores.endIndex-1 {
            let line = scores[i]
            for j in 0...line.endIndex-1 {
                let el = line[j]
                if el.isEmpty {
                    
                    scores[i][j] = "O"
                    print(scores)
                    best = min(best, minimax(scores: &scores, depth: depth+1, isMax: !isMax))
                    scores[i][j] = ""
                }
            }
        }
        
        return best
    }
}

func findBestMove(scores: inout [[String]]) -> (row: Int, col: Int) {
    var bestVal = -1000
    var bestMove = (row: -1, col: -1)
    
    for i in 0...scores.endIndex-1 {
        let line = scores[i]
        for j in 0...line.endIndex-1 {
            let el = line[j]
            if el.isEmpty {
                
                scores[i][j] = "X"
                let moveVal = minimax(scores: &scores, depth: 0, isMax: false)
                scores[i][j] = ""
                
                if moveVal > bestVal {
                    bestMove.row = i
                    bestMove.col = j
                    bestVal = moveVal
                }

            }
        }
    }
    return bestMove
}
