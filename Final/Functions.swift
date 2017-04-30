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



/*func metropolisRelativeProbability(oldEnergy:Double, newEnergy:Double, T:Double) -> Bool {
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
    
}*/

/*func generateDensityofStates(Spins:[Int8], J:Double, possibleEnergies:[Double],Log:Bool) -> [Double]{ //initializes the energy density of states g = 1.
    
    
    var EnergyDensity:[Double] = []
    let numberofEnergies:Int = possibleEnergies.count
    
    if Log{
        for _ in 0...numberofEnergies-1 {
            EnergyDensity.append(log(Double(1)))
        }

    }
    else{
        for _ in 0...numberofEnergies-1 {
            EnergyDensity.append(1)
        }
    }
    return EnergyDensity
}


func generatePossibleEnergies(Spins:[Int8],J:Double) -> [Double] { //gives all possible values for Energy. Will be used to determine of density of states, which is a function of Energy. Some of these values will never be accessed and will have to be removed after the simulation has run its course. These Energies will have g(E) = 1 and E =/= 2N. Should be done in Histogram function
    
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


func WLSRelativeProbability(oldDensity:Double, newDensity:Double, Log:Bool) -> Bool { //generates and compares relative probability for WLS. If 1 is returned then the new state should be accepted.
    
    var relativeProbability:Double = 0
    
    if Log{
        relativeProbability = exp(oldDensity) - exp(newDensity)
    }
    else{
        relativeProbability = oldDensity/newDensity
    }
    
    let randomNumber:Double = Double.getRandomNumber(lower:0, upper:1)
    
    if relativeProbability >= randomNumber || newDensity <= oldDensity{
        return true
    }
    else{
        return false
    }
}



func addtoWLSHistogram(currentHistogram:[Double],histogramEnergies:[Double], newEnergies:[Double],clear:Bool) -> (Histogram:[Double], isFlat:Bool, histogramEnergies:[Double]){ //adds onto the existing Histogram. The function is constructed in a way that allows for N new energies to be added, then the flattness of the histogram to be calculated. We cannot know the flattness of the histogram until we have the histogram, and we keep making the histogram until it is flat enough.
    
    var Histogram:[Double] = currentHistogram
    var currentEnergies:[Double] = histogramEnergies
    
    var Duplicate: (Check: Bool, index: Int)? = nil
    
    if clear{
        Histogram.removeAll()
    }
    
    
    for i in 0...newEnergies.count-1{ //checks if the newEnergy is already in the Histogram
        Duplicate = isDuplicate(Value:newEnergies[i],Array:currentEnergies)
        
        if (Duplicate?.Check)!{ //if the new energy is already in the histogram the index where gets added onto
            Histogram[(Duplicate?.index)!] = Histogram[(Duplicate?.index)!] + 1
        }
        
        else{ // if the new energy is not in the Histogram then a new index is formed.
            Histogram.append(1)
            currentEnergies.append(newEnergies[i])
        }
    }
    
    let flattness:Double = (Histogram.max()! - Histogram.min()!)/(Histogram.max()! + Histogram.min()!)
    var isFlat:Bool = false
    
    if flattness < 0.2{ //checks if the histogram is flat enough
        isFlat = true
    }
    
    return (Histogram, isFlat, currentEnergies)
    
}*/

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

/*func updateDensityofStates(densityofStates:[Double],Energy:Double, energyArray:[Double], multiplicitivefactor:Double, Log:Bool) -> [Double] { //updates density of states function
    
    var DegeneracyFactor:[Double] = densityofStates //DegeneracyFactor and density of states are the same thing
    let index:Int = isDuplicate(Value: Energy, Array: energyArray).index //determines which index to update
    if Log{
        DegeneracyFactor[index] = DegeneracyFactor[index] + log(Double(multiplicitivefactor))
    }
    else{
        DegeneracyFactor[index] = multiplicitivefactor * DegeneracyFactor[index]
    }
    return DegeneracyFactor
}

func updateMultiplicitiveFactor(multiplicitiveFactor:Double) -> Double { //takes square root of the factor
    
    return pow(multiplicitiveFactor,1/2)
    
}

func getDensity(Energy:Double, densityofStates:[Double], energyArray:[Double]) -> Double { //gets Energy density from a given energy
    
    var density:Double = 0
    
    let index:Int = isDuplicate(Value: Energy, Array: energyArray).index
    
    density = densityofStates[index]
    
    return density
}

func normalizeDensityofStates(densityofStates:[Double], Spins:[Int8]) -> [Double] {
    var normalizedDOS:[Double] = []
    
    let numberofSpins:Double = Double(Spins.count)
    
    var normalization:Double = 0
    
    for i in 0...densityofStates.count-1 {
        normalization = normalization + densityofStates[i]
    }
    
    normalization = pow(2, numberofSpins) / normalization
    
    for j in 0...densityofStates.count-1 {
        normalizedDOS.append(normalization * densityofStates[j])
    }
    
    return normalizedDOS
}*/




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













