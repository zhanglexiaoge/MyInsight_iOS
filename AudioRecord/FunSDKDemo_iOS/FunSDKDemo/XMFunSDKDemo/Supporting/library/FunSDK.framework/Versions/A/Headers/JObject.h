#pragma once
#include <iostream>
#include <vector>

#ifndef JOBJECT_H
#define JOBJECT_H

#define NTS(x) #x
typedef void* PJSON_DATA;
typedef void* PJSON_STRING;
class JObject
{
public:
	JObject(JObject *pParent = NULL, const char *szName = "");
	virtual ~JObject(void);

public:
	virtual int Parse(const char *szJson);
	virtual int Parse(PJSON_DATA pParent, int index = -1);
	virtual const char *ToString();
    virtual const char* Name(){return name;};
    virtual void SetName(const char*nm);
    
    virtual int ToInt();
    virtual bool ToBool();
    virtual int SetValue(const char *szValue);
    virtual int SetValue(bool bValue);
    virtual int SetValue(int nValue);
    
protected:
	virtual void Clear();
    virtual JObject *NewChild(){return NULL;};

protected:
	char *name;
	PJSON_DATA _pJSData;
    PJSON_DATA _pRoot;
	std::vector<JObject *> _items;
	PJSON_STRING _sJsonReslt;
};


class JIntObj : public JObject
{
public:
    JIntObj(JObject *pParent = NULL, const char *szName = "");
    virtual ~JIntObj(void);
    
public:
    int Value();
    virtual void operator=(const int nValue);
};

class JDoubleObj : public JObject
{
public:
    JDoubleObj(JObject *pParent = NULL, const char *szName = "");
    virtual ~JDoubleObj(void);
    
public:
    double Value();
    virtual void operator=(const double nValue);
};

class JStrObj : public JObject
{
public:
    JStrObj(JObject *pParent = NULL, const char *szName = "");
    virtual ~JStrObj(void);
    
public:
    const char *Value();
    virtual void operator=(const char *szValue);
    
protected:
    void *_sValue;
};

class JIntHex : public JStrObj
{
public:
    JIntHex(JObject *pParent = NULL, const char *szName = "");
    virtual ~JIntHex(void);
    int SetValue(bool bValue);
    int SetValue(int nValue);
    int ToInt();
    
public:
    int Value();
    virtual void operator=(int);
};

class JBoolObj : public JObject
{
public:
    JBoolObj(JObject *pParent = NULL, const char *szName = "");
    virtual ~JBoolObj(void);
    
public:
    bool Value();
    virtual void operator=(const bool bValue);
};

template <class T>
class JObjArray : public JObject
{
public:
    JObjArray(JObject *pParent = NULL, const char *szName = ""):
    JObject(pParent, szName)
    {
    };
    virtual ~JObjArray(void){};
    
public:
    T &operator[] (const int index)
    {
        return *_arrayItems[index];
    };
    void Clear()
    {
        typename std::vector<T*>::iterator iter = _arrayItems.begin();
        while ( iter != _arrayItems.end() )
        {
            if( *iter )
            {
                delete *iter;
            }
            iter++;
        }
        _arrayItems.clear();
        _items.clear();
        JObject::Clear();
    };
    JObject *NewChild()
    {
        T *pNew = new T();
        _arrayItems.push_back(pNew);
        return (JObject *)pNew;
    };
    
public:
    int Size()
    {
        return (int)_arrayItems.size();
    };
    
private:
    std::vector<T*> _arrayItems;
};

#endif //JOBJECT_H
