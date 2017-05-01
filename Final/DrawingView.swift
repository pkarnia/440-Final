//
//  DrawingView.swift
//  Monte Carlo Integration
//
//  Created by Jeff Terry on 2/1/17.
//  Copyright © 2017 Jeff Terry. All rights reserved.
//

import Cocoa
class DrawingView: NSView {
    
    
    /// Class Parameters Necessary for Drawing
    var shouldIClear = true
    var shouldIDrawCircle = false
    var shouldIDrawPoints = true
    var colorToDraw = "Blue"
    var allThePoints: [(xPoint: Double, yPoint: Double, radiusPoint: Double, color: String)] = []  ///Array of tuples
    
    /// draw
    ///
    /// contains the drawing code for the points inside and outside of the circle
    /// - Parameter dirtyRect: Rectangle that will be drawn in
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
    
        // draw a white box
        
        NSColor.white.setFill()
        NSRectFill(bounds)
        
        
        if shouldIClear {
            
            //draw a white box to clear
            
            clear()
            shouldIClear = false
            
        }
        
//        if shouldIDrawCircle {
//            
//            circle()
//            
//        }
        
        if shouldIDrawPoints {
            
            // Draw the points to the frame if needed
            
            for (_, item) in allThePoints.enumerated(){
            
            NSColor.red.setFill()
            
            if item.color == "Blue" {
                
                NSColor.blue.setFill()
                
            }
            
            drawPoints(xPoint: item.xPoint, yPoint: item.yPoint, radiusPoint: item.radiusPoint)

            
        }
            
        }
        
        
    }
    
    /// clears the Display
    /// It Clears the display by drawing a white box
    func clear(){
        
        NSColor.white.setFill()
        NSRectFill(bounds)
        
    }
    
    
    /// draws a circle
    /// fills the entire frame with a circle
    func circle(){
        
        let circleFillColor = NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        
        let circleRect = NSMakeRect(self.frame.size.width/8*0, self.frame.size.height/8*0, self.frame.size.width, self.frame.size.height)
        let cPath: NSBezierPath = NSBezierPath(ovalIn: circleRect)
        circleFillColor.set()
        cPath.fill()
        
        
    }
    
    /// draw the points
    ///
    /// - Parameters:
    ///   - xPoint: x component of the point to draw
    ///   - yPoint: y component of the point to draw
    ///   - radiusPoint: radius of the point but this is unneeded in this routine. Just for passing the tuple
    func drawPoints(xPoint: Double, yPoint: Double, radiusPoint: Double ){
        
        // Draw a rectangle of size 1 by 1 pixel at each point
        
        
        let aRect :NSRect = NSMakeRect(CGFloat(Float(xPoint)), CGFloat(Float(yPoint)), CGFloat(radiusPoint), CGFloat(radiusPoint))
    
        NSRectFill(aRect)
        
    }
    
    /// notifies the GUI that the display needs to be updated
    func tellGuiToDisplay(){
        
        needsDisplay = true
  
        
    }
    
    /// add points to the Array that will be drawn in the display
    ///
    /// - Parameters:
    ///   - xPointa: x component of the point to draw
    ///   - yPointb: y component of the point to draw
    ///   - radiusPointc: radius of the point to draw
    ///   - colord: color of the pixel (Blue if ouside of the circle, Red if inside the circle)
    func addPoint(xPointa: Double, yPointb: Double, radiusPointc: Double, colord: String){
        
        let arguments2 = (xPoint: xPointa, yPoint: yPointb, radiusPoint: radiusPointc, color: colord)
        
        allThePoints.append(arguments2)
        
    }

    
}


