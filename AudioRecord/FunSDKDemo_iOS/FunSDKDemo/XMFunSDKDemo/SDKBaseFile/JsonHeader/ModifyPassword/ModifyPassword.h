#pragma once
#import "FunSDK/JObject.h"
#define JK_ModifyPassword "ModifyPassword"
void MD5Encrypt(signed char *strOutput, unsigned char *strInput);
class ModifyPassword : public JObject   //修改密码相关
{
public:
	JStrObj		EncryptType;
	JStrObj		NewPassWord;
	JStrObj		PassWord;
	JStrObj		SessionID;
	JStrObj		UserName;

public:
	ModifyPassword(JObject *pParent = NULL, const char *szName = JK_ModifyPassword):
	JObject(pParent,szName),
	EncryptType(this, "EncryptType"),
	NewPassWord(this, "NewPassWord"),
	PassWord(this, "PassWord"),
	SessionID(this, "SessionID"),
	UserName(this, "UserName"){
        this->Parse("{\"Name\":\"ModifyPassword\", \"ModifyPassword\":{\"EncryptType\":\"MD5\",\"NewPassWord\":\"\",\"PassWord\":\"\",\"UserName\":\"admin\"}}");
	};

    void SetNewPassword(const char *szOld, const char *szNew){
        char szParam[64] = {0};
        MD5Encrypt((signed char *)szParam, (unsigned char*)szOld);
        szParam[8]='\0';
        this->PassWord = szParam;
        
        MD5Encrypt((signed char *)szParam, (unsigned char*)szNew);
        szParam[8]='\0';
        this->NewPassWord = szParam;
    };
	~ModifyPassword(void){};
};
