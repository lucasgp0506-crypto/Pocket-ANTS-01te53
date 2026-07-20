#include <substrate.h>

// 1. Guarda a função original do jogo
int (*old_GetSeeds)(void *instance);

// 2. Nossa modificação que força o valor alto de sementes
int new_GetSeeds(void *instance) {
    return 999999; 
}

// 3. O construtor que injeta a alteração na inicialização
__attribute__((constructor)) static void initialize() {
    // Esse número 0x123456 será substituído pelo código real do seu dump.cs
    MSHookFunction((void *)0x123456, (void *)&new_GetSeeds, (void **)&old_GetSeeds);
}
