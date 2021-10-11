/*      Cartman.C by Alexander Myasnikov                               **/
/*      Cartman Tiny block cipher for Delphi programmers                 **/
/*      Cartman encrypts 128 bit block with 512 bit key                  **/
/*      WEB:       www.darksoftware.narod.ru                             **/


#include <string.h>
#include <stdlib.h>


#define u32 unsigned long

#define ROR32(x, n)  _lrotr(x,n)
#define ROL32(x, n)  _lrotl(x,n)

u32 key[16]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};


void __stdcall __export crypt (u32 *v)
{
u32 ki, k1, k2, k3, k4, mod1, mod2;
long i;


  for (i=0; i<=127;i++)
{

      ki = i%8;
      k1 = key [ki*2];
      k2 = key [ki*2+1];
      k3 = key [15-ki*2];
      k4 = key [15-ki*2+1];
      mod1 = k1%32;
      mod2 = k2%32;


      v[0]^=  (v[1]+v[2]) % k1;
      v[1]^=  (v[2]+v[3]) % k2;
      v[2]^=  (v[3]+v[0]) % k1;
      v[3]^=  (v[0]+v[2]) % k2;



      v[0]+=  ROR32 (v[1] + k1, mod2);
      v[0]-=  ROL32 (v[2] + k2, mod1);
      v[0]+=  ROR32 (v[3] + k1, mod2);
      v[1]-=  ROL32 (v[0] + k2, mod1);
      v[1]+=  ROR32 (v[2] + k1, mod2);
      v[1]-=  ROL32 (v[3] + k2, mod1);
      v[2]+=  ROR32 (v[0] + k1, mod2);
      v[2]-=  ROL32 (v[1] + k2, mod1);
      v[2]+=  ROR32 (v[3] + k1, mod2);
      v[3]-=  ROL32 (v[0] + k2, mod1);
      v[3]+=  ROR32 (v[1] + k1, mod2);
      v[3]-=  ROL32 (v[2] + k2, mod1);

      v[0]+= ((v[1] << 6) ^ (v[1] >> 9 ) + (v[1] ^ k4 ));
      v[0]-= ((v[2] << 6) ^ (v[2] >> 9 ) + (v[2] ^ k3 ));
      v[0]+= ((v[3] << 6) ^ (v[3] >> 9 ) + (v[3] ^ k4 ));
      v[1]-= ((v[0] << 6) ^ (v[0] >> 9 ) + (v[0] ^ k3 ));
      v[1]+= ((v[2] << 6) ^ (v[2] >> 9 ) + (v[2] ^ k4 ));
      v[1]-= ((v[3] << 6) ^ (v[3] >> 9 ) + (v[3] ^ k3 ));
      v[2]+= ((v[0] << 6) ^ (v[0] >> 9 ) + (v[0] ^ k4 ));
      v[2]-= ((v[1] << 6) ^ (v[1] >> 9 ) + (v[1] ^ k3 ));
      v[2]+= ((v[3] << 6) ^ (v[3] >> 9 ) + (v[3] ^ k4 ));
      v[3]-= ((v[0] << 6) ^ (v[0] >> 9 ) + (v[0] ^ k3 ));
      v[3]+= ((v[1] << 6) ^ (v[1] >> 9 ) + (v[1] ^ k4 ));
      v[3]-= ((v[2] << 6) ^ (v[2] >> 9 ) + (v[2] ^ k3 ));

  

}

 
}


void __stdcall __export  decrypt (u32 *v)
{

u32  ki, k1, k2, k3, k4, mod1, mod2;
long i;


  for (i=127; i>=0;i--)
{

      ki = i%8;
      k1 = key [ki*2];
      k2 = key [ki*2+1];
      k3 = key [15-ki*2];
      k4 = key [15-ki*2+1];
      mod1 = k1%32;
      mod2 = k2%32;


//////

      v[3]+= ((v[2] << 6) ^ (v[2] >> 9 ) + (v[2] ^ k3 ));
      v[3]-= ((v[1] << 6) ^ (v[1] >> 9 ) + (v[1] ^ k4 ));
      v[3]+= ((v[0] << 6) ^ (v[0] >> 9 ) + (v[0] ^ k3 ));
      v[2]-= ((v[3] << 6) ^ (v[3] >> 9 ) + (v[3] ^ k4 ));
      v[2]+= ((v[1] << 6) ^ (v[1] >> 9 ) + (v[1] ^ k3 ));
      v[2]-= ((v[0] << 6) ^ (v[0] >> 9 ) + (v[0] ^ k4 ));
      v[1]+= ((v[3] << 6) ^ (v[3] >> 9 ) + (v[3] ^ k3 ));
      v[1]-= ((v[2] << 6) ^ (v[2] >> 9 ) + (v[2] ^ k4 )) ;
      v[1]+= ((v[0] << 6) ^ (v[0] >> 9 ) + (v[0] ^ k3 )) ;
      v[0]-= ((v[3] << 6) ^ (v[3] >> 9 ) + (v[3] ^ k4 )) ;
      v[0]+= ((v[2] << 6) ^ (v[2] >> 9 ) + (v[2] ^ k3 )) ;  
      v[0]-= ((v[1] << 6) ^ (v[1] >> 9 ) + (v[1] ^ k4 )) ;


      v[3]+=  ROL32 (v[2] + k2, mod1);
      v[3]-=  ROR32 (v[1] + k1, mod2);
      v[3]+=  ROL32 (v[0] + k2, mod1);
      v[2]-=  ROR32 (v[3] + k1, mod2);
      v[2]+=  ROL32 (v[1] + k2, mod1);
      v[2]-=  ROR32 (v[0] + k1, mod2);
      v[1]+=  ROL32 (v[3] + k2, mod1);
      v[1]-=  ROR32 (v[2] + k1, mod2);
      v[1]+=  ROL32 (v[0] + k2, mod1);
      v[0]-=  ROR32 (v[3] + k1, mod2);
      v[0]+=  ROL32 (v[2] + k2, mod1);
      v[0]-=  ROR32 (v[1] + k1, mod2);

      v[3]^=  (v[0]+v[2]) % k2;
      v[2]^=  (v[3]+v[0]) % k1;
      v[1]^=  (v[2]+v[3]) % k2;
      v[0]^=  (v[1]+v[2]) % k1;


    
}


}




void __stdcall __export setup (u32 *data)
{
 memmove(&key[0],&data[0], 64);
}


void __stdcall __export cartman_killkey()
{
  memset(key, 0, 64);
  memset(key, 0, 0xFF);
}



