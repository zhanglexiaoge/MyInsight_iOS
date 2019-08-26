//
//  TimePickerVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/8/26.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit

/*
 * 时间选择器 时分
 */
class TimePickerVC: UIViewController {
    //  背景view
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    // 容器view 用来承装按钮 和 时间选择器
    var containerView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    // 创建取消按钮
    var cancelBtn = { () -> UIButton in
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("取消", for: UIControl.State.normal)
        button.backgroundColor = UIColor.gray
        return button
    }()
    // 创建确认按钮
    var confirmBtn = { () -> UIButton in
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("确定", for: UIControl.State.normal)
        button.backgroundColor = UIColor.blue
        return button
    }()
    

    // 时间选择器 开始
    var beginTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = UIColor.white
        picker.locale = Locale(identifier: "en_GB")
        picker.timeZone = TimeZone.current
        picker.datePickerMode = UIDatePicker.Mode.time
        return picker
    }()
    
    /// 时间选择器 结束
    var endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = UIColor.white
        picker.locale = Locale(identifier: "en_GB")
        picker.timeZone = TimeZone.current
        picker.datePickerMode = UIDatePicker.Mode.time
        return picker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.modalPresentationStyle = UIModalPresentationStyle.custom //控制器页面不隐藏
        // 按钮点击的动作方法
        self.cancelBtn.addTarget(self, action: #selector(cancelButtonAction(button:)), for: UIControl.Event.touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(confirmButtonAction(button:)), for: UIControl.Event.touchUpInside)
        // 时间选择器动作方法
        self.beginTimePicker.addTarget(self, action: #selector(startTimePickerDateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        self.endTimePicker.addTarget(self, action: #selector(endTimePickerDateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        
        // 添加到view
        self.view.addSubview(self.backgroundView)

        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.cancelBtn)
        self.containerView.addSubview(self.confirmBtn)
        self.containerView.addSubview(self.beginTimePicker)
        self.containerView.addSubview(self.endTimePicker)

        // 设置约束
        self.setuptConstraint()
    }
    
    // 取消按钮的方法
    @objc func cancelButtonAction(button: UIButton) -> Void {
        debugPrint("取消按钮动作方法")
        self.dismiss(animated: true, completion: nil)
    }
    
    // 确定按钮的方法
    @objc func confirmButtonAction(button: UIButton) -> Void {
        debugPrint("确定按钮动作方法", self.beginTimePicker.date, self.endTimePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 时间选择器方法
    @objc func startTimePickerDateChanged(datePicker: UIDatePicker) -> Void {
        debugPrint("开始时间选择器")
    }
    
    @objc func endTimePickerDateChanged(datePicker: UIDatePicker) -> Void {
        debugPrint("结束时间选择器")
    }
    
    
    // MARK: 点击其他任意位置 页面消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // 选择的点
        let currentPoint = touches.first?.location(in: self.view)
        if !self.containerView.frame.contains(currentPoint ?? CGPoint()) {
            // 选择的点不在容器view上 页面消失(模态消失)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension TimePickerVC {
    // MARK: 设置控件之间的约束
    /*
     取消     确定
     开始pick 结束pick
     */
    private func setuptConstraint() -> Void {
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        self.confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        self.beginTimePicker.translatesAutoresizingMaskIntoConstraints = false
        self.endTimePicker.translatesAutoresizingMaskIntoConstraints = false

        // 容器添加约束
        // self.view.addConstraints
        
        // 背景颜色
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.backgroundView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
            ])
        
        // 容器
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.containerView, attribute: NSLayoutConstraint.Attribute.leftMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1.0, constant: 0), // 左边
            NSLayoutConstraint(item: self.containerView, attribute: NSLayoutConstraint.Attribute.rightMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1.0, constant: 0), // 右边
            NSLayoutConstraint(item: self.containerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 0), // 底部相等
            NSLayoutConstraint(item: self.containerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.3, constant: 0), // 高度
            ])
        
        // 取消按钮
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.cancelBtn, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: -10), // 顶部
            NSLayoutConstraint(item: self.cancelBtn, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 10), // 左边
            NSLayoutConstraint(item: self.cancelBtn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 80), // 宽
            NSLayoutConstraint(item: self.cancelBtn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 60), // 高
            ])
        
        // 确定按钮
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.confirmBtn, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: -10), // 顶部
            NSLayoutConstraint(item: self.confirmBtn, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1.0, constant: 10), // 右边
            NSLayoutConstraint(item: self.confirmBtn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 80), // 宽
            NSLayoutConstraint(item: self.confirmBtn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 60), // 高
            ])
        
        // 开始选择时间器
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.beginTimePicker, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.5, constant: 0), // 居中
            NSLayoutConstraint(item: self.beginTimePicker, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 2/5, constant: 0), // 和容器比宽度
            NSLayoutConstraint(item: self.beginTimePicker, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 5.0),// 底部
            NSLayoutConstraint(item: self.beginTimePicker, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.cancelBtn, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 5.0)// 顶部
            ])
        
        // 结束选择时间器
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.endTimePicker, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.5, constant: 0), // 居中
            NSLayoutConstraint(item: self.endTimePicker, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 2/5, constant: 0), // 和容器比宽度
            NSLayoutConstraint(item: self.endTimePicker, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 5.0),// 底部
            NSLayoutConstraint(item: self.endTimePicker, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.confirmBtn, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 5.0)// 顶部
            ])
    }
}

