//
//  VideoCaptureVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/1/11.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCaptureVC: UIViewController {
    //创建捕捉会话
    fileprivate var session: AVCaptureSession? = AVCaptureSession()
    //fileprivate var videoconnection: AVCaptureConnection?
    fileprivate var videoOutput: AVCaptureOutput?
    fileprivate var previewLayer: CALayer?
    fileprivate var videoInput: AVCaptureDeviceInput?
    fileprivate var fileOutput:AVCaptureMovieFileOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "视频采集"
        self.view.backgroundColor = UIColor.white
        
        //初始化视频输入输出
        setupVideoInputOutput()
        //初始化音频输入输出
        setupAudioInputOutput()
        //初始化预览图层
        setupPreviewLayer()
    }
    

}


// MARK: - 对采集的控制方法
extension VideoCaptureVC {
    @IBAction func startCapture(_ sender: Any) {
        if videoInput == nil {
            setupVideoInputOutput()
            setupAudioInputOutput()
            setupPreviewLayer()
        }
        session?.startRunning()
        
        //录制视频 存储
        setupMovieFileOutput()
        
    }
    
    @IBAction func endCapture(_ sender: Any) {
        //停止录制
        fileOutput?.stopRecording()
        //移除图层
        previewLayer?.removeFromSuperlayer()
        session?.stopRunning()
        videoInput = nil
        previewLayer = nil
        session = nil
    }
    
    //切换摄像头
    @IBAction func chageCamera(_ sender: Any) {
        guard let session = session else { return }
        //0.添加动画效果
        let rotaionAnim = CATransition()
        rotaionAnim.type = CATransitionType(rawValue: "oglFlip")
        rotaionAnim.subtype = CATransitionSubtype(rawValue: "fromLeft")
        rotaionAnim.duration = 0.5
        view.layer.add(rotaionAnim, forKey: nil)
        
        //1.取出之前镜头的方向
        guard let videoInput = videoInput else { return}
        let oritation: AVCaptureDevice.Position = videoInput.device.position == .front ? .back : .front
        guard let devices = AVCaptureDevice.devices() as?[AVCaptureDevice] else{return}
        guard let device = devices.filter({$0.position == oritation}).first else {return}
        guard let newInput = try? AVCaptureDeviceInput(device: device) else {return}
        
        let newOutput = AVCaptureVideoDataOutput()
        newOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        
        //移除之前的input 添加新的input
        session.removeInput(videoInput)
        session.removeOutput(videoOutput!)
        addInputOutput2session(newInput, newOutput)
        self.videoInput = newInput
        videoOutput = newOutput
        //videoconnection = newOutput.connection(withMediaType: AVMediaTypeVideo)
        
    }
    
}
//初始化方法
extension VideoCaptureVC {
    fileprivate func setupVideoInputOutput(){
        if session == nil {
            session = AVCaptureSession()
        }
        //1.添加视频的输入
        /**
         AVCaptureDevice.defaultDevice(withDeviceType: <#T##AVCaptureDeviceType!#>, mediaType: <#T##String!#>, position: <#T##AVCaptureDevicePosition#>)  --- 10.0以后的方法
         
         AVCaptureDevice.defaultDevice(withMediaType: <#T##String!#>)  -- 这个方法不适用因为不能选择前置还是后置摄像头
         */
        
        guard let devices = AVCaptureDevice.devices() as?[AVCaptureDevice] else{return}
        guard let device = devices.filter({$0.position == .front}).first else {return}
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        self.videoInput = input
        //2.添加视频的输出
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        addInputOutput2session(input, output)
        videoOutput = output
        //        videoconnection = output.connection(withMediaType: AVMediaTypeVideo)
    }
    
    fileprivate func setupAudioInputOutput(){
        //1.创建输入
        guard let device = AVCaptureDevice.default(for: AVMediaType.audio) else { return }
        guard let input = try?AVCaptureDeviceInput(device:device) else { return }
        
        //2.创建输出
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        addInputOutput2session(input, output)
        
    }
    
    fileprivate func addInputOutput2session(_ input: AVCaptureInput ,_ output: AVCaptureOutput){
        guard let session = session else { return }
        session.beginConfiguration()
        //3.添加输入输出
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output){
            session.addOutput(output)
        }
        
        //完成配置
        session.commitConfiguration()
    }
    
    fileprivate func setupPreviewLayer(){
        //创建预览图层
        guard let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!) else { return }
        
        //设置previewLayer的属性
        previewLayer.frame = view.bounds
        self.previewLayer = previewLayer
        //将图层添加到控制器的view的layer中
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    fileprivate func setupMovieFileOutput(){
        //1.创建写入文件的输出
        fileOutput = AVCaptureMovieFileOutput()
        // 获取视频的connection
        let connection = fileOutput!.connection(with: AVMediaType.video)
        //let connection = fileOutput!.connection(withMediaType: AVMediaTypeVideo)
        // 设置视频的稳定模式
        connection?.automaticallyAdjustsVideoMirroring = true
        //        fileOutput
        //2.开始写入文件
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/abc.mp4"
        let fileUrl = URL(fileURLWithPath: filePath)
        if session!.canAddOutput(fileOutput!){
            session?.addOutput(fileOutput!)
        }
        
        fileOutput?.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
}

extension VideoCaptureVC : AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate{
    
    //丢弃掉的
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    //两个代理实际采集代理方法一致  所以要区分
    //实际输出的
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        print(connection.output)
        
        //        if videoOutput?.connection(withMediaType: AVMediaTypeVideo) == connection {
        //             print("视频采集")
        //        }else{
        //            print("音频采集")
        //        }
    }
}

extension VideoCaptureVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        //开始写入文件
        print("开始录制")
    }
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        //写入文件完成
        print("结束录制")
    }
}

/*
 [AVFoundation之AVCapture音视频采集与写入](https://www.jianshu.com/p/ebbba2670d00)
 [视频采集demo](https://github.com/AnnieAri/AVCaptureDemo)
 
 [Swift – 开启前置相机并拍照](http://www.jobyme88.com/?st_ai=swift-%e5%bc%80%e5%90%af%e5%89%8d%e7%bd%ae%e7%9b%b8%e6%9c%ba%e5%b9%b6%e6%8b%8d%e7%85%a7)
 [Swift – 开启前置相机并拍照](https://blog.csdn.net/muerbingsha/article/details/80460088)
 */

