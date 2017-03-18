#include <stdint.h>


   





extern "C" {
// int _ZN7android16MediaBufferGroupC1Em(unsigned long);
int _ZN7android16MediaBufferGroupC1Ej();
int _ZN7android16MediaBufferGroupC1Ev() {
    // return _ZN7android16MediaBufferGroupC1Em(0);
    return _ZN7android16MediaBufferGroupC1Ej();
}
void _ZN7android14SurfaceControl8setLayerEj(uint32_t);

void _ZN7android14SurfaceControl8setLayerEi(int32_t layer){
        _ZN7android14SurfaceControl8setLayerEj(static_cast<uint32_t>(layer));
    }

}
