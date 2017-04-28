//
//  Functions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/17/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation

func generate1DEnergy(Spins:[Int8], J:Double) -> Double {
    var Energy:Double = 0
    
    var sum1:Double = Double(Spins[0])*Double(Spins[Spins.count-1]) //Periodic Boundary Condition
    
    for i in 0...Spins.count-2 { //sums over S*S+1
        sum1 = sum1 + Double(Spins[i])*Double(Spins[i+1])
    }
    Energy = J*sum1/4 //4 comes from the binary nature of Spins
    
    return Energy
}

func generate1DNextNearestNeighborEnergy(Spins:[Int8], J:Double, J2:Double) -> Double {
    //J2 is the next nearest neighbors coupling constant, typically around .5J
    
    var Energy:Double = generate1DEnergy(Spins:Spins,J:J) //Nearest Neighbor Energy
    
    var sum3:Double = Double(Spins[0])*Double(Spins[Spins.count-2]) + Double(Spins[1])*Double(Spins[Spins.count-1]) //Next Nearest Neighbor Boundary Conditions

    for i in 0...Spins.count-3 {//Next Nearest Neighbor Correction 
        sum3 = sum3 + Double(Spins[i])*Double(Spins[i+2])
    }
    
    Energy = Energy - J2*sum3
    
    return Energy

}

func SpinFlip1D(Spins:[Int8]) -> [Int8] { //swaps the spin of a random index
    var newSpins:[Int8] = Spins
    let randomNumber: Int = Int.getRandomNumber(lower: 0,upper: Spins.count-1)
    newSpins[randomNumber] = -Spins[randomNumber]
    return newSpins
}


func metropolisRelativeProbability(oldEnergy:Double, newEnergy:Double, T:Double) -> Bool {
    //Calculates Relative probability and true is new Spins should be accepted
    
    let euler: Double = 2.7182818284590452353602874713527
    //let boltzmannConstant:Double = 1.38064852*pow(10,-23) // J/K
    //GUI should have T in terms of KbT
    
    let relativeProbability: Double = pow(euler,-(newEnergy-oldEnergy)/(T))
    
    let randomNumber: Double = Double.getRandomNumber(lower:0, upper:1)
    
    if relativeProbability>randomNumber || newEnergy<oldEnergy{
        return true
    }
    else{
        return false
    }
    
}

func generateDensityofStates(Spins:[Int8]) -> [Double]{ //initializes the energy density of states g = 1.
    
    var EnergyDensity:[Double] = []
    let numberofStates:Double = pow(2.0,Double(Spins.count))
    
    for i in 0...Int(numberofStates)-1 {
        EnergyDensity.append(1)
    }
    
    
    
    return EnergyDensity
}








