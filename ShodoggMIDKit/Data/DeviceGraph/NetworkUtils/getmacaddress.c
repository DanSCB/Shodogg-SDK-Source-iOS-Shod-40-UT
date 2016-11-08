//
//  getmacaddress.c
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/1/16.
//
//

#include "getmacaddress.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/param.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netinet/in.h>
#include <if_types.h>
#include <route.h>
#include <if_ether.h>
#include <if_arp.h>
#include <err.h>
#include <errno.h>
#include <netdb.h>
#include <nlist.h>
#include <paths.h>
#include <unistd.h>

static int nflag;
u_char * getmacaddress(in_addr_t addr)
{
    u_char *cp = "";
    int expire_time, flags, export_only, doing_proxy, found_entry;
    int mib[6];
    size_t needed;
    char *host, *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    struct hostent *hp;
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
        if ((buf = malloc(needed)) == NULL)
            err(1, "malloc");
            if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
                err(1, "actual retrieval of routing table");

                lim = buf + needed;
                for (next = buf; next < lim; next += rtm->rtm_msglen) {
                    rtm = (struct rt_msghdr *)next;
                    sin = (struct sockaddr_inarp *)(rtm + 1);
                    sdl = (struct sockaddr_dl *)(sin + 1);
                    if (addr) {
                        if (addr != sin->sin_addr.s_addr) {
                            continue;
                        }
                        found_entry = 1;
                    }
                    
                    if (nflag == 0) {
                        hp = gethostbyaddr((caddr_t)&(sin->sin_addr), sizeof sin->sin_addr, AF_INET);
                    } else {
                        hp = 0;
                    }
                    
                    if (hp) {
                        host = hp->h_name;
                    } else {
                        host = "?";
                        if (h_errno == TRY_AGAIN) {
                            nflag = 1;
                        }
                    }
                    if (sdl->sdl_alen) {
                        cp = LLADDR(sdl);
                    }
                }
    
    if (found_entry == 0) {
        return "";
    } else {
        return cp;
    }
}

//////////////
// CREDIT: http://stackoverflow.com/questions/10395041/getting-arp-table-on-iphone-ipad
///////////////////////////////////////////////////////////////////////////////////////