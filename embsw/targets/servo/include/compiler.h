#ifndef __COMPILER_H__
#define __COMPILER_H__

#include "projconf.h"

#ifndef __ATTR_RAM_FUNC
#define __ATTR_RAM_FUNC
#endif

#ifndef __ATTR_SHARE_MEM
#define __ATTR_SHARE_MEM
#endif

#ifndef __ATTR_PACKED
#define __ATTR_PACKED(x) __packed x
#endif

#ifndef __ATTR_ALIGNED
#define __ATTR_ALIGNED(x) x
#endif

#endif  // !__COMPILER_H__
