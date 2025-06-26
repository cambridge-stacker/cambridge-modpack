local GameMode = require 'tetris.modes.gamemode'

local FlashPointViewer = GameMode:extend()

FlashPointViewer.name = "FP Board Viewer"
FlashPointViewer.hash = "FPViewer"
FlashPointViewer.tagline = "See all of Flash Point's boards!"
FlashPointViewer.tags = {"Puzzle"}

local board_str = [[
          
          
          
          
          
          
          
          
    CC    
    ZZ    
    ZZ    
   SSSS   
   SSSS   
   SSSS   
  TTTTTT  
  TTTTTT  
  TTTTTT  
 OOOOOOOO 
 OOOOOOOO 
 OOOOOOOO 
          
          
          
          
          
          
          
          
          
          
          
Z  Z  Z  Z
Z  Z  Z  Z
Z  Z  Z  Z
Z  Z  C  Z
Z  Z  Z  Z
Z  Z  Z  Z
Z  Z  Z  Z
Z  Z  Z  Z
Z  Z  Z  Z
          
          
          
          
          
          
          
          
          
          
          
   LLLLL  
     C L  
       L  
       L  
   LLLLL  
       L  
       L  
       L  
   LLLLL  
          
          
          
          
          
          
          
          
          
          
          
C        Z
        ZZ
       ZZZ
      ZZZZ
     ZZZZZ
    ZZZZZZ
   ZZZZZZZ
  ZZZZZZZZ
 ZZZZZZZZZ
          
          
          
          
          
          
    SS    
    SS    
    CC    
    SS    
    SS    
    SS    
          
          
    LL    
    LL    
    CC    
    LL    
    LL    
    LL    
          
          
          
          
          
          
          
          
          
          
          
SSSSSSSS  
          
SSSS  SS  
          
  SS  SS  
          
CSSS  SS  
          
SSSSSSSS  
          
          
          
          
          
          
          
          
          
          
          
         C
L        L
L        L
LL      LL
LL      LL
LLL    LLL
LLL    LLL
LLLL  LLLL
LLLL  LLLL
          
          
          
          
          
          
          
          
          
          
          
          
          
          
   JJJJ   
   J  J   
   JC J   
   JJJJ   
          
          
          
          
          
          
          
          
          
          
          
          
          
          
   SSSSSSS
          
          
SSSSSSS   
          
  C       
          
          
          
          
          
          
          
          
          
    OO    
    OO    
   OOOO   
   OOOO   
  OOOOOO  
  OOOOOO  
   OOOO   
   OOOO   
    OO    
    CO    
          
          
          
          
          
          
          
          
          
          
          
          
          
          
   TTTT   
      T   
      T   
      T   
   TTTT   
   T C    
   T      
   T      
   TTTT   
          
          
          
          
          
          
          
          
          
          
          
ZZ      ZZ
          
          
ZZZZ  ZZZZ
          
          
ZZ   C  ZZ
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
T        T
 T      T 
  T    T  
   T  C   
    TT    
          
          
          
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   C  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
   I  L   
          
          
          
          
          
          
          
          
   IIII   
    II    
    II    
I   II   I
    II    
    II    
   IIII   
   CII    
    II    
I   II   I
    II    
    II    
          
          
          
          
          
          
          
          
          
          
          
          
          
    Z Z   
   Z Z Z  
     C Z  
       Z  
       Z  
   ZZZZZ  
   Z      
          
          
          
          
   OOOO   
   OOOO   
   OOOO   
   OOOO   
   OOOO   
   OOOO   
          
    C     
   OOOO   
   OOOO   
   OOOO   
   OOOO   
   OOOO   
   OOOO   
          
          
          
          
          
          
          
          
          
          
          
          
          
          
    SS    
  SS  SS  
SS      SS
  SS  SS  
    SS    
          
          
    C     
          
          
          
C         
Z        Z
Z        Z
Z        Z
Z        Z
ZZ      ZZ
ZZ      ZZ
ZZ      ZZ
ZZ      ZZ
ZZZ    ZZZ
ZZZ    ZZZ
ZZZ    ZZZ
ZZZ    ZZZ
ZZZZ  ZZZZ
ZZZZ  ZZZZ
ZZZZ  ZZZZ
ZZZZ  ZZZZ
          
          
          
          
          
          
          
          
          
          
          
          
  ZZ   Z  
  Z Z  Z  
  Z  Z Z  
  Z   ZZ  
  Z    Z  
          
    C     
          
          
          
          
          
   ZZZZ   
   Z      
   Z      
   Z      
ZZZZ      
          
          
          
          
   ZZZZ   
      Z   
      Z   
      ZZZZ
        C 
          
          
          
          
          
          
          
          
          
          
          
     L    
    LLL   
   LLLLL  
          
          
    L     
   LLL    
  LLLLL   
    C     
          
          
          
          
          
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  C  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
Z  S  T  O
          
          
          
          
    IIIIII
          
          
          
IIIIII    
          
          
          
    IIIIII
          
          
          
IIICII    
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
 IIIIIIII 
I IIIIII I
II IIII II
III II III
IIII  IIIC
          
Z        Z
          
          
ZZ      ZZ
          
          
ZZZ    ZZZ
          
          
ZZZZ  ZZZZ
          
          
ZZZ    ZZZ
          
          
ZZ      ZZ
    C     
          
Z        Z
          
          
          
          
ZZZZZZZZ  
ZZZZZZZ   
ZZZZZZ    
ZZZZZ     
ZZZZ      
ZZZ       
ZZ        
Z         
C         
ZZ        
ZZZ       
ZZZZ      
ZZZZZ     
ZZZZZZ    
ZZZZZZZ   
ZZZZZZZZ  
          
          
          
          
          
          
     I    
    III   
   IIIII  
    III   
     I    
          
          
    I     
   III    
  IIIII   
   III    
    C     
          
          
          
          
          
          
          
          
          
          
          
 SSSSSSSS 
SSSS SSSSS
SSSSSSS S 
SSSSSSS S 
          
        S 
        S 
SS SSSSSSS
SS SSSSSSS
SS SSSSSSS
SS SSCSSSS
          
          
          
          
   JJJJ   
   J      
   J      
   J      
   JJJJ   
      J   
      J   
      J   
   JJJJ   
   J      
   J      
   J      
   JJJJ   
    C J   
      J   
      J   
          
          
          
          
          
          
          
          
          
          
          
          
IIII  IIII
III    III
II      II
I        I
I   C    I
II      II
III    III
IIII  IIII
          
          
          
          
          
          
          
          
          
          
          
          
  SSSSSS  
    SS    
   S  S   
  S    S  
     C    
          
          
          
          
          
          
          
          
          
          
          
          
          
          
ZZZZZZZZZ 
SSSSSSSS  
TTTTTTT   
OOOOOO    
IIIII     
LLLL      
JJJ       
ZZ        
C         
          
          
          
ZZZZZZZZ  
          
          
  ZZZZZZZZ
          
          
ZZZZZZZ   
          
          
   ZZZZZZZ
          
          
ZZZZCZZ   
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
Z        Z
 Z      Z 
  Z    Z  
   Z  Z  C
   Z  Z   
  Z    Z  
 Z      Z 
Z        Z
          
          
          
          
          
          
          
          
          
          
          
          
          
 ZZZZZZZZZ
S SSSSSSSS
TT TTTTTTT
OOO OOOOOO
IIII IIIII
LLLLL LLLL
JJJJJC JJJ
          
          
          
          
          
          
          
OO  OO  OO
          
          
          
  OO  OO  
          
          
          
OO  OO  OO
          
          
    C     
          
          
          
          
          
J        J
JJ      JJ
JJJ    JJJ
JJJJ  JJJJ
JJJ    JJJ
JJ      JJ
J        J
     C    
          
J        J
JJ      JJ
JJJ    JJJ
JJJJ  JJJJ
JJJ    JJJ
JJ      JJ
J        J
          
          
          
          
  SSSSS   
  S       
  S       
  SSSSS   
  S       
  S       
  SSSSS   
  S       
  S C     
  SSSSS   
  S       
  S       
  SSSSS   
  S       
  S       
  SSSSS   
          
          
          
   OOOO   
          
          
          
OOOO   OOO
          
          
          
   OOOO   
          
          
          
OOO   OOOO
          
 C        
          
          
          
          
          
          
  IIIIII  
    II    
    II    
    II    
ZZ  II  ZZ
    II    
    II    
    II    
  IIIIII  
    II    
    CI    
    II    
ZZ  II  ZZ
    II    
    II    
    II    
          
          
          
          
    OO    
   OOOO   
  OOOOOO  
          
          
    TT    
   TTTT   
  TTTTTT  
    C     
          
    SS    
   SSSS   
  SSSSSS  
          
          
          
          
          
          
          
          
          
          
          
          
          
S         
 S        
  S       
   S      
    S     
         S
        S 
       S  
      S   
     S   C
          
          
          
          
          
          
          
          
          
          
  Z Z Z Z 
          
          
 Z Z Z Z  
          
          
Z  ZZZZZZZ
Z  ZZZZZZC
Z  ZZZZZZZ
Z  ZZZZZZC
          
          
          
          
          
          
          
          
          
          
          
          
  S    S  
 S S  S S 
S   SS   S
          
          
  S    S  
 S S  S S 
S C SS C S
          
          
          
          
          
          
          
          
          
 T      T 
  T    T  
   T  T   
          
    TT    
  TT  TT  
  T    T  
 T      T 
T        T
          
    C     
          
          
          
    II    
   IIII   
  IIIIII  
   IIII   
    II    
          
          
          
          
    LL    
   LLLL   
  LLLLLL  
   LLLL   
    CL    
          
          
          
          
          
          
          
  ZZZZZZ  
  Z    Z  
  Z    Z  
  Z    Z  
  ZZZZZZ  
  Z    Z  
  Z C  Z  
  Z    Z  
  ZZZZZZ  
  Z    Z  
  Z    Z  
  Z    Z  
  ZZZZZZ  
  Z    Z  
  Z    Z  
  Z    Z  
          
          
          
          
          
          
          
          
          
          
  I    I  
  I    I  
 I I  I I 
 I I  I I 
I C II C I
I   II   I
 I I  I I 
 I I  I I 
  I    I  
  I    I  
          
          
          
          
          
    TTTTTT
          
          
TTTTTTT   
   TTTT   
   C  C   
          
          
   TTTT   
          
          
TTTT  TTTT
 TT    TT 
 TT    TT 
 TT C TTT 
          
          
          
          
          
          
          
          
          
 ZZZZZZZZ 
  ZZ  ZZ  
   ZZZZ   
    ZZ    
          
          
          
    JJ    
   JJJJ   
  JJC JJ  
 JJJJJJJJ 
          
          
          
          
          
  LLLLLL  
  L    L  
  L C  L  
  L    L  
  L    L  
  LLLLLL  
          
          
          
          
          
          
          
          
          
          
          
          
          
          
L        L
L        L
L        L
 L      L 
 L      L 
 L      L 
  L    L  
  L    L  
  L    L  
   L  L   
   L  L   
   L  L   
   CLL    
    LL    
    LL    
          
          
          
          
          
          
ZZZZ  ZZZZ
ZZZZ  ZZZZ
ZZZ    ZZZ
ZZZ    ZZZ
ZZ      ZZ
ZZ      ZZ
Z     C  Z
Z  C     Z
ZZ      ZZ
ZZ      ZZ
ZZZ    ZZZ
ZZZ    ZZZ
ZZZZ  ZZZZ
ZZZZ  ZZZZ
          
          
          
          
          
          
 LLLLLLLL 
        L 
       L  
       L  
      L   
      L   
    LL    
    LL    
   L      
   L      
  L C     
  L       
 L        
 LLLLLLLL 
          
          
          
          
          
          
          
          
          
          
  J JJJJ  
  J J  J  
  J J  J  
  J C  J  
  J J  J  
  J J  J  
  JJJ  J  
          
          
          
          
          
          
          
          
          
          
          
    II    
  II  II  
II      II
  II  II  
    II    
          
          
    II    
  II  II  
II      II
  II  II  
C   II   C
          
          
          
          
         Z
        ZZ
       ZZZ
      ZZZZ
     ZZZZZ
    ZZZZZZ
   ZZZZZZZ
  ZZZZZZZZ
  ZZZZZZZZ
   ZZZZZZZ
    ZZZZZZ
     ZZZCZ
      ZZZZ
       ZZZ
        ZZ
         Z
          
          
          
          
O         
O         
 O        
 O        
  O       
  O       
   O      
   O      
    O     
    O     
     O    
     O    
      O   
      O   
       O  
C      O  
          
          
          
          
          
          
   T  T   
  T    T  
          
          
   T  T   
  T    T  
          
          
   T  T   
  T    T  
          
          
   T  T   
  T C  T  
 Z        
 Z      Z 
  Z    Z  
   Z  Z   
   Z  Z   
   Z  Z   
          
          
          
   ZZZZ   
   Z  Z   
   Z  Z   
   Z  Z   
   ZC Z   
   Z  Z   
   Z  Z   
   Z  Z   
          
          
          
C        C
          
          
          
          
ZZZZZZZZZ 
          
 ZZZZZZZZZ
          
ZZZZZZZZZ 
          
 ZZZZZZZZZ
          
ZZZZZZZZZ 
          
 ZZZZZZZZZ
          
ZZZZZZZZZ 
          
 ZZZZZZZZZ
          
          
          
          
          
Z        Z
 Z      Z 
  Z    Z  
   Z  Z   
          
    ZC    
  ZZ  ZZ  
  Z    Z  
 Z      Z 
Z        Z
          
          
          
          
          
          
          
          
          
          
          
          
 S    S   
SCS  SCS  
 S    S   
          
          
   S    S 
  SCS  SCS
   S    S 
          
          
 S    S   
SCS  SCS  
 S    S   
          
          
          
          
          
          
          
          
  S    T  
  S    T  
  S    T  
  S    T  
 S S  T T 
 S S  T T 
 S S  T T 
 S S  T T 
S   ST   T
S   ST   T
S C ST C T
S   ST   T
          
          
          
          
          
    ZZ    
      ZZ  
        ZZ
          
    ZZ    
  ZZ      
ZZ        
          
    ZZ    
      ZZ  
C       ZZ
          
    ZZ    
  ZZ      
ZZ        
          
          
          
          
          
          
          
 SSSSSSSS 
 S      S 
 S SSSS S 
 S S  S S 
 S S CS S 
 S S  S S 
 S S SS S 
 S S    S 
 S SSSSSS 
          
          
          
          
          
          
          
O        O
O        O
O        O
 O      O 
 O      O 
 O      O 
  O    O  
  O    O  
  O    O  
   O  O   
   O  O   
   O  O C 
          
          
          
          
          
          
          
          
          
          
          
    SS    
   SSSS   
  SSSSSS  
 SSSSSSSS 
          
          
          
    SS    
   SSSS   
  SSSSSS  
 SSSSSSSS 
     C    
          
          
          
          
          
          
 ZZZZZZZZ 
    ZZ    
    ZZ    
    ZZ    
SSS ZZ SSS
    ZZ    
    ZZ    
    ZZ    
  ZZZZZZ  
    ZZ    
    ZZ    
    ZZ    
SSS ZC SSS
    ZZ    
    ZZ    
    ZZ    
          
          
          
          
          
          
   JJJJ   
   J  J   
  J    J  
  J    J  
 J      J 
 J      J 
J        J
J   C    J
 J      J 
 J      J 
  J    J  
  J    J  
   J  J   
   JJJJ   
          
          
          
          
          
          
          
SSSSSSSSS 
          
 SSSSSSSSS
          
SSSSSSSSS 
          
 SSSSSSSSS
          
SSSSSSSSS 
          
 SSSSSSSSS
 C        
SSSSSSSSS 
          
          
          
          
          
          
 TTTTTTTT 
        T 
       T  
      T   
     T    
    T     
   T      
  T       
 T        
 TTTTTTTT 
    C     
          
          
          
          
          
          
          
   I   I  
          
          
 I   I   I
          
          
  I   I   
          
          
I   I   I 
          
          
   I   I  
          
          
 C   I   I
          
          
          
          
       L  
       L  
      LLL 
      LLL 
     LLLLL
     LLLLL
  I   LLL 
  I   LLL 
 III   L  
 III   L  
IIIII     
IIIII     
 III      
 III      
  I       
C I       
          
          
          
          
          
          
          
          
          
          
Z        Z
 Z      Z 
  Z    Z  
   Z  Z   
    ZZ    
    ZZ    
   Z  Z   
  Z    Z  
 Z      Z 
Z    C   Z
          
          
          
          
          
          
          
          
          
          
 ZZZZZZZZZ
S SSSSSSSS
TT TTTTTTT
OOO OOOOOO
IIII IIIII
LLLLL LLLL
JJJJJJ JJJ
ZZZZZZZ ZZ
SSSSSSSS S
CTTTTTTTT 
          
          
          
          
          
          
Z        Z
Z        Z
 Z      Z 
 Z      Z 
  Z    Z  
  Z    Z  
C  Z  Z  C
   Z  Z   
  Z    Z  
  Z    Z  
 Z      Z 
 Z      Z 
Z        Z
Z        Z
          
          
          
          
    II    
    II    
    II    
    II    
   I  I   
   I  I   
  I    I  
  I    I  
 I      I 
 I      I 
I        I
I        I
     C    
          
          
          
          
          
          
          
          
 ZZ     Z 
 Z Z    Z 
 Z  Z   Z 
 Z   Z  Z 
 Z    Z Z 
 Z     ZZ 
 Z      Z 
          
          
          
          
    C     
          
          
          
 Z        
 Z      Z 
C Z    Z C
   Z  Z   
   Z  Z   
   Z  Z   
   Z  Z   
          
          
          
          
          
          
    ZZ    
          
   SSSS   
          
  TTTTTT  
          
 OOOOOOOO 
          
          
          
          
          
 TTTTTTTT 
    TT    
   T  T   
  T    T  
 T      T 
          
          
          
          
          
    C     
          
          
          
          
          
          
          
          
          
          
  Z    Z  
  Z    Z  
 Z Z  Z Z 
 Z Z  Z Z 
Z   ZZ   Z
Z C ZZ C Z
          
          
  S    S  
  S    S  
 S S  S S 
 S S  S S 
S   SS   S
S C SS C S
          
          
          
          
          
          
          
          
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S T O I 
Z S C O I 
Z S T O I 
          
          
          
          
          
    ZZ    
   Z  Z   
  Z    Z  
 Z      Z 
Z        Z
 Z      Z 
  Z    Z  
   Z  Z   
    ZZ    
          
          
          
          
          
     C    
          
          
          
          
          
TTTTTTTTT 
          
TTTTTTT T 
          
TTTTT T T 
          
TTT T T T 
          
TTT T T T 
          
TTTTT T T 
          
CTTTTTT T 
          
TTTTTTTTT 
          
          
          
          
   SSSSS  
   S   S  
   S   S  
 S S S S  
 S S S S  
 S S S S  
 S   S    
 S   S    
 SSSSS    
          
          
     C    
          
          
          
          
          
          
          
          
          
  Z    Z  
  Z    Z  
  Z    Z  
 Z Z  Z Z 
 Z Z  Z Z 
 Z Z  Z Z 
Z   ZZ   Z
Z C ZZ C Z
Z   ZZ   Z
 Z Z  Z Z 
 Z Z  Z Z 
 Z Z  Z Z 
  Z    Z  
  Z    Z  
  Z    Z  
          
          
          
          
          
ZZ      ZZ
  Z    Z  
  Z    Z  
   Z  Z   
   Z  Z   
    ZZ    
    ZZ    
   Z  Z   
   Z  Z   
  Z    Z  
  Z    Z  
 Z      Z 
 Z      Z 
Z        Z
Z    C   Z
          
          
          
          
          
          
          
   S  S   
  S    S  
 S      S 
S  S  S  S
  S    S  
 S      S 
S  S  S  S
  S    S  
 S      S 
S  S  S  C
  S    S  
 S      S 
S        S
          
          
          
          
ZZZZ      
   ZZZZ   
          
          
      ZZZZ
   ZZZZ   
          
          
ZZZZ      
   ZZZZ   
          
          
      ZZZZ
   ZZZZ C 
          
          
          
          
          
          
          
          
          
          
          
          
          
Z Z Z Z Z 
          
 S S S S S
          
T T T T T 
          
 O O O O O
          
C I I I I 
O        O
 O      O 
  O    O  
   O  O   
   O  O   
   O  O   
          
          
          
          
I        I
 I      I 
C I    I  
   I  I   
   I  I   
   I  I   
          
          
          
          
          
          
          
          
S         
 S        
  S       
   S      
    S     
     S    
         S
        S 
       S  
      S   
     S    
    S     
   S      
  C       
 S        
S         
          
          
          
          
Z         
Z ZZZZZ   
Z Z   Z   
Z ZCZ Z   
Z ZZZ Z   
Z     Z   
ZZZZZZZ   
          
          
   SSSSSSS
   S     S
   S SSS S
   S SCS S
   S   S S
   SSSSS S
         S
          
          
          
          
          
Z        S
 Z      S 
  Z    S  
   Z  S   
    ZS    
    TO    
   T  O   
  T    O  
 T      O 
T        O
          
          
          
          
    C     
          
          
          
          
          
          
          
  Z Z  S S
   C    C 
  Z Z  S S
          
          
T T  O O  
 C    C   
T T  O O  
          
          
  I I  L L
   C    C 
  I I  L L
          
          
          
          
          
          
  Z    Z  
   Z  Z   
 Z      Z 
  Z    Z  
Z  Z  Z  Z
 Z      Z 
  Z    Z  
   Z  Z   
 Z      Z 
  Z    Z  
   Z  Z   
          
  Z  C Z  
   Z  Z   
          
          
          
          
 ZZZ  ZZZ 
          
 ZZZ  ZZZ 
 ZCZ  ZCZ 
 ZZZ  ZZZ 
          
    ZZ    
    ZZ    
   ZZZZ   
          
          
 Z      Z 
  Z    Z  
   ZZZZ   
          
          
          
          
          
          
          
 CC   CCCC
 C   C   C
 CCCC    C
          
 CCCCCCCCC
 C   C   C
 C   C   C
          
 CCCCCCCCC
 C   C   C
 CCCCC   C
          
 CCCCCC   
    C  CCC
 CCCCCC   
]]

local function parseMap(str, map)
    local array = {}
    local start = 220 * (map - 1)
    for row = 5, 24 do
        local row_array = {}
        for col = 1, 10 do
            local num = start + 11 * (row - 5) + col
            local char = str:sub(num, num)
            local insert_this = nil
            if char == "I" then
                insert_this = { skin = "2tie", colour = "C" }
            elseif char == "J" then
                insert_this = { skin = "2tie", colour = "B" }
            elseif char == "L" then
                insert_this = { skin = "2tie", colour = "O" }
            elseif char == "O" then
                insert_this = { skin = "2tie", colour = "Y" }
            elseif char == "S" then
                insert_this = { skin = "2tie", colour = "G" }
            elseif char == "T" then
                insert_this = { skin = "2tie", colour = "M" }
            elseif char == "Z" then
                insert_this = { skin = "2tie", colour = "R" }
            elseif char == "C" then
                insert_this = { skin = "gem", colour = "W" }
            end
            row_array[col] = insert_this
        end
        array[row] = row_array
    end
    return array
end

function FlashPointViewer:new()
    self.super:new()

    self.ready_frames = 1
    self.next_queue_length = 0
    self.current_map = 1
    self.grid:applyMap(parseMap(board_str, 1))
end

function FlashPointViewer:advanceOneFrame(inputs, ruleset)
    local prev_map = self.current_map
    if inputs.right or (not self.prev_inputs.up and inputs.up) then
        self.current_map = math.min(self.current_map + 1, 100)
    elseif inputs.left or (not self.prev_inputs.down and inputs.down) then
        self.current_map = math.max(self.current_map - 1, 1)
    end
    if prev_map ~= self.current_map then
        self.grid:clear()
        self.grid:applyMap(parseMap(board_str, self.current_map))
    end
    self.prev_inputs = inputs
    return false
end

function FlashPointViewer:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(font_3x5_3)
    love.graphics.print("FLASHPOINT BOARD VIEWER", 240, 120)
    love.graphics.print(self.current_map, 240, 200)
    
    love.graphics.setFont(font_3x5_2)
    love.graphics.print("MAP", 240, 180)
    love.graphics.print("UP/DOWN +/- 1\nLEFT/RIGHT FOR FAST SCROLL", 240, 260)
end

return FlashPointViewer