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
//  Usage:  Feed in [[Int8]] get 2D domain array 1...x
//
//  OBSOLETE But don't want to delete right now.
/*
func findDomains2D(input: [[Int8]]) -> [[Int]]
{
    var map = [[Int]](repeating: [Int](repeating: 0, count: input.count), count: input.count)
    var index = 1
    
    for x in 0..<input.count
    {
        for y in 0..<input.count
        {
            if(map[x][y] == 0)
            {
                map[x][y] = index
                for i in 0..<(input.count-x)
                {
                    if(input[x][y] == input[x+i][y])
                    {
                        map[x+i][y] = index
                    }
                    else
                    {
                        break
                    }
                }
                for i in 0..<(input.count-y)
                {
                    if(input[x][y] == input[x][y+i])
                    {
                        map[x][y+i] = index
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
 */

//  Identify domains in a 2D spin array. Domain count is index 1.
//  Returns [[Int]]
//  Usage:  Feed in [[Int8]] get 2D domain array 1...x
func findDomains2D(input: [[Int8]]) -> [[Int]]
{
    var map = [[Int]](repeating: [Int](repeating: 0, count: input.count), count: input.count)
    var index = 1
    var modified = false
    
    for x in 0..<input.count
    {
        for y in 0..<input.count
        {
            if(map[x][y] == 0)
            {
                map[x][y] = index
                repeat
                {
                    modified = false
                    var u = 0
                    for row in map
                    {
                        var v = 0
                        for cell in row
                        {
                            if(cell == index)
                            {
                                for i in -1...1
                                {
                                    if((u+i) >= 0 && (u+i) < map.count && map[u+i][v] == 0 && input[u+i][v] == input[x][y])
                                    {
                                        map[u+i][v] = index
                                        modified = true
                                    }
                                    if((v+i) >= 0 && (v+i) < map.count && map[u][v+i] == 0 && input[u][v+i] == input[x][y])
                                    {
                                        map[u][v+i] = index
                                        modified = true
                                    }
                                }
                            }
                            v += 1
                        }
                        u += 1
                    }
                }
                while(modified == true)
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
