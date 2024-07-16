# [BoB]_advanced_Calculator
---

## Flex(lex) \ example1.l


        %{
        #include <stdio.h> /*include*/
        %}
        
        %%
        stop printf("print : Stop\n");   /*stop이 입력되면 printf("print : Stop\n"); 실행*/
        start printf("print : Start\n"); /*start가 입력되면 printf("print : Start\n"); 실행*/
        %%
        

위의 문법은 lex에서 사용되는 문법 실제로 사용하기 위해 C가 인식할 수 있도록 문법 변경을 해야함
-> lex가 담당. 일종의 선처리기


컴파일 방법

        flex example1.l
        gcc lex.yy.c -o example1 -lfl


#### 정규표현을 이용한 매칭 \ example1.l


        #{
        #include <stdio.h>
        %}
        %%
        [0123456789]+        printf("NUMBER\n");
        [a-zA-Z][a-zA-Z0-9]+ printf("WORD\n");
        %%
        

Lex는 임의의 입력을 받아들여 각각의 의미를 결정할 수 있음 -> 'TOKENIZING'

---
## Bison (YACC)
Lex에 의해서 얻어진 token들의 관계를 구성하는 "구문분석기"를 생성하는 툴

#### Bison을 이해하기 위한 간단한 예제 (온도조절기)


        heat on
                Heater on !
        heat off
                Heater off !
        target temperature 22
                New temperature set !
                
위에서 얻을 수 있는 token은 heat, on/off(상태), target, temperature, 숫자(온도)

위의 텍스트에서 토큰을 얻을 수 있는 lex 파일 만들기

#### example4.l
        
        %{
        #include <stdio.h>
        #include "example4.tab.h"
        %}
        
        %%
        [0-9]+                  { return NUMBER; }
        heat                    { return TOKHEAT; }
        on|off                  { return STATE; }
        target                  { return TOKTARGET; }
        temperature             { return TOKTEMPERATURE; }
        \n                      { /* ignore end of line */; }
        [ \t]+                  { /* ignore whitespace */; }
        .                       { /* any other character */; }
        %%



bison코드는 크게 3가지 부분으로 이루어짐


        ... 정의(definitions) ...
        %%
        ... 규칙(rules) ...
        %%
        ... 함수들(subroutines) ...

정의 부분에서는 토큰과 각종 상수 선언 + (%{c코드%})

규칙 부분에서는 BNF 문법

함수 부분에 사용자 정의 함수 추가 가능

example4.y

        %{
        #include <stdio.h>
        #include <string.h>
        
        void yyerror(const char *str)
        {
            fprintf(stderr, "error: %s\n", str);
        }
        
        int yywrap()
        {
            return 1;
        }
        
        int main()
        {
            yyparse();
            return 0;
        }
        %}
        
        %token NUMBER TOKHEAT STATE TOKTARGET TOKTEMPERATURE
        
        %%
        commands: /* empty */
                | commands command
                ;
        
        command:
                heat_switch
                |
                target_set
                ;
        
        heat_switch:
                TOKHEAT STATE
                {
                        printf("\tHeat turned on or off\n");
                }
                ;
        
        target_set:
                TOKTARGET TOKTEMPERATURE NUMBER
                {
                        printf("\tTemperature set\n");
                }
                ;
        %%


컴파일 방법

        flex example4.l
        bison -d example4.y
        gcc lex.yy.c example4.tab.c -o example4

## 온도조절 프로그램의 업그레이드

Flex는 매칭된 단어의 문자열을 'yytex'라는 변수에 저장
또한 'yylval`에 리턴값을 되돌려줄 수도 있음

example5.l

        %{
        #include <stdio.h>
        #include "example5.tab.h"
        %}
        %%
        [0-9]+                  yylval=atoi(yytext); return NUMBER;
        heat                    return TOKHEAT;
        on|off                  yylval=!strcmp(yytext,"on"); return STATE;
        target                  return TOKTARGET;
        temperature             return TOKTEMPERATURE;
        \n                      /* ignore end of line */;
        [ \t]+                  /* ignore whitespace */;
        %%

example4.y의 내용을 수정하여 example5.y 작성

        heat_switch:
            TOKHEAT STATE
            {
                if($2)
                    printf("\tHeat turned on\n");
                else
                    printf("\tHeat turned off\n");
            }
            ;
        
        target_set:
            TOKTARGET TOKTEMPERATURE NUMBER
            {
                printf("\tTemperature set %d\n", $3);
            }
            ;

컴파일 방법

        flex example5.l
        bison -d example5.y
        gcc lex.yy.c example5.tab.c -o example5



Flex and Bison Howto
참고 자료 : https://blog.naver.com/imisehi/150022426836
  
