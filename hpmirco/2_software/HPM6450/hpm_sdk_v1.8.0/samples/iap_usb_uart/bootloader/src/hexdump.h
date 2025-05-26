#ifndef __HEXDUMP_H__
#define __HEXDUMP_H__

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#ifndef nullptr
#define nullptr (void*)0
#endif

#define HEXDUMP1(buff, size) hexdump(buff, size, 16, 1, true, nullptr, (uint32_t)(buff));
#define HEXDUMP2(buff, size) hexdump(buff, size, 16, 2, true, nullptr, (uint32_t)(buff));
#define HEXDUMP4(buff, size) hexdump(buff, size, 16, 4, true, nullptr, (uint32_t)(buff));
#define HEXDUMP8(buff, size) hexdump(buff, size, 16, 8, true, nullptr, (uint32_t)(buff));

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

bool hexdump(const uint8_t* cpu8Buffer, uint32_t u32BytesDumped, uint8_t u8BytesPerLine, uint8_t u8BytesOncePrint, bool bShowAscii, const char* szPrefixFormat, uint32_t u32ShownStartingAddress);

#ifdef __cplusplus
}
#endif

#endif
