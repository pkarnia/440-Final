//
//  Arrays.swift
//  Final
//
//  Created by Patrick Karnia on 4/22/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//
//  Functions to handle generation and manipulation of spin arrays.
//
//

import Foundation

//Lookup table for random spin generation
let lookup: [Int8] = [-1,1]


//  Generates Spin
//  Returns Int8
//  Usage:  "UP"    returns 1
//          "DOWN"  returns -1
//          "RANDOM returns -1 or 1
//          empty   returns 0
func createSpin(type: String) -> Int8
{
    switch (type)
    {
        case "UP":
            return 1
        case "DOWN":
            return -1
        case "RANDOM":
            return lookup[Int(arc4random_uniform(0b10))]
        default:
            return 0
    }
}


//  Generates 1D array of spins
//  Returns Array[Int8]
//  Usage:  size    Int legnth of array
//          type    String kind of spins to make up array       "UP", "DOWN", "RANDOM"
func create1D(size: Int, type: String) -> Array<Int8>
{
    var result = [Int8](repeating: 0, count:size)
    for x in 0..<size
    {
        result[x] = createSpin(type: type)
    }
    return result
}

//  Generates 2D square array of spins
//  Returns Array[[Int8]]
//  Usage:  size    Int legnth of array
//          type    String kind of spins to make up array       "UP", "DOWN", "RANDOM"
func create2D(size: Int, type: String) -> [Array<Int8>]
{
    var result = [[Int8]](repeating: [Int8](repeating: 0, count:size), count: size)
    for x in 0..<size
    {
        for y in 0..<size
        {
            result[x][y] = createSpin(type: type)
        }
    }
    return result
}

//  Draws 1D Array
//  Returns void
//  Usage:  feed in [Int8] and DrawingView
//
func draw1DArray(input: [Int8], plot: DrawingView)
{
    let upColor = "Blue"
    let downColor = "Red"
    
    let scaleFactor = 500.0/Double(input.count)
    
    for x in 0..<input.count
    {
        switch input[x]
        {
        case 1:
            plot.addPoint(xPointa: (Double(x)*scaleFactor),yPointb: scaleFactor,radiusPointc: 2.0*scaleFactor,colord: upColor)
        case -1:
            plot.addPoint(xPointa: (Double(x)*scaleFactor),yPointb: scaleFactor,radiusPointc: 2.0*scaleFactor,colord: downColor)
        default:
            break
        }
    }
}

//  Draws 2D Array
//  Returns void
//  Usage:  feed in [[Int8]] and DrawingView
//
func draw2DArray(input: [[Int8]], plot: DrawingView)
{
    let upColor = "Blue"
    let downColor = "Red"
    
    let scaleFactor = 500.0/Double(input.count)
    
    for x in 0..<input.count
    {
        for y in 0..<input.count
        {
        switch input[x][y]
        {
        case 1:
            plot.addPoint(xPointa: (Double(x)*scaleFactor),yPointb: (Double(y)*scaleFactor)+(0.5*scaleFactor),radiusPointc: 1.0*scaleFactor,colord: upColor)
        case -1:
            plot.addPoint(xPointa: (Double(x)*scaleFactor),yPointb: (Double(y)*scaleFactor)+(0.5*scaleFactor),radiusPointc: 1.0*scaleFactor,colord: downColor)
        default:
            break
        }
        }
    }
}

func print2dArrayUInt16(input: [[UInt16]]) -> Void
{
    for x in 0..<input.count {
        var line = ""
        for y in 0..<input[x].count {
            line += String(input[x][y])
            line += " "
        }
        print(line)
    }
}

func print2dArrayInt8(input: [[Int8]]) -> Void
{
    for x in 0..<input.count {
        var line = ""
        for y in 0..<input[x].count {
            line += String(input[x][y])
            line += " "
        }
        print(line)
    }
}
