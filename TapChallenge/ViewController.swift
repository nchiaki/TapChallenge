//
//  ViewController.swift
//  TapChallenge
//
//  Created by chiaki on 2021/05/24.
//

import UIKit

struct TapNumber {
    var dispNumber: Int // 表示データ
    //var disptag: Int    // 表示先のボタン区別
    var isChoised: Bool // タップの有無
    
    static func tapinit() -> [TapNumber] {
        let rec0 = TapNumber(dispNumber:1, isChoised:false)
        let rec1 = TapNumber(dispNumber:2, isChoised:false)
        let rec2 = TapNumber(dispNumber:3, isChoised:false)
        let rec3 = TapNumber(dispNumber:4, isChoised:false)
        let rec4 = TapNumber(dispNumber:5, isChoised:false)
        let rec5 = TapNumber(dispNumber:6, isChoised:false)
        let rec6 = TapNumber(dispNumber:7, isChoised:false)
        let rec7 = TapNumber(dispNumber:8, isChoised:false)
        let rec8 = TapNumber(dispNumber:9, isChoised:false)
        return [rec0,rec1,rec2,rec3,rec4,rec5,rec6,rec7,rec8]
    }
    static func getByNumber(_ tapnumbers:[TapNumber], dispNumber: Int) -> TapNumber? {
        for tapnum in tapnumbers {
            if tapnum.dispNumber == dispNumber {
                return tapnum
            }
        }
        return nil
    }

}

class ViewController: UIViewController {

    @IBOutlet weak var tap1Button: UIButton!
    @IBOutlet weak var tap2Button: UIButton!
    @IBOutlet weak var tap3Button: UIButton!
    @IBOutlet weak var tap4Button: UIButton!
    @IBOutlet weak var tap5Button: UIButton!
    @IBOutlet weak var tap6Button: UIButton!
    @IBOutlet weak var tap7Button: UIButton!
    @IBOutlet weak var tap8Button: UIButton!
    @IBOutlet weak var tap9Button: UIButton!
    @IBOutlet weak var startBurron: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    var tapNumbers : [TapNumber] = []
    var tapButtons : [UIButton?] = []
    var nextNumber : Int = 0
    var addTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tapButtons.append(tap1Button!)
        tapButtons.append(tap2Button!)
        tapButtons.append(tap3Button!)
        tapButtons.append(tap4Button!)
        tapButtons.append(tap5Button!)
        tapButtons.append(tap6Button!)
        tapButtons.append(tap7Button!)
        tapButtons.append(tap8Button!)
        tapButtons.append(tap9Button!)

        gameStart()
    }
    
    func gameStart() {
        tapNumbers = TapNumber.tapinit()
        nextNumber = 1
        initTapNumber()
        startBurron.setTitle("スタート", for: .normal)
        startBurron.tag = 0
        for ix in 0...8 {
            tapButtons[ix]?.isEnabled = false
        }
        statusLabel.text = ""
    }

    func initTapNumber() {
        var recx = 0
        for num in tapNumbers {
            /*
            tapButtons[num.dispNumber-1]?.setTitle(String(num.dispNumber), for: .normal)
            tapButtons[num.dispNumber-1]?.tag = num.dispNumber
            tapButtons[num.dispNumber-1]?.isEnabled = true
            */
            tapButtons[recx]?.setTitle(String(num.dispNumber), for: .normal)
            tapButtons[recx]?.tag = recx
            tapButtons[recx]?.isEnabled = true
            recx += 1
        }
    }
    
    func shuffleTapnumber() {
        
        var appearNum = [TapNumber]()
        
        var rndnum = Int.random(in: 1..<10)
        //for ix in 0...8
        for _ in 0...8
        {
            // Tapボタン分処理
            if appearNum.count == 0 {
                // 最初の乱数は無条件に登録
                let trgt = TapNumber.getByNumber(tapNumbers, dispNumber: rndnum)
                //trgt?.disptag = ix + 1  // 表示先ボタンは更新
                appearNum.append(trgt!)
            } else {
                var isNouse = false
                while isNouse == false {
                    // 未使用乱数が見つかるまで
                    for alrdyRnd in appearNum {
                        if alrdyRnd.dispNumber == rndnum {
                            // 使用済み乱数は取り直して再チェック
                            isNouse = false
                            rndnum = Int.random(in: 1..<10)
                            break
                        } else {
                            isNouse = true
                        }
                    }
                }
                let trgt = TapNumber.getByNumber(tapNumbers, dispNumber: rndnum)
                //trgt?.disptag = ix + 1  // 表示先ボタンは更新
                appearNum.append(trgt!)
            }
            print("\(rndnum),",terminator: "")
        }
        print("\n")
        
        for ix in 0...8 {
            tapButtons[ix]?.setTitle(String(appearNum[ix].dispNumber), for: .normal)
            if appearNum[ix].isChoised == true {
                tapButtons[ix]?.isEnabled = false
            } else {
                tapButtons[ix]?.isEnabled = true
            }
        }
        
        tapNumbers  = appearNum
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        //let trgt = tapNumbers[sender.tag - 1]
        let trgt = tapNumbers[sender.tag]
        let dspnum = trgt.dispNumber
        
        print("Tapped:tag \(sender.tag) dspnum \(dspnum) nextNumber \(nextNumber)")

        if nextNumber == dspnum {
            //tapNumbers[sender.tag - 1].isChoised = true
            //tapButtons[sender.tag - 1]?.isEnabled = false
            tapNumbers[sender.tag].isChoised = true
            tapButtons[sender.tag]?.isEnabled = false
            if tapNumbers.count <= nextNumber {
                addTimer.invalidate()
                //statusLabel.text = "！！！終了！！！"
            } else {
                nextNumber += 1
            }
        } else {
            shuffleTapnumber()
        }

        
        printtapNumbers("NumberButton:")
    }
    
    var startDate = Date()
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            printtapNumbers("Start:")
            shuffleTapnumber()
            for ix in 0...8 {
                tapButtons[ix]?.isEnabled = true
            }
            startDate = Date()
            addTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
            
            // アクションボタンの更新
            startBurron.setTitle("やり直し", for: .normal)
            startBurron.tag = 1
            printtapNumbers("Start end:")
        } else if sender.tag == 1 {
            printtapNumbers("ReStart:")
            addTimer.invalidate()
            gameStart()
        }
    }
    
    
    var tmrix = 0;
    @objc func timerCounter() {
        let  pasrDate = Date().timeIntervalSince(startDate)
 
        let min = (Int)(fmod((pasrDate/60), 60))
        let sec = (Int)(fmod(pasrDate, 60))
        let msc = (Int)((pasrDate - floor(pasrDate))*100)
        statusLabel.text = "\(min):\(sec).\(msc)"
    }
    
    let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func printtapNumbers(_ title:String) {
        print(title)
        for trgt in tapNumbers {
            print(trgt)
        }
    }
}

