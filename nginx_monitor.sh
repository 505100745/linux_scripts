#!/bin/bash
NGINX_STATUS=$1
URL="http://127.0.0.1:80/nginx_status"
CACHEFILE="/tmp/nginx_status.txt"
CMD="/usr/bin/cur ${URL}" 

if [ ! -f ${CACHEFILE} ];then
   ${CMD} >${CACHEFILE} > /dev/null 2>&1
fi
 
#Check and run the scripe
TIMEFLM=$(stat -c %Y $CACHEFILE)
TIMENOW=$(date +%s)

if [ $(expr ${TIMENOW} - ${TIMEFLM}) -gt 0 ];then
   rm -f ${CACHEFILE}
fi
if [ ! -f ${CACHEFILE} ];then
    ${CMD} >${CACHEFILE} > /dev/null 2>&1
fi

nginx_ping(){
      /sbin/pidof nginx | wc -l
}

nginx_active(){
      grep 'Active' ${CACHEFILE}|awk '{print ${NF}}'
      exit 0;
}

nginx_reading(){
      grep 'Reading' ${CACHEFILE}|awk '{print ${NF}}'
      exit 0;
}

nginx_writing(){
      grep 'Writing' ${CACHEFILE}|awk '{print ${NF}}'
      exit 0;
}

nginx_waiting(){
      grep 'Waiting' ${CACHEFILE}|awk '{print ${NF}}'
      exit 0;
}

nginx_accepts(){
      awk NR==3 ${CACHEFILE} | awk '{print $1}'
      exit 0;
}

nginx_handled(){
      awk NR==3 ${CACHEFILE} | awk '{print $2}'
      exit 0;
}

nginx_requests(){
      awk NR==3 ${CACHEFILE} | awk '{print $3}'
      exit 0;
}

case ${NGINX_STATUS} in
	        ping)
  	        nginx_ping
		;;
        	active)
   	        nginx_active
 		;;
       		reading)
  		nginx_reading
		;;
        	writing)     
  		nginx_wtiting
		;;
        	waiting)
   		nginx_waiting
		;;
        	accepts)
   		nginx_accepts
		;;
        	handled)
   		nginx_handled
		;; 
       		requests)
  		nginx_requests
		;;
                *)
		echo "Invalid argument"
		exit 2;
esac
