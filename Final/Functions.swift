//
//  Functions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/17/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation

func generate1DEnergy(Spins:[Int8], B:Double, J:Double) -> Double {
    let bohrmagneton:Double = 1
    
    //There are two sums for Energy
    var sum1:Double = Double(Spins[0])*Double(Spins[Spins.count-1]) //Periodic Boundary Condition
    var sum2:Double = 0
    
    for i in 0...Spins.count-2 { //sums over S*S+1
        sum1 = sum1 + Double(Spins[i])*Double(Spins[i+1])
    }
    sum1 = J*sum1/4 //4 comes from the binary nature of Spins
    
    for j in 0...Spins.count-1 {
        sum2 = sum2+Double(Spins[j])
    }
    sum2 = B*bohrmagneton*sum2/2
    
    let Energy:Double = -(sum1+sum2)
    
    return Energy
}

func generate1DNextNearestNeighborEnergy(Spins:[Int8], B:Double, J:Double, J2:Double) -> Double {
    //J2 is the next nearest neighbors coupling constant, typically around .5J
    
    var Energy:Double = generate1DEnergy(Spins:Spins ,B:B ,J:J) //Nearest Neighbor Energy
    
    var sum3:Double = Double(Spins[0])*Double(Spins[Spins.count-2]) + Double(Spins[1])*Double(Spins[Spins.count-1]) //Next Nearest Neighbor Boundary Conditions

    for i in 0...Spins.count-3 {//Next Nearest Neighbor Correction 
        sum3 = sum3 + Double(Spins[i])*Double(Spins[i+2])
    }
    
    Energy = Energy - J2*sum3
    
    return Energy

}

func SpinFlip1D(Spins:[Int8]) -> [Int8] {
    var newSpins:[Int8] = Spins
    let randomNumber: Int = Int.getRandomNumber(lower: 0,upper: Spins.count-1)
    newSpins[randomNumber] = -Spins[randomNumber]
    return newSpins
}
