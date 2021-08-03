#pragma once

//说明:在进行完抠图+细裁剪操作后（这两步在云端完成), 将一些必须信息传送到客户端后
//客户端调用本SDK进行美容
//


#ifdef __cplusplus
extern "C" {
#endif


#ifdef	LIBBEAUTY_EXPORTS
#	define	LQ_FB_API		   __declspec( dllexport ) 
#else
#	define	LQ_FB_API		 
#endif

typedef unsigned char BYTE;

// 美颜参数结构体
// 美颜参数(参数范围均是0~5，值越大处理程度越高）
typedef struct tagFBLevel {
    double leyelarge;            //左眼放大程度 (0~5)
    double reyelarge;            //右眼放大程度 (0~5)
    double mouthlarge;            //嘴巴缩小程度 (0~5)
    double skinwhite;            //皮肤美白程度 (0~5)
    double skinsoft;            //皮肤美肤程度(去皱纹、祛斑等)(0~5)
    double coseye;                //美瞳程度(0~5)
    double facelift;            // 瘦脸程度
} FBLevel;


//*********************************************************************
//功能: 客户端美容算法版本，类似于1001这样子，1.001前为主版本号
//Return value:  error code,  
//*********************************************************************
int	LQ_FB_API	LQ_FB_GetVersion(void);

//*********************************************************************
//功能: 客户端单人照美容美化
//Return value:  error code, 
//参数 范围0--5
//需要知道信息：特征点位置
//*********************************************************************
int  LQ_FB_API   LQ_FB_DoFaceBeauty(
	int						nImgH,				/* (I)  //(从服务器端获的)细裁剪人脸H */
	int						nImgW,				/* (I)  //(从服务器端获的)细裁剪人脸W */
	const FBLevel*			vFBparam,			// (I)		  
	const BYTE*				fbinfo,				/* (I)	  //从服务器端获得当前人脸信息，痣的像素坐标 */
	BYTE*					pDstMask,			/* (I/O)  //从服务器端获的当前未美容细裁剪人脸mask */
	BYTE*					pDstImage			/* (I/O)  //从服务器端获的当前未美容细裁剪人脸前景 	  */
);

#ifdef __cplusplus
}
#endif
