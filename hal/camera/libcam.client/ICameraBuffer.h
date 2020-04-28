#ifndef _MTK_CAMERA_INC_COMMON_CAMUTILS_ICAMERABUFFER_H_
#define _MTK_CAMERA_INC_COMMON_CAMUTILS_ICAMERABUFFER_H_
//
#include <sys/types.h>
//
#include <utils/RefBase.h>
#include <utils/String8.h>
#if (PLATFORM_VERSION_MAJOR == 2)
#include <utils/RefBase.h>
#else
#include <utils/StrongPointer.h>
#endif
//
#include <hardware/camera.h>
//


/******************************************************************************
*
*******************************************************************************/


namespace android {
namespace MtkCamUtils {
/******************************************************************************
*
*******************************************************************************/
class IMemBuf;
class IImgBuf;


/******************************************************************************
*   Camera Buffer Interface.
*******************************************************************************/
class ICameraBuf : public virtual RefBase
{
public:     ////                    Attributes.
    virtual uint_t                  getBufIndex() const                     = 0;
    virtual camera_memory_t*        get_camera_memory()                     = 0;

public:     ////
    //
    virtual                         ~ICameraBuf() {};
};


/******************************************************************************
*   Camera Memory Buffer Interface.
*******************************************************************************/
class ICameraMemBuf : public IMemBuf, public ICameraBuf
{
};


/******************************************************************************
*   Camera Image Buffer Interface.
*******************************************************************************/
class ICameraImgBuf : public IImgBuf, public ICameraBuf
{
};


/******************************************************************************
*
*******************************************************************************/
};  // namespace MtkCamUtils
};  // namespace android
#endif  //_MTK_CAMERA_INC_COMMON_CAMUTILS_ICAMERABUFFER_H_

