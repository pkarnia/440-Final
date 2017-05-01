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
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()

    override func viewDidLoad() {
        let queue = DispatchQueue(label: "parent", attributes: .concurrent)
        super.viewDidLoad()
        queue.async
        {
           // self.patrickTest()
        }
        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func patrickTest()
    {
        let test = create2D(size: 100, type: "RANDOM")
        
        
        draw2DArray(input: test, plot: displayView)
        
        
    }


    @IBAction func generateMetropolis(_ sender: Any) {
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
            //print2dArrayInt8(input: metropolis2D)
        }
        else{
            
            
            var metropolis:[Int8] = generateMetropolisSystem(numberofSpins:NumberofSpins, maxIterations:MaxIterations, T:temperature, J:nearestNeighborCoupling, J2: nextNearestNeighborCoupling, startType:StartType, energyType:EnergyType)
        
            draw1DArray(input: metropolis, plot: displayView)
        
        }
        
        
        //generateWLSSystem(numberofSpins: 5, maxIterations: 10, Dimentions: 1, T: 5, J: 1, J2: 1/2, Plot: 0,Log:true)
        
        
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
