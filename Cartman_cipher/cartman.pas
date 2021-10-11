(**      Cartman.PAS by Alexander Myasnikov                               **)
(**      Cartman Tiny block cipher for Delphi programmers                 **)
(**      Cartman encrypts 128 bit block with 512 bit key                  **)
(**      WEB:       www.darksoftware.narod.ru                             **)


Unit cartman;

{$Q-}
{$R-}


Interface

Type t128buf = array [0..3] Of longword;

Type p128buf = ^t128buf;

Procedure cartman_crypt(v: p128buf);
// Encrypt four 32 bit longwords

Procedure cartman_decrypt(v: p128buf);
// Decrypt four 32 bit longwords

Procedure cartman_setkey(k: pointer);
// Set 512 bit key (Pointer to 64 bytes or 16 longwords block)

Procedure cartman_killkey();
// Clear internal key (after encryption or decryption, just security hint)

Var key: array [0..15] Of longword;


Implementation


Function ror32(N, R:longword): longword;
asm
MOV EAX,N
MOV ECX, R
ROR EAX, CL
End;



Function rol32(N, R:longword): longword;
asm
MOV EAX,N
MOV ECX, R
ROL EAX,CL
End;






Procedure cartman_crypt(v: p128buf);

Var ki, k1, k2, k3, k4, mod1, mod2: longword;
  i: longint;


Begin

  For i:=0 To 127 Do
    Begin

      ki := i Mod 8;
      k1 := key [ki*2];
      k2 := key [ki*2+1];
      k3 := key [15-ki*2];
      k4 := key [15-ki*2+1];
      mod1 := k1 Mod 32;
      mod2 := k2 Mod 32;

      v[0]:= v[0] xor  (v[1]+v[2]) mod k1;
      v[1]:= v[1] xor  (v[2]+v[3]) mod k2;
      v[2]:= v[2] xor  (v[3]+v[0]) mod k1;
      v[3]:= v[3] xor  (v[0]+v[2]) mod k2;

      inc (v[0],  ROR32 (v[1] + k1, mod2));
      dec (v[0],  ROL32 (v[2] + k2, mod1));
      inc (v[0],  ROR32 (v[3] + k1, mod2));
      dec (v[1],  ROL32 (v[0] + k2, mod1));
      inc (v[1],  ROR32 (v[2] + k1, mod2));
      dec (v[1],  ROL32 (v[3] + k2, mod1));
      inc (v[2],  ROR32 (v[0] + k1, mod2));
      dec (v[2],  ROL32 (v[1] + k2, mod1));
      inc (v[2],  ROR32 (v[3] + k1, mod2));
      dec (v[3],  ROL32 (v[0] + k2, mod1));
      inc (v[3],  ROR32 (v[1] + k1, mod2));
      dec (v[3],  ROL32 (v[2] + k2, mod1));

      dec (v[0], (v[1] shl 6) xor (v[1] shr 9 ) + (v[1] xor k3 ) );
      inc (v[0], (v[2] shl 6) xor (v[2] shr 9 ) + (v[2] xor k4 ) );
      dec (v[0], (v[3] shl 6) xor (v[3] shr 9 ) + (v[3] xor k3 ) );
      inc (v[1], (v[0] shl 6) xor (v[0] shr 9 ) + (v[0] xor k4 ) );
      dec (v[1], (v[2] shl 6) xor (v[2] shr 9 ) + (v[2] xor k3 ) );
      inc (v[1], (v[3] shl 6) xor (v[3] shr 9 ) + (v[3] xor k4 ) );
      dec (v[2], (v[0] shl 6) xor (v[0] shr 9 ) + (v[0] xor k3 ) );
      inc (v[2], (v[1] shl 6) xor (v[1] shr 9 ) + (v[1] xor k4 ) );
      dec (v[2], (v[3] shl 6) xor (v[3] shr 9 ) + (v[3] xor k3 ) );
      inc (v[3], (v[0] shl 6) xor (v[0] shr 9 ) + (v[0] xor k4 ) );
      dec (v[3], (v[1] shl 6) xor (v[1] shr 9 ) + (v[1] xor k3 ) );
      inc (v[3], (v[2] shl 6) xor (v[2] shr 9 ) + (v[2] xor k4 ) );
    End;


End;


Procedure cartman_decrypt(v: p128buf);

Var ki, k1, k2, k3, k4, mod1, mod2: longword;
  i: longint;


Begin

  For i:=127 Downto 0 Do
    Begin

      ki := i Mod 8;
      k1 := key [ki*2];
      k2 := key [ki*2+1];
      k3 := key [15-ki*2];
      k4 := key [15-ki*2+1];
      mod1 := k1 Mod 32;
      mod2 := k2 Mod 32;


      dec (v[3], (v[2] shl 6) xor (v[2] shr 9 ) + (v[2] xor k4 ) );
      inc (v[3], (v[1] shl 6) xor (v[1] shr 9 ) + (v[1] xor k3 ) );
      dec (v[3], (v[0] shl 6) xor (v[0] shr 9 ) + (v[0] xor k4 ) );
      inc (v[2], (v[3] shl 6) xor (v[3] shr 9 ) + (v[3] xor k3 ) );
      dec (v[2], (v[1] shl 6) xor (v[1] shr 9 ) + (v[1] xor k4 ) );
      inc (v[2], (v[0] shl 6) xor (v[0] shr 9 ) + (v[0] xor k3 ) );
      dec (v[1], (v[3] shl 6) xor (v[3] shr 9 ) + (v[3] xor k4 ) );
      inc (v[1], (v[2] shl 6) xor (v[2] shr 9 ) + (v[2] xor k3 ) );
      dec (v[1], (v[0] shl 6) xor (v[0] shr 9 ) + (v[0] xor k4 ) );
      inc (v[0], (v[3] shl 6) xor (v[3] shr 9 ) + (v[3] xor k3 ) );
      dec (v[0], (v[2] shl 6) xor (v[2] shr 9 ) + (v[2] xor k4 ) );
      inc (v[0], (v[1] shl 6) xor (v[1] shr 9 ) + (v[1] xor k3 ) );

      inc (v[3],  ROL32 (v[2] + k2, mod1));
      dec (v[3],  ROR32 (v[1] + k1, mod2));
      inc (v[3],  ROL32 (v[0] + k2, mod1));
      dec (v[2],  ROR32 (v[3] + k1, mod2));
      inc (v[2],  ROL32 (v[1] + k2, mod1));
      dec (v[2],  ROR32 (v[0] + k1, mod2));
      inc (v[1],  ROL32 (v[3] + k2, mod1));
      dec (v[1],  ROR32 (v[2] + k1, mod2));
      inc (v[1],  ROL32 (v[0] + k2, mod1));
      dec (v[0],  ROR32 (v[3] + k1, mod2));
      inc (v[0],  ROL32 (v[2] + k2, mod1));
      dec (v[0],  ROR32 (v[1] + k1, mod2));

      v[3]:= v[3] xor  (v[0]+v[2]) mod k2;
      v[2]:= v[2] xor  (v[3]+v[0]) mod k1;
      v[1]:= v[1] xor  (v[2]+v[3]) mod k2;
      v[0]:= v[0] xor  (v[1]+v[2]) mod k1;

    End;
End;




Procedure cartman_setkey(k: pointer);
Begin
  move(k^,key,64);
End;


Procedure cartman_killkey();
Begin
  fillchar(key, 64, 0);
  fillchar(key, 64, $FF);
End;


End.
