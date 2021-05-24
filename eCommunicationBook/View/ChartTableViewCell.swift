//
//  ChartTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell {

     override func awakeFromNib() {
            super.awakeFromNib()
                customizeChart(dataPoints: players, values: score.map { Double($0)})
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

  @IBOutlet var chartView: HorizontalBarChartView!
        
        let players = ["參與", "合作", "學習"]
        let performance = ["",
                           "Poor",
                           "",
                           "Normal",
                           "",
                           "Excellent"]
        let score = [5, 4, 5]
        
    //    override func viewDidLoad() {
    //      super.viewDidLoad()
    //
    //
    //    }
        
        func customizeChart(dataPoints: [String], values: [Double]) {
          
          var dataEntries: [BarChartDataEntry] = []
          for index in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(values[index]))
            dataEntries.append(dataEntry)
          }
          let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
          let chartData = BarChartData(dataSet: chartDataSet)
          
          chartDataSet.colors = [.red, .green, .blue]
          chartDataSet.valueColors = [.clear, .clear, .clear]
          //    chartDataSet.valueFont = *font you want*
          
          chartView.data = chartData
          
      //    chartView.delegate = self
          chartView.animate(yAxisDuration: 2.5)
          chartView.drawBordersEnabled = false
          chartView.drawGridBackgroundEnabled = false
          
          let xAxis = chartView.xAxis
          xAxis.labelPosition = .bottom
          xAxis.labelFont = .systemFont(ofSize: 15)
          xAxis.drawGridLinesEnabled = false
          xAxis.valueFormatter = IndexAxisValueFormatter(values: players)
          xAxis.granularity = 1
          
          let leftAxis = chartView.leftAxis
          leftAxis.labelFont = .systemFont(ofSize: 14)
          leftAxis.drawGridLinesEnabled = false
          leftAxis.drawTopYLabelEntryEnabled = false
          leftAxis.drawBottomYLabelEntryEnabled = false
          leftAxis.axisMinimum = 0
          leftAxis.axisMaximum = 6
          leftAxis.valueFormatter = IndexAxisValueFormatter(values: performance)
          leftAxis.granularity = 1
          
          let rightAxis = chartView.rightAxis
          rightAxis.drawLabelsEnabled = false
          rightAxis.drawGridLinesEnabled = false
          
          let legend = chartView.legend
          legend.enabled = false
        }
    
}
