# [BoB]_advanced_Calculator

##Flex(lex) \ example1.l
---

        %{
        #include <stdio.h> /*include*/
        %}
        
        %%
        stop printf("print : Stop\n");   /*stop이 입력되면 printf("print : Stop\n"); 실행*/
        start printf("print : Start\n"); /*start가 입력되면 printf("print : Start\n"); 실행*/
        %%
        
---
위의 문법은 lex에서 사용되는 문법 실제로 사용하기 위해 C가 인식할 수 있도록 문법 변경을 해야함
-> lex가 담당. 일종의 선처리기

flex example1.l
gcc lex.yy.c -o example1 -lfl

정규표현을 이용한 매칭 \ example1.l
---

        #{
        #include <stdio.h>
        %}
        %%
        [0123456789]+        printf("NUMBER\n");
        [a-zA-Z][a-zA-Z0-9]+ printf("WORD\n");
        %%
        
---
Lex는 임의의 입력을 받아들여 각각의 의미를 결정할 수 있음 -> 'TOKENIZING'

##Bison (YACC)
Lex에 의해서 얻어진 token들의 관계를 구성하는 "구문분석기"를 생성하는 툴

Bison을 이해하기 위한 간단한 예제
온도 조절기
---

        heat on
                Heater on !
        heat off
                Heater off !
        target temperature 22
                New temperature set !
                
---
