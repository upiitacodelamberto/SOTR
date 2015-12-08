
#include <sys/types.h>
#include <sys/stat.h>
#include <termios.h>
#include <fcntl.h>
#include <sys/ioctl.h>
//#include <unistd.h>
#include <stdio.h>

int main (void)
{

int fd, serial,x;
int nbyte = 1;
char *bufer1;
char *bufer2;
const char *device = "/dev/ttyUSB0";

bufer1 = 'C';
//bufer2 = 'h';
printf("Esto fue lo que se manda=%c   %d\n",bufer1, bufer1);

/*Configurando del puerto serial*/
struct termios options;
	/*open the port*/
fd = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
if (fd == -1) 
	puts("failed to open\n");
fcntl(fd,F_SETFL,0);
	/*get the current options*/
tcgetattr(fd,&options);
cfsetispeed(&options,B9600);
cfsetospeed(&options,B9600);
	/*Set raw input, 1 sec timeout...*/
	options.c_cflag |= (CLOCAL | CREAD);
	options.c_cflag &=~PARENB;
	options.c_cflag &=~CSTOPB;
	options.c_cflag &=~CSIZE;
	options.c_cflag |= CS8;
	options.c_lflag &=~(ICANON | ECHO | ECHOE | ISIG);
	options.c_iflag &=~(IXON | IXOFF | IXANY);
	options.c_oflag &=~OPOST;
	options.c_cc[VMIN] = 0;   // (con 0 leerá un caracter) leera 11 caracteres
	options.c_cc[VTIME]= 20;  // esperará 2 seg por el primer caracter

	/*Set the options*/
tcsetattr(fd,TCSANOW,&options);

//bufer1 = 255;
 for (x=0;x<=10;x++)
	{
	printf("%d ",x);
	scanf("%d",&bufer1);
	if (write(fd,&bufer1,1)==-1)
		{
		 perror("write");
		return(0);
		}
	read(fd,&bufer2,1);
	printf("Esto fue lo que recibió = %d \n", bufer2);
	}
//printf("Ahora voy a esperar 3 seg para leer\n");

//read(fd,&bufer2,11);
/*for (x=0;x<=10;x++)
	{
	printf("Esto fue lo que recibió=%d %d\n",x, bufer2[x]);
	}
*/
//ioctl(fd,TIOCMGET, &serial);

//if (serial & TIOCM_DTR)
//	puts("TIOCM_DTR is not set");
//else
//	puts("TIOCM_DTR is set");
//nbyte = read(fd,bufer,sizeof(bufer));
//if (nbyte<1)
//	printf("No hay dato = %d\n",bufer);
//else
//	printf("El leido dato es\n",bufer);

close(fd);

}
