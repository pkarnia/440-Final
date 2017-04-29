//
//  Magnetization.swift
//  Final
//
//  Created by Patrick Karnia on 4/29/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//
//  Functions relating to magnetization

import Foundation

//  Identify domains in a 1D spin array. Domain count is index 1.
//  Returns [Int]
//  Usage:  Feed in [Int8] get domain array 1...x
func findDomains1D(input: [Int8]) -> [Int]
{
    var map = [Int](repeating: 0, count: input.count)
    var index = 1
    for x in 0..<input.count
    {
        if(map[x] == 0)
        {
            map[x] = index
            for i in 1..<(input.count - x)
            {
                if(input[(x+i)] == input[x])
                {
                    map[(x+i)] = index
                }
                else
                {
                    break
                }
            }
            index += 1
        }
    }
    return map
}

//  Identify domains in a 2D spin array. Domain count is index 1.
//  Returns [[Int]]
//  Usage:  Feed in [[Int8]] get domain array 1...x
func findDomains2D(input: [[Int8]]) -> [[Int]]
{
    var map = [[Int]](repeating: [Int](repeating: 0, count: input.count), count: input.count)
    var index = 1
    for y in 0..<input.count
    {
    for x in 0..<input.count
    {
        if(map[y][x] == 0)
        {
            map[y][x] = index
            for i in 1..<(input.count - x)
            {
                if(input[y][(x+i)] == input[y][x])
                {
                    map[y][(x+i)] = index
                }
                else
                {
                    break
                }
            }
            index += 1
        }
    }
    }
    return map
}

//  Calculate total magentization for 1D array
//  Returns Double
//  Usage:  Feed in [Int8] get total spin in type double
func totalMagnetization1D(input: [Int8]) -> Double
{
    var totalSpin: Int8 = 0
    for spin in input
    {
        totalSpin += spin
    }
    return Double(totalSpin)/2.0
}

//  Calculate total magentization for 2D array
//  Returns Double
//  Usage:  Feed in [[Int8]] get total spin in type double
func totalMagnetization2D(input: [[Int8]]) -> Double
{
    var totalSpin: Int8 = 0
    for row in input
    {
        for spin in row
        {
            totalSpin += spin
        }
    }
    return Double(totalSpin)/2.0
}
