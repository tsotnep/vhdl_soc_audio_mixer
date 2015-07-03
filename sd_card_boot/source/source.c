#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>

#define MESSLEN 48000 * 17

FILE *logfile;
char buffer[MESSLEN + 1];

int c;

void handler(union sigval sv)
{
   (void) sv;
   FILE* fp;
   float t;

   clock_t start,end; 

   start = clock();

   c++;
   fp = fopen("/proc/superip_frame", "r");
  
   fread((void *)buffer, sizeof(char), MESSLEN, fp);
   buffer[MESSLEN] = '\0';

   fwrite((void *)buffer, sizeof(char), MESSLEN, stdout);  
   fflush(stdout);

   fclose(fp);


   end = clock();
   t = (float)(end - start) / CLOCKS_PER_SEC;

   fprintf(logfile, "handler execution time: %f\n", t);
   fflush(logfile);

   return;
}


int main()
{
  
   timer_t tid;
   union sigval sv;
   struct sigevent se;
   struct itimerspec its;

   sv.sival_int = 0;

   se.sigev_value = sv;
   se.sigev_notify = SIGEV_THREAD;
   se.sigev_notify_function = handler;
   se.sigev_notify_attributes = NULL;

   if(timer_create(CLOCK_MONOTONIC, &se, &tid))
   {
      printf("error creating the timer\n");
      return 1;
   }
  
   its.it_interval.tv_sec = 1;
   its.it_interval.tv_nsec = 0;
   its.it_value.tv_sec = 1;
   its.it_value.tv_nsec = 0;

   c = 0;
   logfile = fopen("LOG", "a");

   if(timer_settime(tid, 0, &its, NULL))
   {
      printf("error arming the timer\n");
      return 2;
   }

   while(1)
      sleep(4);

   //printf("count: %d\n", c);

   return 0;
}
