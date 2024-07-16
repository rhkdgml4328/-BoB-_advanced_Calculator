%{
#include <stdio.h> /*include*/
%}

%%
stop printf("print : Stop\n");   /*stop이 입력되면 printf("print : Stop\n"); 실행*/
start printf("print : Start\n"); /*start가 입력되면 printf("print : Start\n"); 실행*/
%%
