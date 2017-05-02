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
    @IBOutlet weak var numberofSpins: NSTextField!
    @IBOutlet weak var maxIterations: NSTextField!
    @IBOutlet weak var Temperature: NSTextField!
    @IBOutlet weak var NNCoupling: NSTextField!
    @IBOutlet weak var NNNCoupling: NSTextField!
    @IBOutlet weak var startType: NSTextField!
    @IBOutlet weak var numberofDimentions: NSTextField!
    @IBOutlet weak var energyType: NSTextField!
    
    
    
   // @IBOutlet weak var whatAlgorithm: NSTextField!
    @IBOutlet weak var whatEnergy: NSTextField!
    @IBOutlet weak var whatDimention: NSTextField!
    
    
    
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        draw2DArray(input: create2D(size: 8, type: "UP"), plot: displayView)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
   
    
    func patrickTest()
    {
        
    }
    
    //  Plotting Total Magnetization verus Temperature
    //  Started
    @IBAction func magVtemp(_ sender: Any)
    {
        let Log = false
        var xPoints = [Double]()
        var yPoints = [Double]()
        let xRange = 50.0

        for temperature in 1...Int(xRange)
        {
            var yAvg = 0.0
            switch Log
            {
            case true:
                switch numberofDimentions.intValue
                {
                case 1:
                    yAvg = 0.0
                    for _ in 1...50
                    {
                        yAvg += log(abs(totalMagnetization1D(input: generateMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue)))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/50.0)
                case 2:
                    yAvg = 0.0
                    for _ in 1...50
                    {
                        yAvg += log(abs(totalMagnetization2D(input: generate2DMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue)))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/50.0)
                default:
                    break
                }
            case false:
                switch numberofDimentions.intValue
                {
                case 1:
                    yAvg = 0.0
                    for _ in 1...50
                    {
                        yAvg += abs(totalMagnetization1D(input: generateMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/50.0)
                    
                case 2:
                    yAvg = 0.0
                    for _ in 1...50
                    {
                        yAvg += abs(totalMagnetization2D(input: generate2DMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/50.0)
                default:
                    break
                }
            }
        }
        Plot2(Xaxis: xPoints, Yaxis: yPoints, Xlabel: "Temperature", Ylabel: "Total Magnetization")
    }
    
    //  Plotting Average Domain Size versus Temperature
    //  Done: Metropolis 1D, 2D
    @IBAction func domainVtemp(_ sender: Any)
    {
        let Log = false
        var xPoints = [Double]()
        var yPoints = [Double]()
        let xRange = 50.0
        let queue = DispatchQueue(label: "Temperature", qos: DispatchQoS.userInteractive, attributes: .concurrent)
        queue.sync{
        for temperature in 1...Int(xRange)
        {
            var yAvg = 0.0
            switch Log
            {
            case true:
                switch numberofDimentions.intValue
                {
                case 1:
                    yAvg = 0.0
                    for _ in 1...50
                    {
                    yAvg += log(avgDomainSize1D(input: findDomains1D(input: generateMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue)))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/50.0)
                    
                case 2:
                    yAvg = 0.0
                    for _ in 1...10
                    {
                    yAvg += log(avgDomainSize2D(input: findDomains2D(input: generate2DMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue)))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/10.0)
                default:
                    break
                }
            case false:
                switch numberofDimentions.intValue
                {
                case 1:
                    yAvg = 0.0
                    for _ in 1...50
                    {
                        yAvg += avgDomainSize1D(input: findDomains1D(input: generateMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/50.0)
                    
                case 2:
                    yAvg = 0.0
                    for _ in 1...10
                    {
                        yAvg += avgDomainSize2D(input: findDomains2D(input: generate2DMetropolisSystem(numberofSpins:Int(numberofSpins.intValue), maxIterations:Int(maxIterations.doubleValue), T: Double(temperature), J: NNCoupling.doubleValue, J2: NNNCoupling.doubleValue, startType:Int(startType.intValue), energyType:Int(energyType.intValue))))
                    }
                    xPoints.append(Double(temperature))
                    yPoints.append(yAvg/10.0)
                default:
                    break
                }
            }
        }
        } //End of queue
        Plot2(Xaxis: xPoints, Yaxis: yPoints, Xlabel: "Temperature", Ylabel: "Domain Size")
    }

    

    @IBAction func generateMetropolis(_ sender: Any) {
        //let queue = DispatchQueue(label: "userInit", attributes: .concurrent)
        
        displayView.display()
        
        let NumberofSpins:Int = Int(numberofSpins.doubleValue)
        let MaxIterations:Int = Int(maxIterations.doubleValue)
        let temperature:Double = Temperature.doubleValue
        let nearestNeighborCoupling:Double = NNCoupling.doubleValue
        let nextNearestNeighborCoupling:Double = NNNCoupling.doubleValue
        let StartType:Int = Int(startType.doubleValue)
        let Dimentions:Int = Int(numberofDimentions.doubleValue)
        let EnergyType:Int = Int(energyType.doubleValue)
        
        if Dimentions == 2{
            var metropolis2D:[[Int8]] = generate2DMetropolisSystem(numberofSpins:NumberofSpins, maxIterations:MaxIterations, T:temperature, J:nearestNeighborCoupling, J2: nextNearestNeighborCoupling, startType:StartType, energyType:EnergyType)
            
            draw2DArray(input: metropolis2D, plot: displayView)
        }
        else{
            
            
            var metropolis:[Int8] = generateMetropolisSystem(numberofSpins:NumberofSpins, maxIterations:MaxIterations, T:temperature, J:nearestNeighborCoupling, J2: nextNearestNeighborCoupling, startType:StartType, energyType:EnergyType)
        
            draw1DArray(input: metropolis, plot: displayView)
        }
    }
    

    @IBAction func plotInternalEnergyvsTemp(_ sender: Any) {
        
        let NumberofSpins:Int = 25
        let Numberof2DSpins:Int = 10
        let MaxIterations:Int = 1000
        
        var temperature:Double = 0.1
        let temperatureChange:Double = 0.5
        
        let nearestNeighborCoupling:Double = 1
        let nextNearestNeighborCoupling:Double = 0.5
        let StartType:Int = 0
        
        let Dimentions:Int = Int(whatDimention.doubleValue)
        let EnergyType:Int = Int(whatEnergy.doubleValue)
        //let Algorithm:Int = Int(whatAlgorithm.doubleValue)
        
        var spins1D:[Int8] = []
        var spins2D:[[Int8]] = [[]]
        
        
        var internalEnergyArray:[Double] = []
        var temperatureArray:[Double] = []
        var energyArray:[Double] = []
        
        //derpherp
        
        for j in 0...100{
            for i in 0...10{
                
                var spinTuple = algorithmSwitch(Dimentions:Dimentions, energyType:EnergyType, nearestNeighborCoupling:nearestNeighborCoupling, nextNearestNeighborCoupling:nextNearestNeighborCoupling, startType:StartType, maxiterations:MaxIterations, temperature:temperature, NumberofSpins:NumberofSpins, Numberof2DSpins:Numberof2DSpins)
                
                spins1D = spinTuple.spins1D
                spins2D = spinTuple.spins2D
                
                
                energyArray.append(energySwitch(Dimentions:Dimentions, energyType:EnergyType, nearestNeighborCoupling:nearestNeighborCoupling, nextNearestNeighborCoupling:nextNearestNeighborCoupling, array1D:spins1D, array2D:spins2D))
                
            }
            
            internalEnergyArray.append(calculateAverage(Array:energyArray))
            temperatureArray.append(temperature)
            temperature = temperature + temperatureChange
            energyArray.removeAll()
        }
        
        Plot2(Xaxis:temperatureArray, Yaxis:internalEnergyArray, Xlabel:"KbT", Ylabel:"U")
        
    }


    
    @IBAction func generateWLS(_ sender: Any) {
        
        var classArray = WLSSpinArray2D()
        var classWLS = WLS()
        
        var J:Double = 1
        
        var Array = create2D(size: 4, type: "RANDOM")
        
        var energy = initalize2DNearestNeighborsEnergy(Spins:Array, J:J)
        var possibleEnergies = generatePossible2DEnergies(Spins: Array, J: J)
        
        var acceptState:Bool = false
        
        classArray.initialize(newArray:Array,newEnergy:energy,newArraylength:Array.count)
        classWLS.initialize(possibleEnergies: possibleEnergies)
        
        
        while classWLS.multiplicitiveFactor > 1 + pow(10,-8){
            //for g in 0...Dimentions{
            while !(classWLS.isFlat){
                
                for i in 0...9999{
                    
                    classArray.calculateEnergyChange()
                    
                    classWLS.relativeProbability(oldEnergy: classArray.Energy, energyChange: classArray.energyChange)
                    
                    acceptState = classWLS.acceptState
                    
                    if acceptState{
                        classArray.commitToSpinFlip()
                    }
                    //print(testclass.Energy)
                    classWLS.updateWLS(newEnergy: classArray.Energy)
                }
                
                classWLS.checkFlat()
                //print(testWLS.isFlat)
                //print(testWLS.multiplicitiveFactor)
            }//end of flat check
            // } //end of extra test
            classWLS.isFlat = false
        }//end of F updates
        
        classWLS.removeDOSZeroes()
        classWLS.normalize()
        //classWLS.eulerDOS()
        Plot2(Xaxis: classWLS.Energies, Yaxis: classWLS.DOS, Xlabel: "Energy", Ylabel: "DOS")
        
        
        
        
    }



    @IBAction func test(_ sender: Any) {
        
        var testclass = WLSSpinArray2D()
        var testWLS = WLS()
        
        var J:Double = 1
        
        var Array = create2D(size: 8, type: "UP")
        
        var energy = initalize2DNearestNeighborsEnergy(Spins:Array, J:J)
        var possibleEnergies = generatePossible2DEnergies(Spins: Array, J: J)
        
        var acceptState:Bool = false
        
        testclass.initialize(newArray:Array,newEnergy:energy,newArraylength:Array.count)
        testWLS.initialize(possibleEnergies: possibleEnergies)
        
        
        while testWLS.multiplicitiveFactor > 1 + pow(10,-8){
        //for g in 0...Dimentions{
        while !(testWLS.isFlat){
            
        for i in 0...9999{
            
        testclass.calculateEnergyChange()
            
        testWLS.relativeProbability(oldEnergy: testclass.Energy, energyChange: testclass.energyChange)
        
        acceptState = testWLS.acceptState
        
        if acceptState{
            testclass.commitToSpinFlip()
        }
        //print(testclass.Energy)
        testWLS.updateWLS(newEnergy: testclass.Energy)
        }
            
        testWLS.checkFlat()
            //print(testWLS.isFlat)
            //print(testWLS.multiplicitiveFactor)
       }//end of flat check
       // } //end of extra test
            testWLS.isFlat = false
    }//end of F updates
        
        testWLS.removeDOSZeroes()
        testWLS.normalize()
        testWLS.eulerDOS()
        print(testWLS.DOS)
        Plot2(Xaxis: testWLS.Energies, Yaxis: testWLS.DOS, Xlabel: "Energy", Ylabel: "DOS")
        
    }




//generic plot function
func Plot2(Xaxis:[Double], Yaxis:[Double], Xlabel:String, Ylabel:String) {
    for i in 0...(Xaxis.count-1) {
        
        let dataPoint: plotDataType = [.X: Xaxis[i], .Y: Yaxis[i]]
        contentArray.append(dataPoint)
    }
    
    makePlot(xLabel: Xlabel, yLabel: Ylabel, xMin: Xaxis.min()! - 0.1, xMax: Xaxis.max()! * 1.1, yMin: -0.1, yMax: Yaxis.max()! * 1.1)
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
    
    
    
    plotSpace.yRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: (yMax-yMin)*1.5))
    plotSpace.xRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: (xMax-xMin)*1.5))
    
    
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
        x.majorIntervalLength   = 10.0
        x.orthogonalPosition    = 0.0
        x.minorTicksPerInterval = 0
    }
    
    if let y = axisSet.yAxis {
        y.majorIntervalLength   = 1.0
        y.minorTicksPerInterval = 0
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
