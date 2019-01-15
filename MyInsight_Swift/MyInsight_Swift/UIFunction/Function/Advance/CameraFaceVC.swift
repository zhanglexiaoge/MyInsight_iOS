//
//  CameraFaceVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/1/14.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import AVFoundation

class CameraFaceVC: UIViewController {
    // 相机人脸
    
    fileprivate var session = AVCaptureSession()
    fileprivate var deviceInput: AVCaptureDeviceInput?
    
    fileprivate var previewLayer = AVCaptureVideoPreviewLayer()
    // 设备
    fileprivate var device: AVCaptureDevice!
    
    /// 存放每一张脸的字典[faceID: id]
    fileprivate var faceLayers = [String: Any]()
    
    @IBOutlet weak var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "人脸相机"
        self.view.backgroundColor = UIColor.white
        
        // 创建相机
        self.createCamera()
    }
    
    // MARK:  创建摄像头
    func createCamera() -> Void {
        //1.获取输入设备（摄像头）
        //guard let device = AVCaptureDevice.default(for: .video) else { return }
        let devices: [AVCaptureDevice] = AVCaptureDevice.devices(for: AVMediaType.video)
        
        for device in devices {
            if device.position == .front{
                self.device = device
            }
        }
        
        //2.根据输入设备创建输入对象
        guard let deviceIn = try? AVCaptureDeviceInput(device: device) else { return }
        deviceInput = deviceIn
        
        //3.创建原数据的输出对象
        let metadataOutput = AVCaptureMetadataOutput()
        
        //4.设置代理监听输出对象输出的数据，在主线程中刷新
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //5.设置输出质量(高像素输出)
        session.sessionPreset = .high
        
        //6.添加输入和输出到会话
        if session.canAddInput(deviceInput!) {
            session.addInput(deviceInput!)
        }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        
        //7.告诉输出对象要输出什么样的数据,识别人脸, 最多可识别10张人脸
        metadataOutput.metadataObjectTypes = [.face]
        
        //8.创建预览图层
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.insertSublayer(previewLayer, at: 0)
        
        //9.设置有效扫描区域(默认整个屏幕区域)（每个取值0~1, 以屏幕右上角为坐标原点）
        metadataOutput.rectOfInterest = previewView.bounds
        
        //10. 开始扫描
        if !session.isRunning {
            DispatchQueue.global().async {
                self.session.startRunning()
            }
        }
    }
}


extension CameraFaceVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        debugPrint("照相机.... \(metadataObjects) ")
        
        guard metadataObjects.count != 0 else {
            debugPrint("人脸识别数组元素个数为0")
            return
        }
        
        handleOutput(didDetect: metadataObjects, previewLayer: previewLayer)
        
    }
    
    func handleOutput(didDetect faceObjects: [AVMetadataObject], previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        
        //1. 获取预览图层的人脸数组
        let transformFaces = transformedFaces(faceObjs: faceObjects)
        
        //2. 拷贝一份所有人脸faceID字典
        var lostFaces = [String]()
        for faceID in faceLayers.keys {
            lostFaces.append(faceID)
        }
        
        //3. 遍历所有的face
        for i in 0..<transformFaces.count {
            guard let face = transformFaces[i] as? AVMetadataFaceObject  else { return }
            //3.1 判断是否包含该faceID``
            if lostFaces.contains("\(face.faceID)"){
                lostFaces.remove(at: i)
            }
            
            //3.2 获取图层
            var faceLayer = faceLayers["\(face.faceID)"] as? CALayer
            if faceLayer == nil{
                //创建图层
                faceLayer = creatFaceLayer()
                self.previewView.layer.addSublayer(faceLayer!)
                //添加到字典中
                faceLayers["\(face.faceID)"] = faceLayer
            }
            
            //3.3 设置layer属性
            faceLayer?.transform = CATransform3DIdentity
            faceLayer?.frame = face.bounds
            
            //3.4 设置偏转角(左右摇头)
            if face.hasYawAngle{
                let tranform3D = transformDegress(yawAngle: face.yawAngle)
                
                //矩阵处理
                faceLayer?.transform = CATransform3DConcat(faceLayer!.transform, tranform3D)
            }
            
            //3.5 设置倾斜角,侧倾角(左右歪头)
            if face.hasRollAngle{
                let tranform3D = transformDegress(rollAngle: face.rollAngle)
                
                //矩阵处理
                faceLayer?.transform = CATransform3DConcat(faceLayer!.transform, tranform3D)
            }
            
            //3.6 移除消失的layer
            for faceIDStr in lostFaces{
                let faceIDLayer = faceLayers[faceIDStr] as? CALayer
                faceIDLayer?.removeFromSuperlayer()
                faceLayers.removeValue(forKey: faceIDStr)
            }
        }
    }
    
    //返回的人脸数组处理
    fileprivate func transformedFaces(faceObjs: [AVMetadataObject]) -> [AVMetadataObject] {
        var faceArr = [AVMetadataObject]()
        for face in faceObjs {
            //将扫描的人脸对象转成在预览图层的人脸对象(主要是坐标的转换)
            if let transFace = previewLayer.transformedMetadataObject(for: face){
                faceArr.append(transFace)
            }
        }
        return faceArr
    }
    
    //创建图层
    fileprivate func creatFaceLayer() -> CALayer{
        let layer = CALayer()
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 3
        //添加layer内容物
        //        layer.contents = UIImage(named: "")?.cgImage
        return layer
    }
    
    //处理倾斜角问题
    fileprivate func transformDegress(yawAngle: CGFloat) -> CATransform3D {
        let yaw = degreesToRadians(degress: yawAngle)
        //围绕Y轴旋转
        let yawTran = CATransform3DMakeRotation(yaw, 0, -1, 0)
        //红框旋转问题
        return CATransform3DConcat(yawTran, CATransform3DIdentity)
    }
    
    //处理偏转角问题
    fileprivate func transformDegress(rollAngle: CGFloat) -> CATransform3D {
        let roll = degreesToRadians(degress: rollAngle)
        //围绕Z轴旋转
        return CATransform3DMakeRotation(roll, 0, 0, 1)
    }
    
    //角度转换
    fileprivate func degreesToRadians(degress: CGFloat) -> CGFloat{
        return degress * CGFloat(Double.pi) / 180
    }
}

/*
 [JunFaceRecognition](https://github.com/CoderTitan/JunFaceRecognition)
 [CameraDemo](https://github.com/Jsonmess/CameraDemo)
 [AVCaptureDeviceCamera](https://github.com/hisasann/AVCaptureDeviceCamera)
 [MK_Camera](https://github.com/dearmiku/MK_Camera)
 
 [iOS 上的相机捕捉 swift](https://www.cnblogs.com/Hakim/p/6606067.html)
 
 */




