#pragma once

//˵��:�ڽ������ͼ+ϸ�ü����������������ƶ����), ��һЩ������Ϣ���͵��ͻ��˺�
//�ͻ��˵��ñ�SDK��������
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

// ���ղ����ṹ��
// ���ղ���(������Χ����0~5��ֵԽ����̶�Խ�ߣ�
typedef struct tagFBLevel {
    double leyelarge;            //���۷Ŵ�̶� (0~5)
    double reyelarge;            //���۷Ŵ�̶� (0~5)
    double mouthlarge;            //�����С�̶� (0~5)
    double skinwhite;            //Ƥ�����׳̶� (0~5)
    double skinsoft;            //Ƥ�������̶�(ȥ���ơ���ߵ�)(0~5)
    double coseye;                //��ͫ�̶�(0~5)
    double facelift;            // �����̶�
} FBLevel;


//*********************************************************************
//����: �ͻ��������㷨�汾��������1001�����ӣ�1.001ǰΪ���汾��
//Return value:  error code,  
//*********************************************************************
int	LQ_FB_API	LQ_FB_GetVersion(void);

//*********************************************************************
//����: �ͻ��˵�������������
//Return value:  error code, 
//���� ��Χ0--5
//��Ҫ֪����Ϣ��������λ��
//*********************************************************************
int  LQ_FB_API   LQ_FB_DoFaceBeauty(
	int						nImgH,				/* (I)  //(�ӷ������˻��)ϸ�ü�����H */
	int						nImgW,				/* (I)  //(�ӷ������˻��)ϸ�ü�����W */
	const FBLevel*			vFBparam,			// (I)		  
	const BYTE*				fbinfo,				/* (I)	  //�ӷ������˻�õ�ǰ������Ϣ������������� */
	BYTE*					pDstMask,			/* (I/O)  //�ӷ������˻�ĵ�ǰδ����ϸ�ü�����mask */
	BYTE*					pDstImage			/* (I/O)  //�ӷ������˻�ĵ�ǰδ����ϸ�ü�����ǰ�� 	  */
);

#ifdef __cplusplus
}
#endif
