//
//  Functions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/17/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation
import CorePlot


func SpinFlip1D(Spins:[Int8]) -> [Int8] { //swaps the spin of a random index
    var newSpins:[Int8] = Spins
    let randomNumber: Int = Int.getRandomNumber(lower: 0,upper: Spins.count-1)
    newSpins[randomNumber] = -Spins[randomNumber]
    return newSpins
}

func generatePossibleEnergies(Spins:[Int8],J:Double) -> [Double] { //gives all possible values for Energy. Will be used to determine of density of states, which is a function of Energy.
    
    var Energies:[Double] = [-2*Double(Spins.count)]
    
    var counter:Int = 0
    while (Energies[counter] - 2*Double(Spins.count)) < -pow(10,-10){
        Energies.append(Energies[counter] + 8.0)
        counter = counter + 1
    }
    
    /*for i in 0...Spins.count-1{
     Energies.append(2*J*Double(-Spins.count+i*4))
     }*/
    
    return Energies
}




func isDuplicate(Value:Double,Array:[Double]) -> (Check:Bool, index:Int) {//generic function to check if a value is in the array. Will be used to fill the Histogram. Returns 1 if the value is a duplicate.
   
    var whattoReturn: (Check: Bool, index: Int)? = (Check:false, index:0)
    
    for i in 0...Array.count-1{
        if Value == Array[i] {
            whattoReturn?.Check = true
            whattoReturn?.index = i
            break
        }
    }
    return whattoReturn!
}





public func transpose2<T>(input: [[T]]) -> [[T]] { //generic transpose function I stole from the internet
    if input.isEmpty { return [[T]]() }
    let count = input[0].count
    var out = [[T]](repeating: [T](), count: count)
    for outer in input {
        for (index, inner) in outer.enumerated() {
            out[index].append(inner)
        }
    }
    
    return out
}













