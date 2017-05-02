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
    Energy = -J*sum1
    
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
    
    Energy = Energy - J2*sum3
    
    return Energy
    
}

//Our system is limited to a grid
//2D energy is calculated by parsing the 2D array into a series of 1D arrays
func generate2DNearestNeighborsEnergy(Spins:[[Int8]], J:Double) -> Double {
    
    var Arraylength = Spins.count
    var Array = Spins
    
    var row = Int.getRandomNumber(lower:0, upper:Arraylength-1)
    var column = Int.getRandomNumber(lower:0, upper:Arraylength-1)
    
    var energyChange: Double = 0.0
    
    //print(Arraylength)
    
    //4 corners Boundary Conditions
    if row == 0 && column == 0{
        energyChange = Double(Array[column][row] * (Array[1][0] + Array[0][1] + Array[0][Arraylength-1] + Array[Arraylength-1][0]))
    }
    if row == Arraylength-1 && column == 0{
        energyChange = Double(Array[column][row] * (Array[1][Arraylength-1] + Array[0][Arraylength-2] + Array[0][0] + Array[Arraylength-1][Arraylength-1]))
    }
    if row == 0 && column == Arraylength-1{
        energyChange = Double(Array[column][row] * (Array[Arraylength-2][0] + Array[Arraylength-1][1] + Array[0][0] + Array[Arraylength-1][Arraylength-1]))
    }
    if row == Arraylength-1 && column == Arraylength-1{
        energyChange = Double(Array[column][row] * (Array[Arraylength-1][Arraylength-2] + Array[Arraylength-2][Arraylength-1] + Array[0][Arraylength-1] + Array[Arraylength-1][0]))
    }
    
    //4 sides but not Corners Boundary Conditions
    if row == 0 && !(column == 0) && !(column == Arraylength-1){
        energyChange = Double(Array[column][row] * (Array[column-1][row] + Array[column+1][row] + Array[column][row+1] + Array[column][Arraylength-1]))
    }
    if row == Arraylength-1 && !(column == 0) && !(column == Arraylength-1){
        energyChange = Double(Array[column][row] * (Array[column-1][row] + Array[column+1][row] + Array[column][row-1] + Array[column][0]))
    }
    if column == 0 && !(row == 0) && !(row == Arraylength-1){
        energyChange = Double(Array[column][row] * (Array[column][row-1] + Array[column][row+1] + Array[column+1][row] + Array[Arraylength-1][row]))
    }
    if column == Arraylength-1 && !(row == 0) && !(row == Arraylength-1){
        energyChange = Double(Array[column][row] * (Array[column][row-1] + Array[column][row+1] + Array[column-1][row] + Array[0][row]))
    }
    
    //General Case
    if !(column == 0) && !(column == Arraylength-1) && !(row == 0) && !(row == Arraylength-1) {
        energyChange = Double(Array[column][row] * (Array[column][row-1] + Array[column][row+1] + Array[column-1][row] + Array[column+1][row]))
    }
    
    energyChange = 2*J*energyChange
    
    if energyChange == -0.0 {
        energyChange = -1*energyChange
    }
    
    return energyChange
    
    /*
    var Energy:Double = 0
    var transposedSpins:[[Int8]] = transpose2(input: Spins)
    
    let length = Spins.count
    
    for i in 0...length-1 { //columns
        Energy = Energy + generate1DEnergy(Spins: Spins[i], J: J)
    }
    
    
    for j in 0...length-1 { //rows
        Energy = Energy + generate1DEnergy(Spins: transposedSpins[j], J: J)
    }
    
    
    return Energy
 */
}

func generate2DNextNearestNeighborsEnergy(Spins:[[Int8]], J:Double, J2:Double) -> Double{
    
    
    
    var Energy:Double = 0
    var transposedSpins:[[Int8]] = transpose2(input: Spins)
    
    let length = Spins.count
    
    
    for i in 0...length-1 { //columns
        Energy = Energy + generate1DNextNearestNeighborEnergy(Spins: Spins[i], J: J, J2:J2)
    }
    
    
    for j in 0...length-1 { //rows
        Energy = Energy + generate1DNextNearestNeighborEnergy(Spins: transposedSpins[j], J: J, J2:J2)
    }
    
    //future home of diagonal contributions
    
    
    return Energy
}


//  Compare enegies function
//  Returns true if
//
/*
func compareEnergies(: Double, input2: Double) -> Bool
{
    return 0.0;
}
*/
