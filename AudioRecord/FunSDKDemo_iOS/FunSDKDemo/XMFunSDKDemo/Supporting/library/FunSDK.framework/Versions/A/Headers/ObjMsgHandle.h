//
//  ObjMsgHandle.h
//
//  Created by zyj on 16/12/10.
//  Copyright (c) 2016年 hzjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunSDK.h"

class CObjMsgHandle
{
public:
    CObjMsgHandle(){
        _pWnd = 0;
        _hWnd = 0;
    };
    
    virtual ~CObjMsgHandle(){
        UnInit();
    };
    
    UI_HANDLE GetId(id pWnd){
        if (_hWnd == 0) {
            Init((__bridge void *)pWnd);
        }
        return _hWnd;
    };
    
    void UnInit(){
        if(_hWnd != 0){
            FUN_UnRegWnd(_hWnd);
            _hWnd = 0;
        }
    };
    
private:
    void Init(void *pWnd){
        _pWnd = pWnd;
        _hWnd = FUN_RegWnd(pWnd);
    };
    
private:
    UI_HANDLE _hWnd;
    void *_pWnd;
};

#define MSG_HANDLE_DEF CObjMsgHandle funSDKMsgHandle
#define MSG_HANDLE self.funSDKMsgHandle.GetId(self)

