//
//  TruePriceViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/23.
//

import UIKit
import Charts
import TTGTagCollectionView



class TruePriceViewController:  PresentBottomVC ,TTGTextTagCollectionViewDelegate{
    
    override var controllerHeight: CGFloat {
        return screenSize.height*4/7
    }
    
    let currentDate = Date()
    let screenSize = UIScreen.main.bounds.size
    let typeCV = TTGTextTagCollectionView()
    
    var houseArray:[HouseModel]?
    
    //目前查的地址
    public static var truePriceCurrentAddress:String = ""
    
    
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var houseNameLB: UILabel!
    
    @IBOutlet weak var averagePriceLB: UILabel!
    @IBOutlet weak var yearPriceLB: UILabel!
    @IBOutlet weak var totalPingLB: UILabel!
    @IBOutlet weak var lowPriceLB: UILabel!
    @IBOutlet weak var highPriceLB: UILabel!
    @IBOutlet weak var totalPriceLB: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var newLB: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    

    var typeTags : String = ""
    
    //圖表資料
    var prices : [Double] = []
    var dates : [String] = []
    var monthMarks:[String] = []
    

    
    @IBAction func plusOnclick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController{
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }
    }
    
    //動態增加tableview高度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //           tableView.layer.removeAllAnimations()
        
        tableviewHeight.constant = tableView.contentSize.height
        self.updateViewConstraints()
        //           UIView.animate(withDuration: 0.5) {
        //
        //           }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHouseData()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  
        tableView.rowHeight = 81
        tableView.estimatedRowHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        //動態增加tableview高度
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tableView.separatorColor = .clear
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        newLB.layer.cornerRadius = 15
        newLB.clipsToBounds = true
     
        segmentedControl.selectedSegmentIndex = 0
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
   
        scrollView.addSubview(typeCV)
        
//        typeCV.frame = CGRect(x: houseNameLB.frame.origin.x+20, y:screenSize.height*0.17, width: view.frame.size.width*0.85, height: 40)
        
        
    }
    
    func getHouseData(){
        ApiHelper.instance().getByAddress(address: TruePriceViewController.truePriceCurrentAddress){
            [weak self] (result,houseArray) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (result){
                print("success")
                weakSelf.houseArray = houseArray
                
                weakSelf.addressLB.text = houseArray?[0].address
                
                let lastNew =  DateUtil.shared.getStrFormatDateStr(withFormat: "yyymmdd" ,strDate: houseArray![0].transactionTime)
                weakSelf.newLB.text = "最近更新：\(lastNew)"
                
                weakSelf.typeTags = houseArray![0].buildingState
                weakSelf.typeCV.addTags([ weakSelf.typeTags], with: weakSelf.initType())
                
                weakSelf.averagePriceLB.text = weakSelf.getAverage(houses:houseArray!)
                weakSelf.highPriceLB.text = weakSelf.getHigh(houses:houseArray!)
                weakSelf.lowPriceLB.text = weakSelf.getLow(houses:houseArray!)
                weakSelf.yearPriceLB.text = weakSelf.getPerYear(houses: houseArray!)
                
                weakSelf.totalPingLB.text = String(format: "%.1f", houseArray![0].ping)
                weakSelf.totalPriceLB.text = "\(Int(houseArray![0].price/10000))"
            
//                weakSelf.houseNameLB.text =

                weakSelf.setChartData()

                weakSelf.setChart(dataPoints: weakSelf.dates, values: weakSelf.prices)
                
                weakSelf.tableView.reloadData()
       
                
            }else{
                print("failed")
                
            }
        }
    }
    
    func setChartData(){
        var monthMark = ""
        for i in 0...11{
            monthMark = DateUtil.shared.dateToString(Calendar.current.date(byAdding: .month, value: -i , to: currentDate)!, dateFormat: "yyy-MM")
            monthMarks.append(monthMark)
        }
        
 
        var tmpPrices : [Double] = []
        var tmpDates : [String] = []
        
        for i in 0...houseArray!.count-1{
            let price = houseArray![i].price/houseArray![i].ping/10000
            let date = DateUtil.shared.getMonthDateStr(withFormat: "yyymmdd" ,strDate: houseArray![i].transactionTime)
            tmpPrices .append(Double(price))
            tmpDates.append(date)
            
        }
        
        //將剛取得的資料反轉順序，時間才會由遠到近
        for i in (0...tmpPrices.count-1).reversed(){
            prices.append(tmpPrices[i])
            dates.append(tmpDates[i])
        }
        
        

    }
    


    
    func setChart(dataPoints: [String], values: [Double]){

        var dataEntries: [ChartDataEntry] = []
        for index in 0...dataPoints.count-1{
            let dataEntry = ChartDataEntry(x: Double(index), y: values[index] , data: dataPoints[index] as AnyObject)
            dataEntries.append(dataEntry)
            
        }
        
        //資料曲線設定
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        lineChartDataSet.colors = [UIColor.orange]
        lineChartDataSet.drawCirclesEnabled = false //是否繪製轉折點
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.mode = .horizontalBezier  //設定曲線是否平滑
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false //不畫縱向十字線
        lineChartDataSet.highlightLineDashLengths = [4,2] //十字線為虛線
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.noDataText = "暫無資料"
        
        
        
        //設定折線圖互動樣式
           lineChartView.scaleYEnabled = false //取消Y軸縮放
           lineChartView.doubleTapToZoomEnabled = true //雙擊縮放
           lineChartView.dragEnabled = true //啟用拖動手勢
           lineChartView.dragDecelerationEnabled = true //拖拽後是否有慣性效果
           lineChartView.dragDecelerationFrictionCoef = 0.9  //拖拽後慣性效果的摩擦係數(0~1)，數值越小，慣性越不明顯
        
        
        //設定X軸樣式
           let xAxis = lineChartView.xAxis
           xAxis.axisLineWidth = 1.0/UIScreen.main.scale //設定X軸線寬
           xAxis.labelPosition = .bottom //X軸的顯示位置，預設是顯示在上面的
           xAxis.drawGridLinesEnabled = false;//不繪製網格線
           xAxis.spaceMin = 5;//設定label間隔
           xAxis.granularityEnabled = true // 重複的值不顯示
//           xAxis.granularity = 3
            
           xAxis.labelTextColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)  //label文字顏色
           xAxis.labelFont = .systemFont(ofSize: 12)
           xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)//自定義x軸文字

        //設定Y軸樣式
           
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.leftAxis.enabled = false  //不繪製左邊軸
        lineChartView.rightAxis.drawAxisLineEnabled = false //右邊框不要封住
//        lineChartView.leftAxis.drawAxisLineEnabled = false
            let rightAxis = lineChartView.rightAxis
//            rightAxis.labelCount = prices.count //Y軸label數量，數值不一定，如果forceLabelsEnabled等於YES, 則強制繪製制定數量的label, 但是可能不平均
            rightAxis.forceLabelsEnabled = false //不強制繪製指定數量的label
            rightAxis.inverted = false //是否將Y軸進行上下翻轉
            rightAxis.axisLineWidth = 1.0/UIScreen.main.scale //設定Y軸線寬
            rightAxis.axisLineColor = UIColor.cyan//Y軸顏色
            rightAxis.labelPosition = .outsideChart//label位置
            rightAxis.labelTextColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) //文字顏色
            rightAxis.labelFont = UIFont.systemFont(ofSize: 12)//文字字型
        
        //設定Y軸網格樣式
        rightAxis.gridColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1) //網格線顏色
        rightAxis.gridAntialiasEnabled = true //開啟抗鋸齒
        lineChartView.pinchZoomEnabled = false
        lineChartView.legend.enabled = false//關閉折線圖底部圖例
        
    }
    

    func getAverage(houses:Array<HouseModel>) -> String {
        var totalPrice = 0.0
        for index in 0...houses.count-1{
            totalPrice += houses[index].price/houses[index].ping
        }
        return String(format: "%.1f", totalPrice/Double(houses.count)/10000)
    }
    
    
    func getPerYear(houses:Array<HouseModel>)-> String {
        var totalPrice = 0.0
        var  changeInYear = 0.0

        //一年前(西元時間Date)
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1 , to: currentDate )
        // 一年前(民國時間字串)
        let date1 = DateUtil.shared.date2String(oneYearAgo! , dateFormat: "yyyy-MM-dd HH:mm:ss")
        //一年前(民國時間Date)
        let date2 = DateUtil.shared.stringToDate(withFormat : "yyy-MM-dd HH:mm:ss" ,strDate: date1)
        
        for index in 0...houses.count-1{
      
            //房屋移轉日(民國Date)
            let houseChangedate = DateUtil.shared.getDateFromString(withFormat: "yyyMMdd" ,strDate: houses[index].transactionTime)

            if houseChangedate > date2{
                totalPrice += houses[index].price/houses[index].ping
                changeInYear += 1
            }
        }
        let averageNum = totalPrice/changeInYear
        return String(format: "%.1f", averageNum/10000)
    }
    
    func getHigh(houses:Array<HouseModel>) -> String {
        var highPrice = 0.0
        for index in 0...houses.count-1{
            if houses[index].price/houses[index].ping > highPrice{
                highPrice = houses[index].price/houses[index].ping
            }
        }
        return String(format: "%.1f", highPrice/10000)
    }
    func getLow(houses:Array<HouseModel>) -> String {
        var lowPrice = 100000000.0
        for index in 0...houses.count-1{
            if houses[index].price/houses[index].ping < lowPrice{
                lowPrice = houses[index].price/houses[index].ping
            }
        }
        return String(format: "%.1f", lowPrice/10000)
    }

    func getHowLong(){
        
    }
    
    func initType() -> TTGTextTagConfig{
        
        typeCV.alignment = .left
        typeCV.delegate = self
        typeCV.enableTagSelection = false
        typeCV.frame = CGRect(x: houseNameLB.frame.origin.x+20, y:screenSize.height*0.17, width: view.frame.size.width*0.85, height: 40)
        
        let config = TTGTextTagConfig()
        config.exactHeight = 20
        config.backgroundColor = #colorLiteral(red: 0.9804592729, green: 0.8038008809, blue: 0.2341449261, alpha: 1)
        config.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        config.textFont.withSize(12)
        
        config.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        config.cornerRadius = 5
//        config.exactWidth = screenSize.width*0.12
        return config
        
    }
}


extension TruePriceViewController: UITableViewDataSource ,UITableViewDelegate{
    
    // 一個 tabelView 中有幾個 section（table view可以有多個區塊，但預設是一個）
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseArray?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TruePriceTableViewCell", for: indexPath) as! TruePriceTableViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = #colorLiteral(red: 0.9791635871, green: 0.9526864886, blue: 0.8682376146, alpha: 1)
        cell.layer.masksToBounds = true
        

//        let month = houseArray![indexPath.row].transactionTime%10000/100
//        let year = houseArray![indexPath.row].transactionTime/10000
//        cell.timeLB.text = "\(year)年\(month)月"
  
        cell.timeLB.text = DateUtil.shared.getStrFormatDateStr(withFormat: "yyymmdd" ,strDate: houseArray![indexPath.row].transactionTime)
        
        
        cell.floorLB.text = houseArray![indexPath.row].floor == "0" ? "-" : houseArray![indexPath.row].floor + "樓"
        cell.pingLB.text = String(format: "%.2f", houseArray![indexPath.row].ping)+"坪"
        cell.patternLB.text = houseArray![indexPath.row].pattern
        cell.priceLB.text = String(format: "%d", Int(houseArray![indexPath.row].price/10000))+"萬"
        cell.averagePriceLB.text = String(format: "%.2f", houseArray![indexPath.row].price/houseArray![indexPath.row].ping/10000)+"萬/坪"
        
        
        return cell
    }
    
    
    //點擊cell後避免一直選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

