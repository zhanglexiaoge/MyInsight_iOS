#ifndef __IRSDK_C_H__
#define __IRSDK_C_H__

#include "data_define.h"

// Brand
typedef struct 
{
	int brand_id;
	char brand_cn[32];
	char brand_tw[32];
	char brand_en[32];
	char brand_other[32];
	char brand_pinyin[32];
	char py[8];
	char remarks[32];
}Brand_c;

typedef struct
{
	int num;
	Brand_c Brand[128];
}Brands;

// Infrared
typedef struct 
{
	long key_id;
	int key_type;
	int func;
	char data[768];
	int freq;
	int mark;
	int ir_mark;
	int quality;
	int priority;
}Infrared_c;

typedef struct
{
	int num;
	Infrared_c Infrared[32];
}Infrareds;

// Key
typedef struct 
{
	long key_id;
	char name[32];
	int type;
	char remote_id[64];
	int protocol;
}Key_c;

typedef struct
{
	int num;
	Key_c Key[32];
}Keys;

// Remote
typedef struct 
{
	char remote_id[64];			//  遥控器ID
	int type;
	char name[32];		// 遥控器名称
	int brand_id;
	char model[32];
}Remote_c;

typedef struct
{
	int num;
	Remote_c Remote[32];
}Remotes;

// Room
typedef struct 
{
	int room_id;
	char name[32];
	int remote_num;
	char remote_name_list[32][16];
}Room_c;

typedef struct
{
	int num;
	Room_c Room[32];
}Rooms;

// MatchPage
typedef struct 
{
	int appliance_type;
	int brand_id;
	int num;
	char models[32][16];
	int page;
}MatchPage_c;

typedef struct
{
	int num;
	MatchPage_c MatchPage[32];
}MatchPages;

typedef struct 
{
	int key;
	char remote_id[64];
	char model[32];
	char code[768];
}MatchResult_c;

typedef struct
{
	int num;
	MatchResult_c MatchResult[32];
}MatchResults;

typedef struct 
{
	// 未使用
	int wind_mask;
	// 未使用
	int protocol;
	// 未使用
	int current_key;
	// 未使用
	int last_key;
	// 未使用
	int click_count;
	// 未使用
	int timer_value;
	// 开关，0为关，1为开
	int power;
	// 模式, 0自动，1制冷，2除湿 ，3送风，4制暖
	int mode;
	// 温度 16-30
	int temp;
	// 风量 0自动，1第一档，2第二档，3第三档
	int wind_amout;
	// 未使用
	int wind_dir;
	// 未使用
	int wind_hor;
	// 未使用
	int wind_ver;
	// 未使用
	int super_mode;
	// 未使用
	int sleep;
	// 未使用
	int aid_hot;
	// 未使用
	int timer;
	// 未使用
	int temp_display;
	// 未使用
	int power_saving;
	// 未使用
	int anion;
	// 未使用
	int comport;
	// 未使用
	int fresh_air;
	// 未使用
	int light;
	// 未使用
	int wet;
	// 未使用
	int mute;
}AirRemoteState_c;

typedef struct
{
	int num;
	AirRemoteState_c AirRemoteState[32];
}AirRemoteStates;

void IRemoteClient_SetPath(char* path);

void IRemoteClient_LoadBrands(Brand_c* brands, int& num);
void IRemoteClient_GetBrandNum(int type, int& num);
void IRemoteClient_LoadBrands(int type, Brand_c* brands, int& num);
void IRemoteClient_GetRemoteNum(int& num);
void IRemoteClient_LoadRemotes(Remote_c* remotes, int &num);
void IRemoteClient_ExactMatchRemotes(MatchPage_c* page, Key_c* key, MatchResult_c* results, int& num);
void IRemoteClient_ExactMatchAirRemotes(MatchPage_c* page, Key_c* key, AirRemoteState_c* state, MatchResult_c* results, int& num);

void IRemoteManager_GetAllRooms(Room_c* rooms, int& num);
void IRemoteManager_GetRemoteFromRoom(Room_c room, Remote_c* remotes, int& num);
void IRemoteManager_GetRemoteByID(char* name, char* remote_id, Remote_c* remote);
void IRemoteManager_AddRemoteToRoom(Remote_c* remote, Room_c* room);
void IRemoteManager_DeleteRemoteFromRoom(Remote_c* remote, Room_c* room);
void IRemoteManager_AddRemote(Remote_c* remote);
void IRemoteManager_AddRoom(Room_c* room);
void IRemoteManager_DeleteRoom(Room_c* room);
void IRemoteManager_ChangeRoomName(Room_c* room, char* name);

void IInfraredFetcher_FetchInfrareds(Remote_c* remote, Key_c* key, Infrared_c* infrareds, int& num);
int IInfraredFetcher_GetAirRemoteStatus(Remote_c* remote, AirRemoteState_c* state);
int IInfraredFetcher_SetAirRemoteStatus(char* remote_name, AirRemoteState_c* state);
void IInfraredFetcher_FetchAirTimerInfrared(Remote_c* remote, Key_c* key, AirRemoteState_c* state, int time,  Infrared_c* infrareds, int& num);
void IInfraredFetcher_TranslateInfrared(char* code, unsigned char* data, int& num);

#endif
