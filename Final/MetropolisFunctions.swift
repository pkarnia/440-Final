//
//  MetropolisFunctions.swift
//  Final
//
//  Created by Mitchell Vaniger on 4/30/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

import Foundation

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

func generateMetropolisSystem(numberofSpins:Int,maxIterations:Int, T:Double,J:Double, J2: Double, startType:Int) -> [Int8] {
    
    var Spins:[Int8] = []
    
    if startType==1{
        Spins = create1D(size: numberofSpins, type: "RANDOM")
    }
    if startType==(-1){
        Spins = create1D(size: numberofSpins, type: "Down")
    }
    else{
        Spins = create1D(size: numberofSpins, type: "UP")
    }
    
    
    var oldEnergy:Double = 0
    var newSpins:[Int8] = []
    var newEnergy:Double = 0
    var acceptNewState:Bool = false
    
    
    
    for i in 0...maxIterations-1{
        
        oldEnergy = generate1DEnergy(Spins: Spins, J: J)
        newSpins = SpinFlip1D(Spins:Spins)
        newEnergy = generate1DEnergy(Spins: newSpins, J: J)
        
        acceptNewState = metropolisRelativeProbability(oldEnergy:oldEnergy, newEnergy:newEnergy, T:T)
        //print(acceptNewState)
        if acceptNewState==true{
            oldEnergy=newEnergy
            Spins=newSpins
        }
        //print(Spins)
        
        
        
    }
    
    
    return Spins
}
