//
//  Functions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/17/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation
import CorePlot

//swaps the spin of a random index
func SpinFlip1D(Spins:[Int8]) -> [Int8] {
    var newSpins:[Int8] = Spins
    let randomNumber: Int = Int.getRandomNumber(lower: 0,upper: Spins.count-1)
    newSpins[randomNumber] = -Spins[randomNumber]
    return newSpins
}

//swaps the spin of a random index
func SpinFlip2D(Spins:[[Int8]]) -> [[Int8]] {
    var newSpins:[[Int8]] = Spins
    let rng1: Int = Int.getRandomNumber(lower: 0,upper: Spins.count-1)
    let rng2: Int = Int.getRandomNumber(lower: 0,upper: Spins.count-1)
    newSpins[rng1][rng2] = -Spins[rng1][rng2]
    return newSpins
}

func generatePossibleEnergies(Spins:[Int8],J:Double) -> [Double] { //gives all possible values for Energy. Will be used to determine of density of states, which is a function of Energy.
    
    var Energies:[Double] = [-2*Double(Spins.count)]
    
    var counter:Int = 0
    while (Energies[counter] - 2.0*Double(Spins.count)) < -pow(10,-10){
        Energies.append(Energies[counter] + 2.0)
        counter = counter + 1
    }
    print(Energies)
    return Energies
}

func generatePossible2DEnergies(Spins:[[Int8]],J:Double) -> [Double] { //gives all possible values for Energy. Will be used to determine of density of states, which is a function of Energy.
    
    var Energies:[Double] = [-2*pow(Double(Spins.count),2)]
    
    var counter:Int = 0
    while (Energies[counter] - 2.0*pow(Double(Spins.count),2)) < -pow(10,-10){
        Energies.append(Energies[counter] + 4.0)
        counter = counter + 1
    }
    
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


//this will not work for next nearest neighbors. The theory simply doesn't exist
func analyticInternalEnergy(Spins:[Int8], T:Double,J:Double) -> Double {
   
    var internalEnergy:Double = 0
    
    let coefficient:Double = J * Double(Spins.count)
    
    let exponentialFactor:Double = J/T
    
    internalEnergy = -coefficient*(exp(exponentialFactor)-exp(-exponentialFactor))/(exp(exponentialFactor)+exp(-exponentialFactor))
    
    return internalEnergy
}

//1D only
//eqn taken from book, Set B = 0 and this is what it is.
func analyticMagnetization(T:Double, J:Double) -> Double {
    
    
    var magnetization:Double = exp(J/T)
    
    return magnetization
}

//generic average function
//will be used to calculate average internal energy over several runs
func calculateAverage(Array:[Double]) -> Double {
    var average:Double = 0
    var count:Int = Array.count
    
    for i in 0...count-1{
        average = average + Array[i]
    }
    
    average = average/Double(count)
    
    return average
}

//average of squared values over several runs
func energyFlucuations(energyArray:[Double]) -> Double {
    var flux:Double = 0
    var count:Int = energyArray.count
    
    for i in 0...count-1{
        flux = flux + energyArray[i]*energyArray[i]
    }
    
    flux = flux/Double(count)
    
    return flux

}


func calculateSpecificHeat(energyArray:[Double],count:Double,J:Double,T:Double) -> Double {
    var specificHeat:Double = 0
    
    var averageEnergy:Double = calculateAverage(Array: energyArray)
    var energyFlux:Double = energyFlucuations(energyArray: energyArray)
    
    specificHeat = 8.617*pow(10,5)*(energyFlux-pow(averageEnergy,2))/(pow(T,2)*pow(count,2))
    
    return specificHeat
}

//Picks an energy function given dimentions and energy Type
func energySwitch(Dimentions:Int, energyType:Int, nearestNeighborCoupling:Double, nextNearestNeighborCoupling:Double, array1D:[Int8], array2D:[[Int8]]) -> Double {
    //Generating Energy
    if energyType == 0 && Dimentions == 1{
        //NN 1D Energy
        return generate1DEnergy(Spins:array1D, J:nearestNeighborCoupling)
    }
    if energyType == 0 && Dimentions == 2{
        // NN 2D Energy
        return generate2DNearestNeighborsEnergy(Spins:array2D,J:nearestNeighborCoupling)
    }
    if energyType == 1 && Dimentions == 1{
        // NNN 1D Energy
        return generate1DNextNearestNeighborEnergy(Spins:array1D, J:nearestNeighborCoupling, J2:nextNearestNeighborCoupling)
    }
    if energyType == 1 && Dimentions == 2{
        // NNN 2D Energy
        return generate2DNextNearestNeighborsEnergy(Spins:array2D, J:nearestNeighborCoupling, J2:nextNearestNeighborCoupling)
    }
    else{
        return 404
    }
    
}

func algorithmSwitch(Dimentions:Int, energyType:Int, nearestNeighborCoupling:Double, nextNearestNeighborCoupling:Double, startType:Int, maxiterations:Int, temperature:Double, NumberofSpins:Int, Numberof2DSpins:Int) -> (spins1D:[Int8],spins2D:[[Int8]]) {
    
    var spins1D:[Int8] = []
    var spins2D:[[Int8]] = [[]]
    
    
    //Generating Array
        if Dimentions == 1{
        //1D metropolis
        spins1D = generateMetropolisSystem(numberofSpins:Numberof2DSpins, maxIterations:maxiterations, T:temperature, J:nearestNeighborCoupling, J2: nextNearestNeighborCoupling, startType:startType, energyType:energyType)
    }
    if Dimentions == 2{
        // 2D metropolis
        spins2D = generate2DMetropolisSystem(numberofSpins:NumberofSpins, maxIterations:maxiterations, T:temperature, J:nearestNeighborCoupling, J2: nextNearestNeighborCoupling, startType:startType, energyType:energyType)
    }
    return (spins1D, spins2D)
}


