/*********************************************************************************
 *Author:	Yongjun Zhao
 *Description:
 *History:
 Date:	2014.01.01/Yongjun Zhao
 Action: Create
 **********************************************************************************/
#pragma once

#if TARGET_OS_IOS == 1
#define OS_IOS 1
#endif

#ifdef WIN32
#ifdef XBASIC_EXPORTS
#define XBASIC_API __declspec(dllexport)
#else
#define XBASIC_API __declspec(dllimport)
#endif
#define CALLBACK __stdcall
#else
#define XBASIC_API
#define CALLBACK
#endif

#if (defined(WIN32)||defined(_WIN32) ||defined(__WIN32__)||defined(__NT__))
#define OS_WIN32
#else
#define OS_LINUX
//#define OS_IOS
#endif

#if defined(_MSC_VER)
#define CC_MSVC
#endif

#ifdef WIN32
#define UI_HANDLE	HWND
#define WM_FUN_MSG_ID   WM_USER+0x500
#else
#define UI_HANDLE	int
#endif

typedef unsigned int FUN_HANDLE;
#define LP_WND_OBJ void *

#ifdef OS_WIN32
//#define _WIN32_WINNT  0x0400
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#undef WIN32_LEAN_AND_MEAN
#else
#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <errno.h>
#include <pthread.h>
#endif

#ifdef OS_ANDROID
#include <jni.h>
#include <android/log.h>
#endif

// 一般库建议都加上命名空间，以防冲突
// 命名空间快速定义 开始与结束
#define NS_XBASIC_BEGIN namespace XBASIC {
#define NS_XBASIC_END_AND_USE }using namespace XBASIC;

#define NS_BEGIN(Name) namespace Name {
#define NS_END_AND_USE(Name) }using namespace Name;
#define NS_END }

/////////////////////////Type Defines////////////////////////////////////////////////
#ifndef byte
typedef unsigned char byte;
#endif

#ifndef int8
typedef char int8;
#endif

#ifndef uint8
typedef unsigned char uint8;
#endif

#ifndef int16
typedef short int16;
#endif

#ifndef uint16
typedef unsigned short uint16;
#endif

#ifndef int32
typedef long int32;
#endif

#ifndef uint32
typedef unsigned long uint32;
#endif

#ifndef float32
typedef float float32;
#endif

#ifndef float64
typedef double float64;
#endif

#ifndef octet
typedef unsigned char octet;
#endif

#ifndef sstring
typedef char* sstring;
#endif

#ifndef displayString
typedef char* displayString;
#endif

#ifndef octetString
typedef unsigned char* octetString;
#endif

#ifndef binaryString
typedef unsigned char* binaryString;
#endif

#ifndef uint64
#if defined( WIN32 )
typedef unsigned __int64	uint64;
#define FORMAT_INT64 "%I64d"
#else
typedef unsigned long long	uint64;
#define FORMAT_INT64 "%lld"
#endif
#endif

typedef int XHANDLE;

#ifndef int64
#ifdef WIN32
typedef __int64	int64;
#else
typedef long long	int64;
#endif
#endif

#ifndef uint128
typedef struct { unsigned char octet[16]; } uint128;
#endif

#ifndef boolean
typedef uint8 boolean;
#endif

#ifndef ip_Address
typedef unsigned char* ip_Address;
#endif

#ifndef DateTime
typedef unsigned long DateTime;
#endif

//  4 bytes
#ifndef DWORD	// dw
#ifdef __LP64__
typedef unsigned int   	DWORD;
#else
typedef unsigned long   DWORD;
#endif // __LP64__
#endif

//#ifndef DWORD
//typedef unsigned long DWORD;
//#endif

#ifndef Bool
#define Bool int
#endif

//#ifndef DWORD
//typedef unsigned long       DWORD;
//#endif

#ifndef LONG
typedef long  LONG;
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define NULL 0
#endif

#ifndef INFINITE
#define INFINITE   -1
#endif

#ifndef pid_t
#define pid_t unsigned long
#endif

#ifndef atomic_t
#define	atomic_t	LONG
#endif

#ifndef HANDLE
typedef void * HANDLE;
#endif

#ifndef LPVOID
typedef void * LPVOID;
#endif

#ifndef LPBYTE
typedef unsigned char * LPBYTE;
#endif

#ifndef uchar
typedef unsigned char uchar;
#endif

#ifndef uint
typedef unsigned int uint;
#endif


///////////////////////////////////////////////////////////
class XMSG;
typedef struct MsgContent
{
    FUN_HANDLE sender;
    int id;
    int param1;
    int param2;
    int param3;
    const char *szStr;
    char *pObject;
    int nDataLen;
    int seq;
    XMSG *pMsg;
}MsgContent;

typedef struct MsgOption
{
    UI_HANDLE hUser;
    int id;
    int param1;
    int param2;
    int param3;
    const char *szStr;
    void *pData;
    int nDataLen;
    int seq;
    MsgOption()
    {
        this->hUser = 0;
        this->id = 0;
        this->param1 = 0;
        this->param2 = 0;
        this->param3 = 0;
        this->szStr = NULL;
        this->pData = 0;
        this->nDataLen = 0;
        this->seq = 0;
    }
}MsgOption;

typedef enum EAPP_STATE
{
    EAPP_STATE_ENTER_BACKGROUD = 0,
    EAPP_STATE_ACTIVE = 1,
}EAPP_STATE;

/////////////////////////XBasice MSG ID/////////////////////////////////////////
typedef enum EE_MSG
{
    //msg id must be lower than 'FUN_USER_MSG_BEGIN'!!!!
    EMSG_APP_ON_MSG_LOG = 1,
    EMSG_ON_TCP_CONNECT = 2,
    EMSG_LOG_INIT = 3,
    EMSG_APP_STATE = 4, // 0:  进入后台;  1: 进入前台
    EMSG_OBJ_STATE_UPDATE = 5,
    EMSG_UPDATE = 6,
    EMSG_ON_PTL_DATA = 7,
    EMSG_HEARDBEAT = 8,
    EMSG_ON_RESULT = 9,
    EMSG_ON_NET_CONNECT   = 10,
    EMSG_ON_NET_SEND_DATA = 11,
    EMSG_ON_NET_RECV_DATA = 12,
    EMSG_ON_NET_DISCONNECT = 13,   // net disconnected
    
    EMSG_MEDIA_DATA_PRIVATE = 100,
    EMSG_MEDIA_DATA_TS = 101,
    EMSG_MEDIA_DATA_PRIVATE_AUDIO = 102,
    
    FUN_LIB_MSG_BEGIN = 4000,
    
    //msg define end
    FUN_USER_MSG_BEGIN_1 = 5000,
    FUN_USER_MSG_BEGIN_2 = 6000,
    FUN_USER_MSG_BEGIN_3 = 7000,
    FUN_USER_MSG_BEGIN_4 = 8000,
    FUN_USER_MSG_BEGIN_5 = 9000,
    FUN_USER_MSG_BEGIN_6 = 10000,
    FUN_USER_MSG_BEGIN_7 = 11000,
    FUN_USER_MSG_BEGIN = 20000,
    
    //do not define any msg id after this len!!
    
}EE_MSG;

#define INVALID_USER -1
#define INVALID_OBJECT 0

extern const char STR_NULL[4];

////////////////////////XBasic Error NO/////////////////////////////
typedef enum EE_LIB_DEF_EEORR
{
    EE_OK = 0,
    EE_OBJ_NOT_EXIST = -1239510,
    EE_VALUE_NOT_EXIST = -1239511,
    EE_ERROR = -100000,
    EE_PARAM_ERROR = -99999,
    EE_CREATE_FILE = -99998,
    EE_OPEN_FILE = -99997,
    EE_WRITE_FILE = -99996,
    EE_READ_FILE = -99995,
    EE_NO_SUPPORTED = -99994,
    EE_NET = -99993,					// NET ERROR
    EE_OBJ_EXIST = -99992,
    EE_TIMEOUT = -99991,
    EE_NOT_FOUND = -99990,
    EE_NEW_BUFFER = -99989,
    EE_NET_RECV = -99988,
    EE_NET_SEND = -99987,
    EE_OBJECT_BUSY = -99986,
    EE_SERVER_INTERNAL_ERROR = -99985,  //服务器内部错误
    
    EE_USER_CANCEL = -90000,

    EE_FILE_IS_ILLEGAL = -90001, // FILE IS ILLEGAL
}EE_LIB_EEOR;

