//
//  energyFunctions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/30/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation

func generate1DEnergy(Spins:[Int8], J:Double) -> Double {
    var Energy:Double = 0
    
    var sum1:Double = Double(Spins[0])*Double(Spins[Spins.count-1]) //Periodic Boundary Condition
    
    for i in 0...Spins.count-2 { //sums over S*S+1
        sum1 = sum1 + Double(Spins[i])*Double(Spins[i+1])
    }
    Energy = -J*2*sum1 //2 because every contribution needs to be counted twice
    
    if Energy == -0.0{
        Energy = -Energy
    }
    
    return Energy
}

func generate1DNextNearestNeighborEnergy(Spins:[Int8], J:Double, J2:Double) -> Double {
    //J2 is the next nearest neighbors coupling constant, typically around .5J
    
    var Energy:Double = generate1DEnergy(Spins:Spins,J:J) //Nearest Neighbor Energy
    
    var sum3:Double = Double(Spins[0])*Double(Spins[Spins.count-2]) + Double(Spins[1])*Double(Spins[Spins.count-1]) //Next Nearest Neighbor Boundary Conditions
    
    for i in 0...Spins.count-3 {//Next Nearest Neighbor Correction
        sum3 = sum3 + Double(Spins[i])*Double(Spins[i+2])
    }
    
    Energy = Energy - J2*2*sum3
    
    return Energy
    
}

//Our system is limited to a grid
//2D energy is calculated by parsing the 2D array into a series of 1D arrays
func generate2DNearestNeighborsEnergy(Spins:[[Int8]], J:Double) -> Double {
    
    var Energy:Double = 0
    var transposedSpins:[[Int8]] = transpose2(input: Spins)
    
    var length = Spins.count
    
    for i in 0...length-1 { //columns
        Energy = Energy + generate1DEnergy(Spins: Spins[i], J: J)
    }
    
    
    for j in 0...length-1 { //rows
        Energy = Energy + generate1DEnergy(Spins: transposedSpins[j], J: J)
    }
    
    
    return Energy
}

func generate2DNextNearestNeighborsEnergy(Spins:[[Int8]], J:Double, J2:Double) -> Double{
    
    var Energy:Double = 0
    var transposedSpins:[[Int8]] = transpose2(input: Spins)
    
    var length = Spins.count
    
    
    for i in 0...length-1 { //columns
        Energy = Energy + generate1DNextNearestNeighborEnergy(Spins: Spins[i], J: J, J2:J2)
    }
    
    
    for j in 0...length-1 { //rows
        Energy = Energy + generate1DNextNearestNeighborEnergy(Spins: transposedSpins[j], J: J, J2:J2)
    }
    
    //future home of diagonal contributions
    
    
    return Energy
}
