//
//  ViewController.swift
//  Final
//
//  Created by Patrick Karnia on 4/14/17.
//  Copyright © 2017 Patrick Karnia. All rights reserved.
//

// Test for version differences

import Cocoa
import CorePlot
import Foundation

class ViewController: NSViewController, CPTScatterPlotDataSource, CPTAxisDelegate {
    private var scatterGraph : CPTXYGraph? = nil
    var contentArray = [plotDataType]()
    
    //@IBOutlet weak var hostingView: CPTGraphHostingView!
    
    @IBOutlet weak var hostingView: CPTGraphHostingView!
    
    
    @IBOutlet weak var displayView: DrawingView!
    
    
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        patrickTest()
        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func patrickTest()
    {
        let test = create2D(size: 3, type: "RANDOM")
        
        for var x in 0..<test.count {
            var line = ""
            for var y in 0..<test[x].count {
                line += String(test[x][y])
                line += " "
            }
            print(line)
        }
        
        print()
        //print(test)
        
        let map = (findDomains2D(input: test))
        
        for var x in 0..<map.count {
            var line = ""
            for var y in 0..<map[x].count {
                line += String(map[x][y])
                line += " "
            }
            print(line)
        }
        //print(totalMagnetization2D(input: test))
    }


    @IBAction func generateMetropolis(_ sender: Any) {
        displayView.display()
        
        //var Derp:[Int8] = generateMetropolisSystem(numberofSpins:5, maxIterations:1000, Dimentions:1, T:5, J:1, J2: 1/2, Plot:1)
        //print(Derp)
        
        generateWLSSystem(numberofSpins: 5, maxIterations: 10, Dimentions: 1, T: 5, J: 1, J2: 1/2, Plot: 0,Log:true)
        
        
        
        
    }
    

    

func generateMetropolisSystem(numberofSpins:Int,maxIterations:Int, Dimentions:Int, T:Double,J:Double, J2: Double, Plot:Int) -> [Int8] { //This is in the View Controller so that Hosting View can be accessed - The current animation plan didnt work so this is here for no particular reason.
        
    var Spins = create1D(size: 5, type: "UP")   //Should be replaced by a function
        
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
        print(Spins)
            
        
        
    }
        
        
    return Spins
}



    func generateWLSSystem(numberofSpins:Int,maxIterations:Int, Dimentions:Int, T:Double,J:Double, J2: Double, Plot:Int, Log:Bool) -> [Int8]  {
        //generateSpins
        
        var Spins:[Int8] = [1,1,1,1]
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
        
        
        //while (multiplicitiveFactor-1)>pow(10,-8){
        //while !isFlat{
        for i in 1...20{
            
            
            oldEnergy = generate1DEnergy(Spins: Spins, J: J)
            oldDensity = getDensity(Energy: oldEnergy, densityofStates: densityofStates)
            
            //generate new state
            newSpins = SpinFlip1D(Spins: Spins)
            newEnergy = generate1DEnergy(Spins: newSpins, J: J)
            newDensity = getDensity(Energy: newEnergy, densityofStates: densityofStates)
            
            //print(newEnergy)
            
            //checks if new state should be accepted
            if WLSRelativeProbability(oldDensity: oldDensity, newDensity: newDensity, Log:Log){
                //if accepted overwrite old spins and energies
                oldEnergy = newEnergy
                Spins = newSpins
                //print(Spins)
            }//end of if
            
            //update density of states and visited energies, which is an input for the histogram
            densityofStates = updateDensityofStates(densityofStates: densityofStates, Energy: oldEnergy, energyArray: possibleEnergies, multiplicitivefactor: multiplicitiveFactor, Log:Log)
            
            visitedEnergies.append(newEnergy)
        }//end of 10000 iterations
        
        histogramTuple = addtoWLSHistogram(currentHistogram: Histogram, histogramEnergies: histogramEnergies, newEnergies: visitedEnergies, clear: false)
        
        Histogram = histogramTuple.Histogram
        histogramEnergies = histogramTuple.histogramEnergies
        isFlat = histogramTuple.isFlat
        print(isFlat)
        
        //Plot(Xaxis:histogramEnergies, Yaxis:densityofStates, Xlabel:"derp", Ylabel:"herp")
        print(visitedEnergies)
        print(histogramEnergies)
        //print(Histogram.max()!,Histogram.min()!)
        //print(possibleEnergies)
        //print(densityofStates)
        print(Histogram)
        print(histogramEnergies[1] - possibleEnergies[1])
        
        //Plot2(Xaxis: histogramEnergies, Yaxis: Histogram, Xlabel: "derp", Ylabel: "herp")
        //Plot2(Xaxis: possibleEnergies, Yaxis: densityofStates, Xlabel: "derp", Ylabel: "herp")
        //}//end of flat check
        
        multiplicitiveFactor = updateMultiplicitiveFactor(multiplicitiveFactor: multiplicitiveFactor)
        
        /*Histogram.removeAll()
         histogramEnergies.removeAll()
         visitedEnergies.removeAll()
         isFlat = false*/
        //}//end of multiplicitivefactor updates
        
        return Spins
    }








//generic plot function
func Plot2(Xaxis:[Double], Yaxis:[Double], Xlabel:String, Ylabel:String) {
    for i in 0...(Xaxis.count-1) {
        
        let dataPoint: plotDataType = [.X: Xaxis[i], .Y: Yaxis[i]]
        contentArray.append(dataPoint)
    }
    
    makePlot(xLabel: Xlabel, yLabel: Ylabel, xMin: Xaxis.min()! - 0.1, xMax: Xaxis.max()! * 1.1, yMin: Yaxis.min()! - 0.1, yMax: Yaxis.max()! * 1.1)
    contentArray.removeAll()
}





/************** Functions for Plotting **************/


/// makePlot sets up the default plotting conditions and displays the data
func makePlot(xLabel: String, yLabel: String, xMin: Double, xMax: Double, yMin: Double, yMax: Double){
    
    // Create graph from theme
    let newGraph = CPTXYGraph(frame: .zero)
    newGraph.apply(CPTTheme(named: .darkGradientTheme))
    
    hostingView.hostedGraph = newGraph
    
    // Paddings
    newGraph.paddingLeft   = 10.0
    newGraph.paddingRight  = 10.0
    newGraph.paddingTop    = 10.0
    newGraph.paddingBottom = 10.0
    
    // Plot space
    let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
    plotSpace.allowsUserInteraction = true
    
    
    
    plotSpace.yRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: (yMax-yMin)))
    plotSpace.xRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: (xMax-xMin)))
    
    
    //Anotation
    
    let theTextStyle :CPTMutableTextStyle = CPTMutableTextStyle()
    
    theTextStyle.color =  CPTColor.white()
    
    let ann = CPTLayerAnnotation.init(anchorLayer: hostingView.hostedGraph!.plotAreaFrame!)
    
    ann.rectAnchor = CPTRectAnchor.bottom; //to make it the top centre of the plotFrame
    ann.displacement = CGPoint(x: 20.0, y: 20.0) //To move it down, below the title
    
    let textLayer = CPTTextLayer.init(text: xLabel, style: theTextStyle)
    
    ann.contentLayer = textLayer
    
    hostingView.hostedGraph?.plotAreaFrame?.addAnnotation(ann)
    
    let annY = CPTLayerAnnotation.init(anchorLayer: hostingView.hostedGraph!.plotAreaFrame!)
    
    annY.rectAnchor = CPTRectAnchor.left; //to make it the top centre of the plotFrame
    annY.displacement = CGPoint(x: 50.0, y: 30.0) //To move it down, below the title
    
    let textLayerY = CPTTextLayer.init(text: yLabel, style: theTextStyle)
    
    annY.contentLayer = textLayerY
    
    hostingView.hostedGraph?.plotAreaFrame?.addAnnotation(annY)
    
    
    
    
    // Axes
    let axisSet = newGraph.axisSet as! CPTXYAxisSet
    
    if let x = axisSet.xAxis {
        x.majorIntervalLength   = 1.0
        x.orthogonalPosition    = 0.0
        x.minorTicksPerInterval = 3
    }
    
    if let y = axisSet.yAxis {
        y.majorIntervalLength   = 0.5
        y.minorTicksPerInterval = 5
        y.orthogonalPosition    = 0.0
        y.delegate = self
    }
    
    // Create a blue plot area
    let boundLinePlot = CPTScatterPlot(frame: .zero)
    let blueLineStyle = CPTMutableLineStyle()
    blueLineStyle.miterLimit    = 1.0
    blueLineStyle.lineWidth     = 3.0
    blueLineStyle.lineColor     = .blue()
    boundLinePlot.dataLineStyle = blueLineStyle
    boundLinePlot.identifier    = NSString.init(string: "Blue Plot")
    boundLinePlot.dataSource    = self
    newGraph.add(boundLinePlot)
    
    let fillImage = CPTImage(named:"BlueTexture")
    fillImage.isTiled = true
    boundLinePlot.areaFill      = CPTFill(image: fillImage)
    boundLinePlot.areaBaseValue = 0.0
    
    // Add plot symbols
    let symbolLineStyle = CPTMutableLineStyle()
    symbolLineStyle.lineColor = .black()
    let plotSymbol = CPTPlotSymbol.ellipse()
    plotSymbol.fill          = CPTFill(color: .blue())
    plotSymbol.lineStyle     = symbolLineStyle
    plotSymbol.size          = CGSize(width: 10.0, height: 10.0)
    boundLinePlot.plotSymbol = plotSymbol
    
    self.dataForPlot = contentArray
    
    self.scatterGraph = newGraph
}

// MARK: - Plot Data Source Methods
func numberOfRecords(for plot: CPTPlot) -> UInt
{
    return UInt(self.dataForPlot.count)
}

func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
{
    let plotField = CPTScatterPlotField(rawValue: Int(field))
    
    if let num = self.dataForPlot[Int(record)][plotField!] {
        let plotID = plot.identifier as! String
        if (plotField! == .Y) && (plotID == "Green Plot") {
            return (num + 0.0) as NSNumber
        }
        else {
            return num as NSNumber
        }
    }
    else {
        return nil
    }
}

// MARK: - Axis Delegate Methods
private func axis(_ axis: CPTAxis, shouldUpdateAxisLabelsAtLocations locations: NSSet!) -> Bool
{
    if let formatter = axis.labelFormatter {
        let labelOffset = axis.labelOffset
        
        var newLabels = Set<CPTAxisLabel>()
        
        if let labelTextStyle = axis.labelTextStyle?.mutableCopy() as? CPTMutableTextStyle {
            for location in locations {
                if let tickLocation = location as? NSNumber {
                    if tickLocation.doubleValue >= 0.0 {
                        labelTextStyle.color = .green()
                    }
                    else {
                        labelTextStyle.color = .red()
                    }
                    
                    let labelString   = formatter.string(for:tickLocation)
                    let newLabelLayer = CPTTextLayer(text: labelString, style: labelTextStyle)
                    
                    let newLabel = CPTAxisLabel(contentLayer: newLabelLayer)
                    newLabel.tickLocation = tickLocation
                    newLabel.offset       = labelOffset
                    
                    newLabels.insert(newLabel)
                }
            }
            
            axis.axisLabels = newLabels
        }
    }
    
    return false
}

}
