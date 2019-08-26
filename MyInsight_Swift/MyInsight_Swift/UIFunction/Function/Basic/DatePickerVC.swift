//
//  DatePickerVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/8/26.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit


/*
 * 时间选择器 年月日
 */
class DatePickerVC: UIViewController {
    
    //  背景view
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    // 容器view 用来承装按钮 和 时间选择器
    var containerView: UIView = {
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
    
    
    // 时间选择器~
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.white
        datePicker.locale = Locale(identifier: "zh_CN") // 将日期设置显示成中文
        datePicker.datePickerMode = UIDatePicker.Mode.date
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        self.modalPresentationStyle = UIModalPresentationStyle.custom //控制器页面不隐藏
        // 按钮点击的动作方法
        self.cancelBtn.addTarget(self, action: #selector(cancelButtonAction(button:)), for: UIControl.Event.touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(confirmButtonAction(button:)), for: UIControl.Event.touchUpInside)
        // 时间选择器方法
        self.datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        
        self.view.addSubview(self.backgroundView)
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.cancelBtn)
        self.containerView.addSubview(self.confirmBtn)
        // 添加到view
        self.containerView.addSubview(self.datePicker)
        
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
        debugPrint("确定按钮动作方法", self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 时间选择器的动作方法
    @objc func dateChanged(datePicker: UIDatePicker) -> Void {
        
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

extension DatePickerVC {
    // MARK: 设置约束
    private func setuptConstraint() -> Void {
        
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        self.confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        // 时间选择器方法
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.datePicker, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0), // 居中
            NSLayoutConstraint(item: self.datePicker, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.confirmBtn, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 10), // 顶部
            NSLayoutConstraint(item: self.datePicker, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0),  // 底部
            NSLayoutConstraint(item: self.datePicker, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.containerView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0), // 宽度
            ])
    }
}
