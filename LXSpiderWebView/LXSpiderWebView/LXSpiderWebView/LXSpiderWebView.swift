//
//  LXSpiderWebView.swift
//  LXSpiderWebView
//
//  Created by 罗欣 on 2019/1/8.
//  Copyright © 2019 罗欣. All rights reserved.
//  高度定制化多边形峰值图（自由设置多边形边数）

import UIKit


/// 多边形每个顶点 （根据需求可以任意添加和减少）
///
/// - LXSpiderWeb0: 第1个顶点 最上方
/// - LXSpiderWeb1: 第2个顶点
/// - LXSpiderWeb2: 第3个顶点
/// - LXSpiderWeb3: 第4个顶点
/// - LXSpiderWeb4: 第5个顶点
enum LXSpiderWebItemType: Int {
    case LXSpiderWeb0 = 0
    case LXSpiderWeb1
    case LXSpiderWeb2
    case LXSpiderWeb3
    case LXSpiderWeb4
    
    var titleStr: String {
        get{
            switch self {
            case .LXSpiderWeb0:
                return "顶点0"
            case .LXSpiderWeb1:
                return "顶点1"
            case .LXSpiderWeb2:
                return "顶点2"
            case .LXSpiderWeb3:
                return "顶点3"
            case .LXSpiderWeb4:
                return "顶点4"
            }
        }
    }
    
}

class LXSpiderWebView: UIView {

    var rectSize: CGRect
    
    //前景多边形
    private var spiderWebView: UIView
    private var spiderWebLayer: CAShapeLayer
    
    private var centrePoint: CGPoint
    
    private var radius: CGFloat
    private var LXSideNum: Int = 5
    //蜘蛛网层数（可以修改展示）
    private var spiderNum: Int = 5

    private var strokeLineWith: CGFloat
    
    private var path: UIBezierPath = UIBezierPath.init()
    
    
    /// 要绘制的多边形顶点值（保存以作修改）
    private var pointArr : [NSValue]
    
    override init(frame: CGRect) {
        
        LXSideNum = 5
        strokeLineWith = 1.0
        
        radius = frame.size.height/2 - strokeLineWith
        centrePoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        rectSize = frame
        
        spiderWebView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        spiderWebView.alpha = 0.6
        spiderWebLayer = CAShapeLayer()
        spiderWebLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        spiderWebView.layer.addSublayer(spiderWebLayer)
        
        //默认为0.1最大半径
        pointArr = getPointWithRadius(centerPoint: centrePoint, radius: radius*0.1, sideNum: LXSideNum)
        
        super.init(frame: frame)
        
        buildBackgroundSpiderLayer()
    }
    
    
    /// 初始化多边形
    ///
    /// - Parameters:
    ///   - frame: 坐标（必须设置）
    ///   - sideNum: 多边形边数最小设置3
    init(frame: CGRect , sideNum: Int) {
        
        LXSideNum = sideNum
        strokeLineWith = 1.0
        
        radius = frame.size.height/2 - strokeLineWith
        centrePoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        rectSize = frame
        
        spiderWebView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        spiderWebView.alpha = 0.6
        spiderWebLayer = CAShapeLayer()
        spiderWebLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        spiderWebView.layer.addSublayer(spiderWebLayer)
        
        //默认为0.1最大半径
        pointArr = getPointWithRadius(centerPoint: centrePoint, radius: radius*0.1, sideNum: LXSideNum)
        
        super.init(frame: frame)
        
        buildBackgroundSpiderLayer()
        buildForwardsSpiderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension LXSpiderWebView {
    
    /// 修改单个顶点的峰值
    ///
    /// - Parameters:
    ///   - value: 峰值（0-1.0）
    ///   - type: 顶点位置（从12点方向逆时针排序）
    func spiderWebViewChangeValue(value: CGFloat , type: LXSpiderWebItemType?) {
        
        guard pointArr.count > type?.rawValue ?? 0 && type != nil else {
            print("顶点坐标数组数量有问题！")
            return
        }
        
        path.removeAllPoints()
        
        //获取需要改变值的顶点坐标
        let point = getPointWith(centerPoint: self.centrePoint, radius: self.radius*value, sideCount: type!.rawValue, sideNum: LXSideNum)
        
        pointArr[type!.rawValue] = NSValue(cgPoint: point)
        
        for (index,cgpoint) in pointArr.enumerated() {
            
            if index == 0 {
                
                path.move(to: cgpoint.cgPointValue)
            }else{
                path.addLine(to: cgpoint.cgPointValue)
            }
        }
        path.close()
        spiderWebLayer.path = path.cgPath
        spiderWebLayer.strokeColor = UIColorWithRGBA(140, 144, 157, 1).cgColor
        spiderWebLayer.fillColor = UIColorWithRGBA(29, 204, 140, 1).cgColor
        spiderWebLayer.lineWidth = 1.0
        
    }
    
}

extension LXSpiderWebView {
    
    /// 绘制蛛网背景
    private func buildBackgroundSpiderLayer() {
        
        for index in (0..<spiderNum).reversed() {
            
            let backGroundSpiderLayer = CAShapeLayer()
            backGroundSpiderLayer.frame = CGRect(x: 0, y: 0, width: rectSize.width, height: rectSize.height)
            self.layer.addSublayer(backGroundSpiderLayer)
            
            //获取绘制蛛网线的半径
            let value = CGFloat((index+1))/CGFloat(spiderNum)  * radius
            //根据中心点和半径获取每个顶点坐标数组
            let pointArr = getPointWithRadius(centerPoint: centrePoint, radius: value, sideNum: LXSideNum)
            //设置蛛网背景色 (对应每一层蛛网颜色)
            let color: UIColor
            if index%2 != 0 {
                color = UIColor.red
            }else
            {
                color = UIColor.blue
            }
            backgroundSpiderLayer(layer: backGroundSpiderLayer, pointArr: pointArr, color: color)
            
        }
        self.backgroundColor = UIColor.white
        
    }
    
    //背景SpiderLayer绘制方法
    private func backgroundSpiderLayer(layer: CAShapeLayer , pointArr: [NSValue] , color: UIColor) {
        
        guard pointArr.count > 0 else {
            return
        }
        //绘制网状路径
        let backGroundSpiderLayerPath = UIBezierPath()
        
        for (index,cgpoint) in pointArr.enumerated() {
            
            if index == 0 {
                
                backGroundSpiderLayerPath.move(to: cgpoint.cgPointValue)
            }else{
                backGroundSpiderLayerPath.addLine(to: cgpoint.cgPointValue)
            }
            
        }
        
        backGroundSpiderLayerPath.close()
        layer.path = backGroundSpiderLayerPath.cgPath
        layer.strokeColor = UIColorWithHex(0xeeeeee).cgColor
        layer.fillColor = color.cgColor
        layer.lineWidth = 0.8
        
    }
    
    
    private func buildForwardsSpiderView() {
        
        self.addSubview(spiderWebView)
        
        //初始的spiderLayer
        //(目的: 计算出 point0 - 1 的初始值)
        for index in 0..<LXSideNum {
            
            spiderWebViewChangeValue(value: CGFloat(0.1), type: LXSpiderWebItemType(rawValue: index))
            
        }
        
    }
    
}


/// 根据中心点半径多边形角数和当前角获得当前角的坐标值
///
/// - Parameters:
///   - centerPoint: 中心点
///   - radius: 半径
///   - sideCount: 想要获取坐标的角处于角数组的序列
///   - sideNum: 多边形总角数
fileprivate func getPointWith(centerPoint:CGPoint , radius: CGFloat ,sideCount: Int ,sideNum: Int) -> CGPoint {
    
    guard sideNum > 0 && sideNum >= 0 && sideCount < sideNum else {
        print("输入错误")
        
        return CGPoint(x: 0.0, y: 0.0)
    }
    
    /// 计算平均角度
    let avgsAngle: CGFloat = 360.0/CGFloat(sideNum)
    /// 计算当前点的 x 坐标
    let pointX: CGFloat = centerPoint.x-CGFloat.angleCosValue(90.0-avgsAngle*CGFloat(sideCount))*radius
    /// 计算当前点的 y 坐标
    let pointY: CGFloat = centerPoint.y-CGFloat.angleSinValue(90.0-avgsAngle*CGFloat(sideCount))*radius
    /// 将 x, y 坐标转换成 CGPoint 点
    let valuePoint = CGPoint(x: pointX, y: pointY)
    
    return valuePoint
}

// 通过 中心点 半径 和多边形角数 获取多边形的每个顶点坐标数组 return: 一个包含点数组
fileprivate func getPointWithRadius(centerPoint:CGPoint , radius: CGFloat ,sideNum: Int) ->[NSValue] {
    
    var sideNum = sideNum
    if sideNum < 3 {
        print("多边形最少设置三个角")
        sideNum = 3
    }
    // 保存每个点的 NSValue 数据
    var cornerPointsAttrs: [NSValue] = [NSValue]()
    // 计算多边形各个点的坐标
    // i为逆时针第i个点
    for i in 0..<sideNum {
        // 每个边长度所在的点
        // 计算每个点所在的坐标
        /*
         这里的 90.0 代表 第一个点是以 90 度 开始的， 即上图的 p0 位置是第一个点
         sideNum： 边数
         radius： 半径
         */
        /// 计算平均角度
        let avgsAngle: CGFloat = 360.0/CGFloat(sideNum)
        /// 计算每个点的 x 坐标
        let pointX: CGFloat = centerPoint.x-CGFloat.angleCosValue(90.0-avgsAngle*CGFloat(i))*radius
        /// 计算每个点的 y 坐标
        let pointY: CGFloat = centerPoint.y-CGFloat.angleSinValue(90.0-avgsAngle*CGFloat(i))*radius
        /// 将 x, y 坐标转换成 CGPoint 点
        let valuePoint = CGPoint(x: pointX, y: pointY)
        /// 将 每个点 转成 NSValue 类型并保存到属性数组中
        cornerPointsAttrs.append(NSValue(cgPoint: valuePoint))
        
        
    }
    
    return cornerPointsAttrs
}

// MARK: - 延展 通过三角函数计算 con 和 sin 角度的值
extension CGFloat {
    
    // 通过角度获取 cos 值
    static func angleCosValue(_ angle: CGFloat) -> CGFloat {
        return CGFloat(cos(Double.pi/180.0 * Double(angle)))
    }
    
    // 通过角度获取 sin 值
    static func angleSinValue(_ angle: CGFloat) -> CGFloat {
        return CGFloat(sin(Double.pi/180.0 * Double(angle)))
    }
    
}

/// 根据16进制字符串转UIColor
///
/// - Parameter rgbValue: 16进制字符串（0xFFFFFF）
/// - Returns: UIColor
func UIColorWithHex(_ rgbValue: Int) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: 1.0)
}



func UIColorWithRGBA(_ red : CGFloat,_ green : CGFloat , _ blue : CGFloat,_ alpha : CGFloat) -> UIColor{
    
    return UIColor(red: colorValue(red), green: colorValue(green), blue: colorValue(blue), alpha: alpha)
}
func colorValue(_ value : CGFloat) -> CGFloat {
    return value / 255.0
}
