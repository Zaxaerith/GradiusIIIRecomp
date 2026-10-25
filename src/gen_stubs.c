#include <stdio.h>
#include "cpu_state.h"
#include "common_cpu_infra.h"

/*
 * HleWaitVBlank - Reimplementation of $00:86CD.
 * Gradius III screen transition VBLANK handshake.
 */
RecompReturn HleWaitVBlank(CpuState *cpu) {
    static int count = 0;
    count++;
    if (count <= 10 || (count % 60) == 0) {
        fprintf(stderr, "[HleWaitVBlank] called (count=%d, S=%04X, 1E82=%02X, master=%llu)\n",
                count, cpu->S, cpu_read8(cpu, 0x00, 0x1E82), (unsigned long long)cpu->master_cycles);
    }
    uint8 p = cpu->P;
    uint8 v1e82 = cpu_read8(cpu, 0x00, 0x1E82);
    if ((v1e82 & 0x80) != 0) {
        cpu_write8(cpu, 0x00, 0x003C, 0x01);
        cpu_write8(cpu, 0x00, 0x2100, 0x8F);
        cpu_write8(cpu, 0x00, 0x003E, 0x04);
        cpu_write8(cpu, 0x00, 0x420C, 0x00);
        cpu_write8(cpu, 0x00, 0x420B, 0x00);
    } else {
        cpu_write8(cpu, 0x00, 0x003E, 0x04);
        cpu_write8(cpu, 0x00, 0x420C, 0x00);
        cpu_write8(cpu, 0x00, 0x420B, 0x00);
    }
    cpu->P = p;
    cpu_p_to_mirrors(cpu);
    cpu->S = (uint16)(cpu->S + 3);
    return RECOMP_RETURN_NORMAL;
}
