#include <asm-generic/errno.h>
#include <czmq.h>
#include <netdb.h>
#include <sched.h>
#include <stdio.h>
#include <string.h>
#include <zsock.h>
#include <zstr.h>

int main(void) {

    zsock_t *req = zsock_new_req("tcp://127.0.0.1:5000");

    if (req == NULL){
        printf("Ошибка создания");
        return -1;
    }

    for (int i = 1; i <= 10; i++){
        int check_send = zstr_send(req, "Hello, REP");
        if (check_send == -1){
            printf("Ошибка отправки");
            return -1;
        }

        char *rep = zstr_recv(req);
        if (!rep){
            printf("Ошибка получения / пустое сообщение");
        }
        else{
            printf("Получено сообщение: %s\n", rep);
            zstr_free(&rep);
        }
        
    }

    

    zsock_destroy(&req);


    return 0;
}
