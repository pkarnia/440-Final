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
    Energy = J*2*sum1 //2 because every contribution needs to be counted twice
    
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

func generateDensityofStates(Spins:[Int8], J:Double) -> [Double]{ //initializes the energy density of states g = 1.
    
    var possibleEnergies:[Double] = generatePossibleEnergies(Spins:Spins, J:J)
    
    var EnergyDensity:[Double] = []
    let numberofEnergies:Int = possibleEnergies.count
    
    for i in 0...numberofEnergies-1 {
        EnergyDensity.append(1)
    }
    
    return EnergyDensity
}


func generatePossibleEnergies(Spins:[Int8],J:Double) -> [Double] { //gives all possible values for Energy. Will be used to determine of density of states, which is a function of Energy. Some of these values will never be accessed and will have to be removed after the simulation has run its course. These Energies will have g(E) = 1 and E =/= 2N
    
    var Energies:[Double] = []
    
    for i in 0...Spins.count-1{
        Energies.append(J*Double(-Spins.count+i))
    }
    
   return Energies
}


func WLSRelativeProbability(oldDensity:Double, newDensity:Double) -> Bool { //generates and compares relative probability for WLS. If 1 is returned then the new state should be accepted.
    
    let relativeProbability:Double = oldDensity/newDensity
    let randomNumber:Double = Double.getRandomNumber(lower:0, upper:1)
    
    if relativeProbability>randomNumber {
        return true
    }
    if newDensity < oldDensity {
        return true
    }
    else{
        return false
    }
}



func addtoWLSHistogram(currentHistogram:[Double],histogramEnergies:[Double], newEnergies:[Double],clear:Bool) -> (Histogram:[Double], isFlat:Bool){ //adds onto the existing Histogram. The function is constructed in a way that allows for N new energies to be added, then the flattness of the histogram to be calculated. We cannot know the flattness of the histogram until we have the histogram, and we keep making the histogram until it is flat enough.
    
    var Histogram:[Double] = currentHistogram
    var currentEnergies:[Double] = histogramEnergies
    
    var Duplicate: (Check: Bool, index: Int)? = nil
    
    if clear{
        Histogram.removeAll()
    }
    
    
    for i in 0...newEnergies.count-1{ //checks if the newEnergy is already in the Histogram
        Duplicate = isDuplicate(Value:newEnergies[i],Array:histogramEnergies)
        
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
    
    return (Histogram, isFlat)
    
}

func isDuplicate(Value:Double,Array:[Double]) -> (Check:Bool, index:Int) {//generic function to check if a value is in the array. Will be used to fill the Histogram. Returns 1 if the value is a duplicate.
   
    var whattoReturn: (Check: Bool, index: Int)? = (Check:false, index:0)
    
    for i in 0...Array.count-1{
        if (Value-Array[i])<pow(10,-10){
            whattoReturn?.Check = true
            whattoReturn?.index = i
            break
        }
    }
    return whattoReturn!
}
