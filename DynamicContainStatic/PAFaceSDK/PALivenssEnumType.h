//
//  PALivenssEnumType.h
//  PALivenessDetector
//
//  Created by 刘沛荣 on 15/11/3.
//  Copyright © 2015年 PA. All rights reserved.
//

#ifndef PALivenssEnumType_h
#define PALivenssEnumType_h

/**
 Environmental ErrorEnum
 */
typedef enum EnvironmentalErrorEnum {
    ENVIORNMENT_ERROR_TOOCLSE = 0,              ///<过近<请稍微退后>
    ENVIORNMENT_ERROR_TOOFAR = 1,               ///<过远<请稍微靠近>
    ENVIORNMENT_ERROR_TOOBRIGHT = 2,            ///<过于明亮
    ENVIORNMENT_ERROR_TOODARK = 3,              ///<过于灰暗
    ENVIORNMENT_ERROR_TOOPARTIAL = 4,           ///<过于偏转<请稍微正对摄像头>
    ENVIORNMENT_ERROR_NOFACE = 5,               ///<没有人脸<请稍微正对摄像头>
    ENVIORNMENT_ERROR_FUZZY = 6,               ///<图片模糊值过高
    ENVIORNMENT_ERROR_MOVEMENT = 7,            ///<请保持相对静止
    ENVIORNMENT_ERROR_MULTIFACE = 8,           ///<多人存在
    ENVIORNMENT_ERROR_NORMAL = 9              ///<正常

} EnvironmentalErrorEnum;


/*!
 *  \enum PALivenessDetectionType
 *  \brief 检测类型选项
 */
typedef enum PALivenessDetectionType {
    DETECTION_TYPE_NONE = 0,                ///<初始状态
    DETECTION_TYPE_MOUTH = 1,               ///<张嘴
    DETECTION_TYPE_POS_YAW = 2             ///<左右转头

} PALivenessDetectionType;


/*!
 *  \enum PALivenessDetectionFailedType
 *  \brief 检测失败类型
 */

typedef enum PALivenessDetectionFailedType {
    DETECTION_FAILED_TYPE_ACTIONBLEND = 0,          ///<动作错误
    DETECTION_FAILED_TYPE_DiscontinuityAttack = 1,  ///非连续性攻击
    DETECTION_FAILED_TYPE_NOTVIDEO = 2,             ///<不是活体
    DETECTION_FAILED_TYPE_TIMEOUT = 3,               ///<超时
    DETECTION_FAILED_TYPE_Interrupt = 4,          ///<用户操作
    DETECTION_FAILED_TYPE_License = 5             ///<摄像头不允许操作
} PALivenessDetectionFailedType;


/*!
 *
 */
typedef enum PALivenessFrameType {
    FRAME_TYPE_EyeDetection = 0,                            ///<眼睛检测
    FRAME_TYPE_FaceDetection = 1                            ///<人脸检测
} PALivenessFrameType;

/** @defgroup DetectorOptionKeys 检测器配置选项
 *  用于配置检测器的选项列表
 *  @{
 */

/** 模型路径 */
extern NSString* const PALivenessDetectorModelPath;
/** 模型内容 */
extern NSString* const PAlivenessDetectorModelRawData;
/** 通信密钥 */
extern NSString* const PALivenessDetectorCipher;
/** 每个检测环节的超时时限，默认10 */
extern NSString* const PALivenessDetectorStepTimeLimit;
/** 质量判断－最小人脸大小 [100, 8192], 默认150 */
extern NSString* const PALivenessDetectorMinFaceSize;
/** 质量判断－最大水平角度偏差 [0.0, 1.0]，默认0.17 */
extern NSString* const PALivenessDetectorMaxYawAngle;
/** 质量判断－最大上下角度偏差 [0.0, 1.0]，默认0.17 */
extern NSString* const PALivenessDetectorMaxPitchAngle;
/** 质量判断－人脸亮度最小平均值 [0, 255]，默认80 */
extern NSString* const PALivenessDetectorMinBrightness;
/** 质量判断－人脸亮度最大平均值 [0, 255]，默认170 */
extern NSString* const PALivenessDetectorMaxBrightness;
/** 质量判断－运动模糊阈值 [0.0, 1.0]，默认0.1 */
extern NSString* const PALivenessDetectorMaxMotionBlurness;
/** 质量判断－高斯模糊阈值 [0.0, 1.0]，默认0.08 */
extern NSString* const PALivenessDetectorMaxGaussianBlurness;
/** 质量判断－眼睛睁闭阈值 [0.0, 1.0]，默认0.3 */
extern NSString* const PALivenessDetectorMaxEyeOpen;
/** 质量判断－嘴部开闭阈值 [0.0, 1.0]，默认0.4 */
extern NSString* const PALivenessDetectorMaxMouthOpen;
/** 质量判断－有效面积比 */
extern NSString* const PALivenessDetectorMinIntegrity;
/** 动作个数－活体过程中的动作个数 */
extern NSString *PALivenessDetectorNumberOfAction;

/*@}*/


#endif /* PALivenssEnumType_h */
