#include <substrate.h>

// 1. Criamos o ponteiro para preservar a estrutura de memória original
void (*old_MoveNext)(void *instance);

// 2. Criamos a nossa interceptação de função (A Burla)
void new_MoveNext(void *instance) {
    // Primeiro executamos a lógica nativa do jogo para evitar travamentos
    old_MoveNext(instance);
    
    // Tentamos forçar a gravação local da variável 'seed' no offset mapeado (0x40)
    // Nota: Em estruturas de ponteiros C++, acessamos o endereço base + o deslocamento da variável
    if (instance != nullptr) {
        *((int *)((uintptr_t)instance + 0x40)) = 999999;
    }
}

// 3. O construtor que injeta o desvio no momento em que o app é inicializado
__attribute__((constructor)) static void initialize() {
    // Vinculamos o gatilho ao Offset Real encontrado no dump (0x282AAE8)
    MSHookFunction((void *)0x282AAE8, (void *)&new_MoveNext, (void **)&old_MoveNext);
}
