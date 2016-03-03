#if CVNWARE
#include "cvnware.h"
#endif

#if MTK
#include "nvram.h"
#endif

#include "profile.h"
#include "hb_core.h"
#include "net.h"


struct echo_thread {
	pthread_t echo_thpid;
	int pause_flag;
};


struct recv_thread {
	pthread_t recv_thpid;
	int pause_flag;
	int flush_flag;
};

struct dispatch_thread {
	pthread_t dispatch_thpid;
	int terminal_flag;
};

struct glob_arg {
	/*command*/
	char* configFile;
	int debuglevel;
	int log_syslog;
	//struct in_addr beforeserverip;
	
	/*hbrc*/
	struct heartbeat_route_client *hbrc;

	
	/*thread*/
	struct echo_thread echoThread;
	struct recv_thread recvThread;
	struct dispatch_thread dispatchThread;
};

#define DEFAULT_CONFIG_PATH "./hb_client.conf"

//static int init_hbrc(struct heartbeat_route_client *hbrc);
static struct hb_server* get_hbs();



