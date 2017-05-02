//
//  WLS classes.swift
//  Final
//
//  Created by Mitchell Vaniger on 5/2/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation

class WLSSpinArray2D {
    var Array:[[Int8]] = [[]]
    var Energy:Double = 0
    var Arraylength:Int = 0
    var J:Double = 1
    
    //Held to flip spin if New state is accepted
    var newrow:Int = 0
    var newcolumn:Int = 0
    
    //should be passed into WLS
    var energyChange:Double = 0
    
    func initialize(newArray:[[Int8]],newEnergy:Double,newArraylength:Int){
        Array = newArray
        Energy = newEnergy
        Arraylength = newArraylength
    }
    
    func calculateEnergyChange(){
        var row = Int.getRandomNumber(lower:0, upper:Arraylength-1)
        var column = Int.getRandomNumber(lower:0, upper:Arraylength-1)
        
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
 
        energyChange = -2*J*energyChange
        
        if energyChange == -0.0 {
            energyChange = -1*energyChange
        }
        
        newrow = row
        newcolumn = column
        
    }
    
    func commitToSpinFlip() {
        Array[newcolumn][newrow] = -Array[newcolumn][newrow]
        Energy = Energy + energyChange
    }
 
}

class WLS {
    var Histogram:[Double] = []
    var Energies:[Double] = []
    var DOS:[Double] = []
    var multiplicitiveFactor:Double = exp(1.0)
    
    //used to calculate relative prob
    var density1:Double = 0
    var density2:Double = 0
    
    //should be passed into array class
    var acceptState:Bool = false
    
    
    var isFlat:Bool = false
    
    // initialize Histogram and DOS to 0 for every E
    func initialize(possibleEnergies:[Double]) {
        Energies = possibleEnergies
        for i in 0...Energies.count-1{
            Histogram.append(0)
            DOS.append(0)
        }
    }
    
    //Updates Histogram and DOS given a new Energy
    func updateWLS(newEnergy:Double) {
        for i in 0...Energies.count-1{
            if newEnergy == Energies[i]{
                Histogram[i] = Histogram[i] + 1
                DOS[i] = DOS[i] + log(multiplicitiveFactor)
            }
        }
    }
    
    //Checks if Histogram is flat
    //resets histogram to 0 and updates multiplicitive Factor
    func checkFlat() {
        var noZeroHistogram:[Double] = []
        var flattness:Double = 100
        
        isFlat = false
        
        for j in 0...Histogram.count-1{
            if (Histogram[j] != 0){
                noZeroHistogram.append(Histogram[j])
            }
        }
        
        //flattness = (noZeroHistogram.max()!-noZeroHistogram.min()!)/(noZeroHistogram.max()!+noZeroHistogram.min()!)
        
        var average:Double = 0
        
        for k in 0...noZeroHistogram.count-1{
            average = average + noZeroHistogram[k]
        }
        average = average/Double(noZeroHistogram.count-1)
        
        if noZeroHistogram.min()! > 0.8*average{
           isFlat = true
        }
        print("min:",noZeroHistogram.min()!,"    0.8Average", 0.8*average)
        
        //print(flattness)
        if flattness < 0.2{
            isFlat = true
        }
        
        if isFlat{
        for i in 0...Energies.count-1{
        Histogram[i] = 0
        }
        multiplicitiveFactor = pow(multiplicitiveFactor,2)
        }
    }
    
    //checks if new state should be accepted
    
    func relativeProbability(oldEnergy:Double, energyChange:Double){
        var newEnergy = oldEnergy + energyChange
        
        for i in 0...Energies.count-1{
            if oldEnergy == Energies[i]{
                density1 = DOS[i]
            }
            if newEnergy == Energies[i]{
                density2 = DOS[i]
            }
        }
        
        var relativeProbability:Double = exp(log(density1)-log(density2))
        var rng:Double = Double.getRandomNumber(lower:0, upper:1)
        print("rng",rng)
        
        if relativeProbability >= rng || density2 <= density1{
            acceptState =  true
        }
        else{
            acceptState =  false
        }

        
        
        
    }
    
    
    
    }
