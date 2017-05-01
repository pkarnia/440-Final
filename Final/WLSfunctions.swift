//
//  WLSfunctions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/30/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation

//initializes the energy density of states g = 1.
func generateDensityofStates(Spins:[Int8], J:Double, possibleEnergies:[Double],Log:Bool) -> [Double]{
    
    
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

//generates and compares relative probability for WLS. If true is returned then the new state should be accepted.
func WLSRelativeProbability(oldDensity:Double, newDensity:Double, Log:Bool) -> Bool {
    
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


//adds onto the existing Histogram. The function is constructed in a way that allows for N new energies to be added, then the flattness of the histogram to be calculated. We cannot know the flattness of the histogram until we have the histogram, and we keep making the histogram until it is flat enough.
func addtoWLSHistogram(currentHistogram:[Double],histogramEnergies:[Double], newEnergies:[Double],clear:Bool) -> (Histogram:[Double], isFlat:Bool, histogramEnergies:[Double]){
    
    var Histogram:[Double] = currentHistogram
    var currentEnergies:[Double] = histogramEnergies
    
    var Duplicate: (Check: Bool, index: Int)? = nil
    
    if clear{
        Histogram.removeAll()
    }
    
    
    for i in 0...newEnergies.count-1{ //checks if the newEnergy is already in the Histogram
        Duplicate = isDuplicate(Value:newEnergies[i],Array:currentEnergies)
        
        //if the new energy is already in the histogram the index where gets added onto
        if (Duplicate?.Check)!{             Histogram[(Duplicate?.index)!] = Histogram[(Duplicate?.index)!] + 1
        }
         
        // if the new energy is not in the Histogram then a new index is formed.
        // we don't car about the order the energies are in as the only thing that matters is the flattness of the histogram
        else{
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
    
}

//updates density of states function
func updateDensityofStates(densityofStates:[Double],Energy:Double, energyArray:[Double], multiplicitivefactor:Double, Log:Bool) -> [Double] {
    
    //DegeneracyFactor and density of states are the same thing
    var DegeneracyFactor:[Double] = densityofStates
    
    //determines which index to update
    let index:Int = isDuplicate(Value: Energy, Array: energyArray).index
    
    //inputs are already in log format
    if Log{
        DegeneracyFactor[index] = DegeneracyFactor[index] + log(Double(multiplicitivefactor))
    }
    else{
        DegeneracyFactor[index] = multiplicitivefactor * DegeneracyFactor[index]
    }
    return DegeneracyFactor
}

//takes square root of the factor
//Should only be called when the Histogram is flat enough to be reset
func updateMultiplicitiveFactor(multiplicitiveFactor:Double) -> Double {
    
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
}


func generateWLSSystem(numberofSpins:Int,maxIterations:Int, Dimentions:Int, T:Double,J:Double, J2: Double, Plot:Int, Log:Bool) -> [Double]  {
    //generateSpins
    
    var Spins:[Int8] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    var newSpins:[Int8] = []
    
    var possibleEnergies:[Double] = generatePossibleEnergies(Spins: Spins, J: J)
    var densityofStates:[Double] = generateDensityofStates(Spins: Spins, J: J, possibleEnergies:possibleEnergies, Log:Log)
    
    var oldEnergy:Double = generate1DEnergy(Spins: Spins, J: J)
    var oldDensity:Double = 0
    
    var newEnergy:Double = 0
    var newDensity:Double = 0
    
    var visitedEnergies:[Double] = [oldEnergy]
    
    var multiplicitiveFactor:Double = 2.71828
    
    var histogramEnergies:[Double] = [oldEnergy]
    var Histogram:[Double] = [1.0]
    
    var histogramTuple:(Histogram:[Double], isFlat: Bool, histogramEnergies:[Double]) = ([0],false,[0])
    var isFlat:Bool = false
    
    var accepted:Int = 0
    var declined:Int = 0
    
    
    //while (multiplicitiveFactor-1)>pow(10,-8){
    //while !isFlat{
    for i in 1...10000{
        
        
        oldEnergy = generate1DEnergy(Spins: Spins, J: J)
        oldDensity = getDensity(Energy: oldEnergy, densityofStates: densityofStates, energyArray:possibleEnergies)
        
        //print(oldEnergy)
        //print(oldDensity)
        
        //generate new state
        newSpins = SpinFlip1D(Spins: Spins)
        newEnergy = generate1DEnergy(Spins: newSpins, J: J)
        newDensity = getDensity(Energy: newEnergy, densityofStates: densityofStates,energyArray:possibleEnergies)
        
        //print(newEnergy)
        //print(newDensity)
        
        //checks if new state should be accepted
        if WLSRelativeProbability(oldDensity: oldDensity, newDensity: newDensity, Log:Log){
            //if accepted overwrite old spins and energies
            oldEnergy = newEnergy
            Spins = newSpins
            accepted = accepted + 1
            
        }//end of if
        else{
            declined = declined + 1
        }
        
        //update density of states and visited energies, which is an input for the histogram
        densityofStates = updateDensityofStates(densityofStates: densityofStates, Energy: oldEnergy, energyArray: possibleEnergies, multiplicitivefactor: multiplicitiveFactor, Log:Log)
        
        visitedEnergies.append(oldEnergy)
        
    }//end of 10000 iterations
    
    histogramTuple = addtoWLSHistogram(currentHistogram: Histogram, histogramEnergies: histogramEnergies, newEnergies: visitedEnergies, clear: false)
    
    Histogram = histogramTuple.Histogram
    histogramEnergies = histogramTuple.histogramEnergies
    isFlat = histogramTuple.isFlat
    //print(isFlat)
    //print(Histogram)
    
    // } //end of flat check
    
    multiplicitiveFactor = updateMultiplicitiveFactor(multiplicitiveFactor: multiplicitiveFactor)
    print(histogramEnergies)
    print(possibleEnergies)
    Histogram.removeAll()
    Histogram.append(1)
    
    histogramEnergies.removeAll()
    histogramEnergies.append(oldEnergy)
    
    visitedEnergies.removeAll()
    visitedEnergies.append(oldEnergy)
    
    isFlat = false
    // }//end of multiplicitivefactor updates
    /*for k in 0...densityofStates.count-1{
     
     densityofStates[k] = exp(densityofStates[k])
     }*/
    
    //var normalizedDOS:[Double] = normalizeDensityofStates(densityofStates: densityofStates, Spins:Spins)
    //print(densityofStates)
    //print("A",accepted)
    //print("D",declined)
    return densityofStates
}