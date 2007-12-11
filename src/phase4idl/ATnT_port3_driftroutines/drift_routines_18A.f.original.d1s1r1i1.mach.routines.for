      SUBROUTINE S1MACH                                                 
C                                                                       
C  S1MACH TESTS THE CONSISTENCY OF THE MACHINE CONSTANTS IN             
C  I1MACH, R1MACH AND D1MACH.                                           
C                                                                       
      INTEGER IMACH(16),I1MACH                                          
      INTEGER STDOUT                                                    
      INTEGER DIGINT, DIGSP, DIGDP                                      
      REAL RMACH(5),R1MACH                                              
      REAL S2MACH, XR, YR                                               
      REAL SBASE, SBASEM                                                
      REAL ALOG10, SQRT                                                 
      DOUBLE PRECISION DLOG10, DSQRT                                    
      DOUBLE PRECISION DMACH(5),D1MACH                                  
      DOUBLE PRECISION S3MACH, XD, YD                                   
      DOUBLE PRECISION DBASE, DBASEM                                    
C                                                                       
C/6S                                                                    
C     INTEGER IFMT(12)                                                  
C     INTEGER EFMT(15)                                                  
C     INTEGER DFMT(15)                                                  
C     INTEGER CCPLUS                                                    
C/7S                                                                    
      CHARACTER*1 IFMT1(12), EFMT1(15), DFMT1(15), CCPLUS               
      CHARACTER*12 IFMT                                                 
      CHARACTER*15 EFMT, DFMT                                           
      EQUIVALENCE (IFMT1(1),IFMT), (EFMT1(1),EFMT), (DFMT1(1),DFMT)     
C/                                                                      
      INTEGER DWIDTH, WWIDTH, EWIDTH                                    
      INTEGER DEMAX, DEMIN                                              
C                                                                       
      EQUIVALENCE ( STDOUT, IMACH(2) )                                  
      EQUIVALENCE ( DIGINT, IMACH(8) )                                  
      EQUIVALENCE ( DIGSP,  IMACH(11) )                                 
      EQUIVALENCE ( DIGDP,  IMACH(14) )                                 
C                                                                       
C/6S                                                                    
C     DATA CCPLUS   / 1H+ /                                             
C/7S                                                                    
      DATA CCPLUS   / '+' /                                             
C/                                                                      
C                                                                       
C/6S                                                                    
C     DATA IFMT(1 ) / 1H( /                                             
C     DATA IFMT(2 ) / 1HA /                                             
C     DATA IFMT(3 ) / 1H1 /                                             
C     DATA IFMT(4 ) / 1H, /                                             
C     DATA IFMT(5 ) / 1H5 /                                             
C     DATA IFMT(6 ) / 1H1 /                                             
C     DATA IFMT(7 ) / 1HX /                                             
C     DATA IFMT(8 ) / 1H, /                                             
C     DATA IFMT(9 ) / 1HI /                                             
C     DATA IFMT(10) / 1H  /                                             
C     DATA IFMT(11) / 1H  /                                             
C     DATA IFMT(12) / 1H) /                                             
C/7S                                                                    
      DATA IFMT1(1 ) / '(' /                                            
      DATA IFMT1(2 ) / 'A' /                                            
      DATA IFMT1(3 ) / '1' /                                            
      DATA IFMT1(4 ) / ',' /                                            
      DATA IFMT1(5 ) / '5' /                                            
      DATA IFMT1(6 ) / '1' /                                            
      DATA IFMT1(7 ) / 'X' /                                            
      DATA IFMT1(8 ) / ',' /                                            
      DATA IFMT1(9 ) / 'I' /                                            
      DATA IFMT1(10) / ' ' /                                            
      DATA IFMT1(11) / ' ' /                                            
      DATA IFMT1(12) / ')' /                                            
C/                                                                      
C                                                                       
C/6S                                                                    
C     DATA EFMT( 1) / 1H( /,    DFMT( 1) / 1H( /                        
C     DATA EFMT( 2) / 1HA /,    DFMT( 2) / 1HA /                        
C     DATA EFMT( 3) / 1H1 /,    DFMT( 3) / 1H1 /                        
C     DATA EFMT( 4) / 1H, /,    DFMT( 4) / 1H, /                        
C     DATA EFMT( 5) / 1H3 /,    DFMT( 5) / 1H3 /                        
C     DATA EFMT( 6) / 1H2 /,    DFMT( 6) / 1H2 /                        
C     DATA EFMT( 7) / 1HX /,    DFMT( 7) / 1HX /                        
C     DATA EFMT( 8) / 1H, /,    DFMT( 8) / 1H, /                        
C     DATA EFMT( 9) / 1HE /,    DFMT( 9) / 1HD /                        
C     DATA EFMT(10) / 1H  /,    DFMT(10) / 1H  /                        
C     DATA EFMT(11) / 1H  /,    DFMT(11) / 1H  /                        
C     DATA EFMT(12) / 1H. /,    DFMT(12) / 1H. /                        
C     DATA EFMT(13) / 1H  /,    DFMT(13) / 1H  /                        
C     DATA EFMT(14) / 1H  /,    DFMT(14) / 1H  /                        
C     DATA EFMT(15) / 1H) /,    DFMT(15) / 1H) /                        
C/7S                                                                    
      DATA EFMT1( 1) / '(' /,    DFMT1( 1) / '(' /                      
      DATA EFMT1( 2) / 'A' /,    DFMT1( 2) / 'A' /                      
      DATA EFMT1( 3) / '1' /,    DFMT1( 3) / '1' /                      
      DATA EFMT1( 4) / ',' /,    DFMT1( 4) / ',' /                      
      DATA EFMT1( 5) / '3' /,    DFMT1( 5) / '3' /                      
      DATA EFMT1( 6) / '2' /,    DFMT1( 6) / '2' /                      
      DATA EFMT1( 7) / 'X' /,    DFMT1( 7) / 'X' /                      
      DATA EFMT1( 8) / ',' /,    DFMT1( 8) / ',' /                      
      DATA EFMT1( 9) / 'E' /,    DFMT1( 9) / 'D' /                      
      DATA EFMT1(10) / ' ' /,    DFMT1(10) / ' ' /                      
      DATA EFMT1(11) / ' ' /,    DFMT1(11) / ' ' /                      
      DATA EFMT1(12) / '.' /,    DFMT1(12) / '.' /                      
      DATA EFMT1(13) / ' ' /,    DFMT1(13) / ' ' /                      
      DATA EFMT1(14) / ' ' /,    DFMT1(14) / ' ' /                      
      DATA EFMT1(15) / ')' /,    DFMT1(15) / ')' /                      
C/                                                                      
C                                                                       
C  FETCH ALL CONSTANTS INTO LOCAL ARRAYS                                
C                                                                       
      DO 10 I = 1,16                                                    
        IMACH(I) = I1MACH(I)                                            
 10     CONTINUE                                                        
C                                                                       
      DO 20 I = 1,5                                                     
        RMACH(I) = R1MACH(I)                                            
        DMACH(I) = D1MACH(I)                                            
 20     CONTINUE                                                        
C                                                                       
C  COMPUTE NUMBER OF CHARACTER POSITIONS NEEDED FOR WRITING             
C  OUT THE LARGEST INTEGER ALLOWING FOR ONE SPACE AND A SIGN            
C  AND PLUG THE FIELD WIDTH IN THE FORMAT.                              
C                                                                       
      WWIDTH = ICEIL( ALOG10(FLOAT(IMACH(7)))*FLOAT(IMACH(8)) ) + 2     
C/6S                                                                    
C     CALL S88FMT( 2, WWIDTH, IFMT(10) )                                
C     WRITE( STDOUT, 900 ) ( IFMT(I), I = 9, 11 )                       
C/7S                                                                    
      CALL S88FMT( 2, WWIDTH, IFMT1(10) )                               
      WRITE( STDOUT, 900 ) ( IFMT1(I), I = 9, 11 )                      
C/                                                                      
 900  FORMAT(//37H FORMAT CONVERSION FOR INTEGERS IS - ,3A1             
     1       / 25H INTEGER CONSTANTS FOLLOW///)                         
C                                                                       
C  NOW WRITE OUT THE INTEGER CONSTANTS                                  
C                                                                       
      WRITE( STDOUT, 1001 )                                             
 1001 FORMAT(24H THE STANDARD INPUT UNIT)                               
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(1)                            
C                                                                       
      WRITE( STDOUT, 1002 )                                             
 1002 FORMAT(25H THE STANDARD OUTPUT UNIT)                              
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(2)                            
C                                                                       
      WRITE( STDOUT, 1003 )                                             
 1003 FORMAT(24H THE STANDARD PUNCH UNIT)                               
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(3)                            
C                                                                       
      WRITE( STDOUT, 1004 )                                             
 1004 FORMAT(32H THE STANDARD ERROR MESSAGE UNIT)                       
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(4)                            
C                                                                       
      WRITE( STDOUT, 1005 )                                             
 1005 FORMAT(28H THE NUMBER OF BITS PER WORD)                           
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(5)                            
C                                                                       
      WRITE( STDOUT, 1006 )                                             
 1006 FORMAT(34H THE NUMBER OF CHARACTERS PER WORD)                     
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(6)                            
C                                                                       
      WRITE( STDOUT, 1007 )                                             
 1007 FORMAT(34H A, THE BASE OF AN S-DIGIT INTEGER)                     
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(7)                            
C                                                                       
      WRITE( STDOUT, 1008 )                                             
 1008 FORMAT(31H S, THE NUMBER OF BASE-A DIGITS)                        
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(8)                            
C                                                                       
      WRITE( STDOUT, 1009 )                                             
 1009 FORMAT(32H A**S - 1, THE LARGEST MAGNITUDE)                       
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(9)                            
C                                                                       
      WRITE( STDOUT, 1010 )                                             
 1010 FORMAT(47H B, THE BASE OF A T-DIGIT FLOATING-POINT NUMBER)        
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(10)                           
C                                                                       
      WRITE( STDOUT, 1011 )                                             
 1011 FORMAT(51H T, THE NUMBER OF BASE-B DIGITS IN SINGLE-PRECISION)    
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(11)                           
C                                                                       
      WRITE( STDOUT, 1012 )                                             
 1012 FORMAT(45H EMIN, THE SMALLEST SINGLE-PRECISION EXPONENT)          
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(12)                           
C                                                                       
      WRITE( STDOUT, 1013 )                                             
 1013 FORMAT(44H EMAX, THE LARGEST SINGLE-PRECISION EXPONENT)           
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(13)                           
C                                                                       
      WRITE( STDOUT, 1014 )                                             
 1014 FORMAT(51H T, THE NUMBER OF BASE-B DIGITS IN DOUBLE-PRECISION)    
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(14)                           
C                                                                       
      WRITE( STDOUT, 1015 )                                             
 1015 FORMAT(45H EMIN, THE SMALLEST DOUBLE-PRECISION EXPONENT)          
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(15)                           
C                                                                       
      WRITE( STDOUT, 1016 )                                             
 1016 FORMAT(44H EMAX, THE LARGEST DOUBLE-PRECISION EXPONENT)           
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(16)                           
C                                                                       
C  COMPUTE THE NUMBER OF CHARACTER POSITIONS NEEDED FOR WRITING         
C  OUT A SINGLE-PRECISION NUMBER ALLOWING FOR ONE SPACE AND             
C  A SIGN AND PLUG THE FIELDS IN THE FORMAT.                            
C                                                                       
      DWIDTH = ICEIL( ALOG10(FLOAT(IMACH(10)))*FLOAT(IMACH(11)) )       
C/6S                                                                    
C     CALL S88FMT( 2, DWIDTH, EFMT(13) )                                
C/7S                                                                    
      CALL S88FMT( 2, DWIDTH, EFMT1(13) )                               
C/                                                                      
      DEMIN =  IFLR( ALOG10(FLOAT(IMACH(10)))*FLOAT(IMACH(12)-1) ) + 1  
      DEMAX = ICEIL( ALOG10(FLOAT(IMACH(10)))*FLOAT(IMACH(13)) )        
      EWIDTH = IFLR( ALOG10(FLOAT(MAX0(IABS(DEMIN),IABS(DEMAX)))) ) + 1 
      WWIDTH = DWIDTH + EWIDTH + 6                                      
C/6S                                                                    
C     CALL S88FMT( 2, WWIDTH, EFMT(10) )                                
C     WRITE( STDOUT, 1900 ) ( EFMT(I), I = 9, 14 )                      
C/7S                                                                    
      CALL S88FMT( 2, WWIDTH, EFMT1(10) )                               
      WRITE( STDOUT, 1900 ) ( EFMT1(I), I = 9, 14 )                     
C/                                                                      
 1900 FORMAT(//45H FORMAT CONVERSION FOR SINGLE-PRECISION IS - ,6A1     
     1       / 34H SINGLE-PRECISION CONSTANTS FOLLOW///)                
C                                                                       
C  NOW WRITE OUT THE SINGLE-PRECISION CONSTANTS                         
C                                                                       
      WRITE( STDOUT, 2001 )                                             
 2001 FORMAT(32H THE SMALLEST POSITIVE MAGNITUDE)                       
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(1)                            
C                                                                       
      WRITE( STDOUT, 2002 )                                             
 2002 FORMAT(22H THE LARGEST MAGNITUDE)                                 
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(2)                            
C                                                                       
      WRITE( STDOUT, 2003 )                                             
 2003 FORMAT(30H THE SMALLEST RELATIVE SPACING)                         
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(3)                            
C                                                                       
      WRITE( STDOUT, 2004 )                                             
 2004 FORMAT(29H THE LARGEST RELATIVE SPACING)                          
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(4)                            
C                                                                       
      WRITE( STDOUT, 2005 )                                             
 2005 FORMAT(18H LOG10 OF THE BASE)                                     
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(5)                            
C/6S                                                                    
C     CALL S88FMT( 2, WWIDTH+1, EFMT(10) )                              
C     CALL S88FMT( 2, DWIDTH+1, EFMT(13) )                              
C/7S                                                                    
      CALL S88FMT( 2, WWIDTH+1, EFMT1(10) )                             
      CALL S88FMT( 2, DWIDTH+1, EFMT1(13) )                             
C/                                                                      
C  COMPUTE THE NUMBER OF CHARACTER POSITIONS NEEDED FOR WRITING         
C  OUT A DOUBLE-PRECISION NUMBER ALLOWING FOR ONE SPACE AND             
C  A SIGN AND PLUG THE FIELDS IN THE FORMAT.                            
C                                                                       
      DWIDTH = ICEIL( ALOG10(FLOAT(IMACH(10)))*FLOAT(IMACH(14)) )       
C/6S                                                                    
C     CALL S88FMT( 2, DWIDTH, DFMT(13) )                                
C/7S                                                                    
      CALL S88FMT( 2, DWIDTH, DFMT1(13) )                               
C/                                                                      
      DEMIN =  IFLR( ALOG10(FLOAT(IMACH(10)))*FLOAT(IMACH(15)-1) ) + 1  
      DEMAX = ICEIL( ALOG10(FLOAT(IMACH(10)))*FLOAT(IMACH(16)) )        
      EWIDTH = IFLR( ALOG10(FLOAT(MAX0(IABS(DEMIN),IABS(DEMAX)))) ) + 1 
      WWIDTH = DWIDTH + EWIDTH + 6                                      
C/6S                                                                    
C     CALL S88FMT( 2, WWIDTH, DFMT(10) )                                
C     WRITE( STDOUT, 2900 ) ( DFMT(I), I = 9, 14 )                      
C/7S                                                                    
      CALL S88FMT( 2, WWIDTH, DFMT1(10) )                               
      WRITE( STDOUT, 2900 ) ( DFMT1(I), I = 9, 14 )                     
C/                                                                      
 2900 FORMAT(//45H FORMAT CONVERSION FOR DOUBLE-PRECISION IS - ,6A1     
     1       / 34H DOUBLE-PRECISION CONSTANTS FOLLOW///)                
C                                                                       
C  NOW WRITE OUT THE DOUBLE-PRECISION CONSTANTS                         
C                                                                       
      WRITE( STDOUT, 3001 )                                             
 3001 FORMAT(32H THE SMALLEST POSITIVE MAGNITUDE)                       
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(1)                            
C                                                                       
      WRITE( STDOUT, 3002 )                                             
 3002 FORMAT(22H THE LARGEST MAGNITUDE)                                 
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(2)                            
C                                                                       
      WRITE( STDOUT, 3003 )                                             
 3003 FORMAT(30H THE SMALLEST RELATIVE SPACING)                         
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(3)                            
C                                                                       
      WRITE( STDOUT, 3004 )                                             
 3004 FORMAT(29H THE LARGEST RELATIVE SPACING)                          
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(4)                            
C                                                                       
      WRITE( STDOUT, 3005 )                                             
 3005 FORMAT(18H LOG10 OF THE BASE)                                     
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(5)                            
C/6S                                                                    
C     CALL S88FMT( 2, WWIDTH+1, DFMT(10) )                              
C     CALL S88FMT( 2, DWIDTH+1, DFMT(13) )                              
C/7S                                                                    
      CALL S88FMT( 2, WWIDTH+1, DFMT1(10) )                             
      CALL S88FMT( 2, DWIDTH+1, DFMT1(13) )                             
C/                                                                      
C  NOW CHECK CONSISTENCY OF INTEGER CONSTANTS                           
C/6S                                                                    
C     CALL S88FMT( 2, 14, IFMT(5) )                                     
C/7S                                                                    
      CALL S88FMT( 2, 14, IFMT1(5) )                                    
C/                                                                      
      IF( IMACH(11) .LE. IMACH(14) ) GOTO 4009                          
      WRITE( STDOUT, 4001 )                                             
 4001 FORMAT(30H0I1MACH(11) EXCEEDS I1MACH(14) )                        
      WRITE( STDOUT, 4002 )                                             
 4002 FORMAT(13H I1MACH(11) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(11)                           
      WRITE( STDOUT, 4003 )                                             
 4003 FORMAT(13H I1MACH(14) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(14)                           
 4009 CONTINUE                                                          
C                                                                       
      IF( IMACH(13) .LE. IMACH(16) ) GOTO 4019                          
      WRITE( STDOUT, 4011 )                                             
 4011 FORMAT(40H0WARNING - I1MACH(13) EXCEEDS I1MACH(16) )              
      WRITE( STDOUT, 4012 )                                             
 4012 FORMAT(13H I1MACH(13) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(13)                           
      WRITE( STDOUT, 4013 )                                             
 4013 FORMAT(13H I1MACH(16) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(16)                           
 4019 CONTINUE                                                          
C                                                                       
      IF( IMACH(16)-IMACH(15) .GE. IMACH(13)-IMACH(12) ) GOTO 4029      
      WRITE( STDOUT, 4021 )                                             
 4021 FORMAT(34H0WARNING - I1MACH(13) - I1MACH(12) )                    
      WRITE( STDOUT, 4022 )                                             
 4022 FORMAT(32H EXCEEDS I1MACH(16) - I1MACH(15) )                      
      WRITE( STDOUT, 4023 )                                             
 4023 FORMAT(13H I1MACH(12) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(12)                           
      WRITE( STDOUT, 4024 )                                             
 4024 FORMAT(13H I1MACH(13) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(13)                           
      WRITE( STDOUT, 4025 )                                             
 4025 FORMAT(13H I1MACH(15) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(15)                           
      WRITE( STDOUT, 4026 )                                             
 4026 FORMAT(13H I1MACH(16) = )                                         
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(16)                           
 4029 CONTINUE                                                          
C                                                                       
      N = 0                                                             
      IBASEM = IMACH(7) - 1                                             
      DO 4030 I = 1, DIGINT                                             
        N = N*IMACH(7) + IBASEM                                         
 4030   CONTINUE                                                        
C                                                                       
      IF( IMACH(9) .EQ. N) GOTO 4039                                    
      WRITE( STDOUT, 4031 )                                             
 4031 FORMAT(39H1IMACH(9) IS NOT IMACH(7)**IMACH(8) - 1 )               
      WRITE( STDOUT, 4032 )                                             
 4032 FORMAT(12H I1MACH(7) = )                                          
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(7)                            
      WRITE( STDOUT, 4034 )                                             
 4034 FORMAT(12H I1MACH(8) = )                                          
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(8)                            
      WRITE( STDOUT, 4035 )                                             
 4035 FORMAT(12H I1MACH(9) = )                                          
      WRITE( STDOUT, IFMT ) CCPLUS, IMACH(9)                            
 4039 CONTINUE                                                          
C                                                                       
C NOW CHECK CONSISTENCY OF SINGLE-PRECISION CONSTANTS                   
C/6S                                                                    
C     CALL S88FMT( 2, 19, EFMT(5) )                                     
C/7S                                                                    
      CALL S88FMT( 2, 19, EFMT1(5) )                                    
C/                                                                      
      XR = S2MACH( 1.0, IMACH(10), IMACH(12)-1 )                        
      IF( XR .EQ. RMACH(1) ) GOTO 5009                                  
      WRITE( STDOUT, 5001 )                                             
 5001 FORMAT(47H0R1MACH(1) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 5002 )                                             
 5002 FORMAT(12H R1MACH(1) = )                                          
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(1)                            
      WRITE( STDOUT, 5003 )                                             
 5003 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
      WRITE( STDOUT, 5004 )                                             
 5004 FORMAT(14H DIFFERENCE = )                                         
      XR = RMACH(1) - XR                                                
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 5009 CONTINUE                                                          
C                                                                       
      XR = 0.0                                                          
      SBASE  = FLOAT( IMACH(10) )                                       
      SBASEM = FLOAT( IMACH(10)-1 )                                     
      DO 5010 I = 1, DIGSP                                              
        XR = (XR + SBASEM)/SBASE                                        
 5010   CONTINUE                                                        
C                                                                       
      XR = S2MACH( XR, IMACH(10), IMACH(13) )                           
      IF( XR .EQ. RMACH(2) ) GOTO 5019                                  
      WRITE( STDOUT, 5011 )                                             
 5011 FORMAT(47H0R1MACH(2) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 5012 )                                             
 5012 FORMAT(12H R1MACH(2) = )                                          
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(2)                            
      WRITE( STDOUT, 5013 )                                             
 5013 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
      WRITE( STDOUT, 5014 )                                             
 5014 FORMAT(14H DIFFERENCE = )                                         
      XR = RMACH(2) - XR                                                
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 5019 CONTINUE                                                          
C                                                                       
      XR = S2MACH( 1.0, IMACH(10), -IMACH(11) )                         
      IF( XR .EQ. RMACH(3) ) GOTO 5029                                  
      WRITE( STDOUT, 5021 )                                             
 5021 FORMAT(47H0R1MACH(3) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 5022 )                                             
 5022 FORMAT(12H R1MACH(3) = )                                          
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(3)                            
      WRITE( STDOUT, 5023 )                                             
 5023 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
      WRITE( STDOUT, 5024 )                                             
 5024 FORMAT(14H DIFFERENCE = )                                         
      XR = RMACH(3) - XR                                                
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 5029 CONTINUE                                                          
C                                                                       
      XR = S2MACH( 1.0, IMACH(10), 1-IMACH(11) )                        
      IF( XR .EQ. RMACH(4) ) GOTO 5039                                  
      WRITE( STDOUT, 5031 )                                             
 5031 FORMAT(47H0R1MACH(4) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 5032 )                                             
 5032 FORMAT(12H R1MACH(4) = )                                          
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(4)                            
      WRITE( STDOUT, 5033 )                                             
 5033 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
      WRITE( STDOUT, 5034 )                                             
 5034 FORMAT(14H DIFFERENCE = )                                         
      XR = RMACH(4) - XR                                                
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 5039 CONTINUE                                                          
C                                                                       
      XR = ALOG10( FLOAT(IMACH(10)) )                                   
      IF( XR .EQ. RMACH(5) ) GOTO 5049                                  
      WRITE( STDOUT, 5041 )                                             
 5041 FORMAT(47H0R1MACH(5) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 5042 )                                             
 5042 FORMAT(12H R1MACH(5) = )                                          
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(5)                            
      WRITE( STDOUT, 5043 )                                             
 5043 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
      WRITE( STDOUT, 5044 )                                             
 5044 FORMAT(14H DIFFERENCE = )                                         
      XR = RMACH(5) - XR                                                
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 5049 CONTINUE                                                          
C                                                                       
C NOW CHECK CONSISTENCY OF DOUBLE-PRECISION CONSTANTS                   
C/6S                                                                    
C     CALL S88FMT( 2, 19, DFMT(5) )                                     
C/7S                                                                    
      CALL S88FMT( 2, 19, DFMT1(5) )                                    
C/                                                                      
      XD = S3MACH( 1.0D0, IMACH(10), IMACH(15)-1 )                      
      IF( XD .EQ. DMACH(1) ) GOTO 6009                                  
      WRITE( STDOUT, 6001 )                                             
 6001 FORMAT(47H0D1MACH(1) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 6002 )                                             
 6002 FORMAT(12H D1MACH(1) = )                                          
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(1)                            
      WRITE( STDOUT, 6003 )                                             
 6003 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
      WRITE( STDOUT, 6004 )                                             
 6004 FORMAT(14H DIFFERENCE = )                                         
      XD = DMACH(1) - XD                                                
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 6009 CONTINUE                                                          
C                                                                       
      XD = 0.0D0                                                        
      DBASE  = DBLE ( FLOAT( IMACH(10) ) )                              
      DBASEM = DBLE ( FLOAT( IMACH(10)-1 ) )                            
      DO 6010 I = 1, DIGDP                                              
        XD = (XD + DBASEM)/DBASE                                        
 6010   CONTINUE                                                        
C                                                                       
      XD = S3MACH( XD, IMACH(10), IMACH(16) )                           
      IF( XD .EQ. DMACH(2) ) GOTO 6019                                  
      WRITE( STDOUT, 6011 )                                             
 6011 FORMAT(47H0D1MACH(2) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 6012 )                                             
 6012 FORMAT(12H D1MACH(2) = )                                          
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(2)                            
      WRITE( STDOUT, 6013 )                                             
 6013 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
      WRITE( STDOUT, 6014 )                                             
 6014 FORMAT(14H DIFFERENCE = )                                         
      XD = DMACH(2) - XD                                                
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 6019 CONTINUE                                                          
C                                                                       
      XD = S3MACH( 1.0D0, IMACH(10), -IMACH(14) )                       
      IF( XD .EQ. DMACH(3) ) GOTO 6029                                  
      WRITE( STDOUT, 6021 )                                             
 6021 FORMAT(47H0D1MACH(3) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 6022 )                                             
 6022 FORMAT(12H D1MACH(3) = )                                          
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(3)                            
      WRITE( STDOUT, 6023 )                                             
 6023 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
      WRITE( STDOUT, 6024 )                                             
 6024 FORMAT(14H DIFFERENCE = )                                         
      XD = DMACH(3) - XD                                                
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 6029 CONTINUE                                                          
C                                                                       
      XD = S3MACH( 1.0D0, IMACH(10), 1-IMACH(14) )                      
      IF( XD .EQ. DMACH(4) ) GOTO 6039                                  
      WRITE( STDOUT, 6031 )                                             
 6031 FORMAT(47H0D1MACH(4) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 6032 )                                             
 6032 FORMAT(12H D1MACH(4) = )                                          
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(4)                            
      WRITE( STDOUT, 6033 )                                             
 6033 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
      WRITE( STDOUT, 6034 )                                             
 6034 FORMAT(14H DIFFERENCE = )                                         
      XD = DMACH(4) - XD                                                
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 6039 CONTINUE                                                          
C                                                                       
      XD = DLOG10( DBLE(FLOAT(IMACH(10))) )                             
      IF( XD .EQ. DMACH(5) ) GOTO 6049                                  
      WRITE( STDOUT, 6041 )                                             
 6041 FORMAT(47H0D1MACH(5) DOES NOT AGREE WITH CALCULATED VALUE)        
      WRITE( STDOUT, 6042 )                                             
 6042 FORMAT(12H D1MACH(5) = )                                          
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(5)                            
      WRITE( STDOUT, 6043 )                                             
 6043 FORMAT(19H CALCULATED VALUE = )                                   
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
      WRITE( STDOUT, 6044 )                                             
 6044 FORMAT(14H DIFFERENCE = )                                         
      XD = DMACH(5) - XD                                                
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 6049 CONTINUE                                                          
C                                                                       
C NOW SEE IF SINGLE-PRECISION IS CLOSED UNDER NEGATION                  
C                                                                       
      XR = -RMACH(1)                                                    
      XR = -XR                                                          
      IF( XR .EQ. RMACH(1) ) GOTO 7009                                  
      WRITE( STDOUT, 7001 )                                             
 7001 FORMAT(29H0-(-R1MACH(1)) .NE. R1MACH(1))                          
      WRITE( STDOUT, 7002 )                                             
 7002 FORMAT(16H    R1MACH(1)  = )                                      
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(1)                            
      WRITE( STDOUT, 7003 )                                             
 7003 FORMAT(16H -(-R1MACH(1)) = )                                      
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 7009 CONTINUE                                                          
C                                                                       
      XR = -RMACH(2)                                                    
      XR = -XR                                                          
      IF( XR .EQ. RMACH(2) ) GOTO 7019                                  
      WRITE( STDOUT, 7011 )                                             
 7011 FORMAT(29H0-(-R1MACH(2)) .NE. R1MACH(2))                          
      WRITE( STDOUT, 7012 )                                             
 7012 FORMAT(16H    R1MACH(2)  = )                                      
      WRITE( STDOUT, EFMT ) CCPLUS, RMACH(2)                            
      WRITE( STDOUT, 7013 )                                             
 7013 FORMAT(16H -(-R1MACH(2)) = )                                      
      WRITE( STDOUT, EFMT ) CCPLUS, XR                                  
 7019 CONTINUE                                                          
C                                                                       
C NOW SEE IF DOUBLE-PRECISION IS CLOSED UNDER NEGATION                  
C                                                                       
      XD = -DMACH(1)                                                    
      XD = -XD                                                          
      IF( XD .EQ. DMACH(1) ) GOTO 8009                                  
      WRITE( STDOUT, 8001 )                                             
 8001 FORMAT(29H0-(-D1MACH(1)) .NE. D1MACH(1))                          
      WRITE( STDOUT, 8002 )                                             
 8002 FORMAT(16H    D1MACH(1)  = )                                      
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(1)                            
      WRITE( STDOUT, 8003 )                                             
 8003 FORMAT(16H -(-D1MACH(1)) = )                                      
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 8009 CONTINUE                                                          
C                                                                       
      XD = -DMACH(2)                                                    
      XD = -XD                                                          
      IF( XD .EQ. DMACH(2) ) GOTO 8019                                  
      WRITE( STDOUT, 8011 )                                             
 8011 FORMAT(29H0-(-D1MACH(2)) .NE. D1MACH(2))                          
      WRITE( STDOUT, 8012 )                                             
 8012 FORMAT(16H    D1MACH(2)  = )                                      
      WRITE( STDOUT, DFMT ) CCPLUS, DMACH(2)                            
      WRITE( STDOUT, 8013 )                                             
 8013 FORMAT(16H -(-D1MACH(2)) = )                                      
      WRITE( STDOUT, DFMT ) CCPLUS, XD                                  
 8019 CONTINUE                                                          
C                                                                       
C CHECK THAT SQRT AND DSQRT WORK NEAR OVER- AND UNDERFLOW LIMITS.       
C                                                                       
      N = IMACH(11)/2 + 1                                               
      XR = SQRT(RMACH(1))                                               
      IF (XR .GT. 0.0) GO TO 9002                                       
         WRITE( STDOUT, 9001 )                                          
 9001    FORMAT(18H SQRT(R1MACH(1)) =)                                  
         WRITE( STDOUT, EFMT ) CCPLUS, XR                               
         GO TO 9004                                                     
C SCALE TO AVOID TROUBLE FROM UNDERFLOW...                              
 9002 XR = S2MACH( XR, IMACH(10), N)                                    
      YR = S2MACH( RMACH(1), IMACH(10), 2*N)                            
      YR = ABS(XR*XR - YR) / YR                                         
      IF (YR .LT. 2.*RMACH(4)) GO TO 9004                               
         WRITE( STDOUT, 9003 )                                          
 9003    FORMAT(35H EXCESSIVE ERROR IN SQRT(R1MACH(1))/13H REL. ERROR =)
         WRITE( STDOUT, EFMT ) CCPLUS, YR                               
 9004 XR = SQRT(RMACH(2))                                               
      IF (XR .GT. 0.0) GO TO 9006                                       
         WRITE( STDOUT, 9005 )                                          
 9005    FORMAT(18H SQRT(R1MACH(2)) =)                                  
         WRITE( STDOUT, EFMT ) CCPLUS, XR                               
         GO TO 9008                                                     
C SCALE TO AVOID TROUBLE FROM OVERFLOW...                               
 9006 XR = S2MACH( XR, IMACH(10), -N)                                   
      YR = S2MACH( RMACH(2), IMACH(10), -2*N)                           
      YR = ABS(XR*XR - YR) / YR                                         
      IF (YR .LT. 2.*RMACH(4)) GO TO 9008                               
         WRITE( STDOUT, 9007 )                                          
 9007    FORMAT(35H EXCESSIVE ERROR IN SQRT(R1MACH(2))/13H REL. ERROR =)
         WRITE( STDOUT, EFMT ) CCPLUS, YR                               
C                                                                       
 9008 N = IMACH(14)/2 + 1                                               
      XD = DSQRT(DMACH(1))                                              
      IF (XD .GT. 0.D0) GO TO 9010                                      
         WRITE( STDOUT, 9009 )                                          
 9009    FORMAT(19H DSQRT(D1MACH(1)) =)                                 
         WRITE( STDOUT, DFMT ) CCPLUS, XD                               
         GO TO 9012                                                     
C AGAIN SCALE TO AVOID TROUBLE FROM UNDERFLOW...                        
 9010 XD = S3MACH( XD, IMACH(10), N)                                    
      YD = S3MACH( DMACH(1), IMACH(10), 2*N)                            
      YD = DABS(XD*XD - YD) / YD                                        
      IF (YD .LT. 2.D0*DMACH(4)) GO TO 9012                             
        WRITE( STDOUT, 9011 )                                           
 9011   FORMAT(36H EXCESSIVE ERROR IN DSQRT(D1MACH(1))/13H REL. ERROR =)
        WRITE( STDOUT, EFMT ) CCPLUS, YD                                
 9012 XD = DSQRT(DMACH(2))                                              
      IF (XD .GT. 0.0D0) GO TO 9014                                     
        WRITE( STDOUT, 9013 )                                           
 9013   FORMAT(19H DSQRT(D1MACH(2)) =)                                  
        WRITE( STDOUT, EFMT ) CCPLUS, XD                                
        GO TO 9016                                                      
C AGAIN SCALE TO AVOID TROUBLE FROM OVERFLOW...                         
 9014 XD = S3MACH( XD, IMACH(10), -N)                                   
      YD = S3MACH( DMACH(2), IMACH(10), -2*N)                           
      YD = DABS(XD*XD - YD) / YD                                        
      IF (YD .LT. 2.D0*DMACH(4)) GO TO 9016                             
        WRITE( STDOUT, 9015 )                                           
 9015   FORMAT(36H EXCESSIVE ERROR IN DSQRT(D1MACH(2))/13H REL. ERROR =)
        WRITE( STDOUT, EFMT ) CCPLUS, YD                                
 9016 RETURN                                                            
C                                                                       
      END                                                               
      REAL FUNCTION S2MACH( XR, BASE, EXP )                             
C                                                                       
C S2MACH = XR * BASE**EXP                                               
C                                                                       
C     (17-JUN-85) -- REVISED TO MAKE OVERFLOW LESS LIKELY               
      INTEGER BASE, EXP                                                 
      REAL TBASE, XR                                                    
C                                                                       
      TBASE = FLOAT(BASE)                                               
      S2MACH = XR                                                       
C                                                                       
      N = EXP                                                           
      IF( N .GE. 0 ) GO TO 20                                           
C                                                                       
      N = -N                                                            
      TBASE = 1.0/TBASE                                                 
C                                                                       
 20   IF( MOD(N,2) .NE. 0 ) S2MACH = S2MACH*TBASE                       
      N = N/2                                                           
      IF( N .LT. 2 ) GO TO 30                                           
      TBASE = TBASE * TBASE                                             
      GO TO 20                                                          
C                                                                       
 30   IF (N .EQ. 1) S2MACH = (S2MACH * TBASE) * TBASE                   
      RETURN                                                            
C                                                                       
      END                                                               
      DOUBLE PRECISION FUNCTION S3MACH( XD, BASE, EXP )                 
C                                                                       
C S3MACH = XD * BASE**EXP                                               
C                                                                       
C     (17-JUN-85) -- REVISED TO MAKE OVERFLOW LESS LIKELY               
      INTEGER BASE, EXP                                                 
      DOUBLE PRECISION TBASE, XD                                        
C                                                                       
      TBASE = FLOAT(BASE)                                               
      S3MACH = XD                                                       
C                                                                       
      N = EXP                                                           
      IF( N .GE. 0 ) GO TO 20                                           
C                                                                       
      N = -N                                                            
      TBASE = 1.0D0/TBASE                                               
C                                                                       
 20   IF( MOD(N,2) .NE. 0 ) S3MACH = S3MACH*TBASE                       
      N = N/2                                                           
      IF( N .LT. 2 ) GO TO 30                                           
      TBASE = TBASE * TBASE                                             
      GO TO 20                                                          
C                                                                       
 30   IF (N .EQ. 1) S3MACH = (S3MACH * TBASE) * TBASE                   
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE ENTER(IRNEW)                                           
C                                                                       
C  THIS ROUTINE SAVES                                                   
C                                                                       
C    1) THE CURRENT NUMBER OF OUTSTANDING STORAGE ALLOCATIONS, LOUT, AND
C    2) THE CURRENT RECOVERY LEVEL, LRECOV,                             
C                                                                       
C  IN AN ENTER-BLOCK IN THE STACK.                                      
C                                                                       
C  IT ALSO SETS LRECOV = IRNEW IF IRNEW = 1 OR 2.                       
C  IF IRNEW = 0, THEN THE RECOVERY LEVEL IS NOT ALTERED.                
C                                                                       
C  SCRATCH SPACE ALLOCATED - 3 INTEGER WORDS ARE LEFT ON THE STACK.     
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - MUST HAVE IRNEW = 0, 1 OR 2.                                   
C                                                                       
      COMMON /CSTAK/DSTACK                                              
      DOUBLE PRECISION DSTACK(500)                                      
      INTEGER ISTACK(1000)                                              
      EQUIVALENCE (DSTACK(1),ISTACK(1))                                 
      EQUIVALENCE (ISTACK(1),LOUT)                                      
C                                                                       
C/6S                                                                    
C     IF (0.GT.IRNEW .OR. IRNEW.GT.2)                                   
C    1  CALL SETERR(35HENTER - MUST HAVE IRNEW = 0, 1 OR 2,35,1,2)      
C/7S                                                                    
      IF (0.GT.IRNEW .OR. IRNEW.GT.2)                                   
     1  CALL SETERR('ENTER - MUST HAVE IRNEW = 0, 1 OR 2',35,1,2)       
C/                                                                      
C                                                                       
C  ALLOCATE SPACE FOR SAVING THE ABOVE 2 ITEMS                          
C  AND A BACK-POINTER FOR CHAINING THE ENTER-BLOCKS TOGETHER.           
C                                                                       
      INOW=ISTKGT(3,2)                                                  
C                                                                       
C  SAVE THE CURRENT NUMBER OF OUTSTANDING ALLOCATIONS.                  
C                                                                       
      ISTACK(INOW)=LOUT                                                 
C                                                                       
C  SAVE THE CURRENT RECOVERY LEVEL.                                     
C                                                                       
      CALL ENTSRC(ISTACK(INOW+1),IRNEW)                                 
C                                                                       
C  SAVE A BACK-POINTER TO THE START OF THE PREVIOUS ENTER-BLOCK.        
C                                                                       
      ISTACK(INOW+2)=I8TSEL(INOW)                                       
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE LEAVE                                                  
C                                                                       
C  THIS ROUTINE                                                         
C                                                                       
C    1) DE-ALLOCATES ALL SCRATCH SPACE ALLOCATED SINCE THE LAST ENTER,  
C       INCLUDING THE LAST ENTER-BLOCK.                                 
C    2) RESTORES THE RECOVERY LEVEL TO ITS VALUE                        
C       AT THE TIME OF THE LAST CALL TO ENTER.                          
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - CANNOT LEAVE BEYOND THE FIRST ENTER.                           
C    2 - ISTACK(INOW) HAS BEEN OVERWRITTEN.                             
C    3 - TOO MANY ISTKRLS OR ISTACK(1 AND/OR INOW) CLOBBERED.           
C    4 - ISTACK(INOW+1) HAS BEEN OVERWRITTEN.                           
C    5 - ISTACK(INOW+2) HAS BEEN OVERWRITTEN.                           
C                                                                       
      COMMON /CSTAK/DSTACK                                              
      DOUBLE PRECISION DSTACK(500)                                      
      INTEGER ISTACK(1000)                                              
      EQUIVALENCE (DSTACK(1),ISTACK(1))                                 
      EQUIVALENCE (ISTACK(1),LOUT)                                      
C                                                                       
C  GET THE POINTER TO THE CURRENT ENTER-BLOCK.                          
C                                                                       
      INOW=I8TSEL(-1)                                                   
C                                                                       
C/6S                                                                    
C     IF (INOW.EQ.0)                                                    
C    1  CALL SETERR(43HLEAVE - CANNOT LEAVE BEYOND THE FIRST ENTER,43,  
C    2              1,2)                                                
C     IF (ISTACK(INOW).LT.1)                                            
C    1  CALL SETERR(41HLEAVE - ISTACK(INOW) HAS BEEN OVERWRITTEN,41,2,2)
C     IF (LOUT.LT.ISTACK(INOW)) CALL SETERR(                            
C    1  59HLEAVE - TOO MANY ISTKRLS OR ISTACK(1 AND/OR INOW) CLOBBERED, 
C    2  59,3,2)                                                         
C     IF (ISTACK(INOW+1).LT.1 .OR. ISTACK(INOW+1).GT.2)                 
C    1  CALL SETERR(43HLEAVE - ISTACK(INOW+1) HAS BEEN OVERWRITTEN,     
C    2              43,4,2)                                             
C     IF (ISTACK(INOW+2).GT.INOW-3 .OR. ISTACK(INOW+2).LT.0)            
C    1  CALL SETERR(43HLEAVE - ISTACK(INOW+2) HAS BEEN OVERWRITTEN,     
C    2              43,5,2)                                             
C/7S                                                                    
      IF (INOW.EQ.0)                                                    
     1  CALL SETERR('LEAVE - CANNOT LEAVE BEYOND THE FIRST ENTER',43,   
     2              1,2)                                                
      IF (ISTACK(INOW).LT.1)                                            
     1  CALL SETERR('LEAVE - ISTACK(INOW) HAS BEEN OVERWRITTEN',41,2,2) 
      IF (LOUT.LT.ISTACK(INOW)) CALL SETERR(                            
     1  'LEAVE - TOO MANY ISTKRLS OR ISTACK(1 AND/OR INOW) CLOBBERED',  
     2  59,3,2)                                                         
      IF (ISTACK(INOW+1).LT.1 .OR. ISTACK(INOW+1).GT.2)                 
     1  CALL SETERR('LEAVE - ISTACK(INOW+1) HAS BEEN OVERWRITTEN',      
     2              43,4,2)                                             
      IF (ISTACK(INOW+2).GT.INOW-3 .OR. ISTACK(INOW+2).LT.0)            
     1  CALL SETERR('LEAVE - ISTACK(INOW+2) HAS BEEN OVERWRITTEN',      
     2              43,5,2)                                             
C/                                                                      
C                                                                       
C  DE-ALLOCATE THE SCRATCH SPACE.                                       
C                                                                       
      CALL ISTKRL(LOUT-ISTACK(INOW)+1)                                  
C                                                                       
C  RESTORE THE RECOVERY LEVEL.                                          
C                                                                       
      CALL RETSRC(ISTACK(INOW+1))                                       
C                                                                       
C  LOWER THE BACK-POINTER.                                              
C                                                                       
      ITEMP=I8TSEL(ISTACK(INOW+2))                                      
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE ENTSRC(IROLD,IRNEW)                                    
C                                                                       
C  THIS ROUTINE RETURNS IROLD = LRECOV AND SETS LRECOV = IRNEW.         
C                                                                       
C  IF THERE IS AN ACTIVE ERROR STATE, THE MESSAGE IS PRINTED            
C  AND EXECUTION STOPS.                                                 
C                                                                       
C  IRNEW = 0 LEAVES LRECOV UNCHANGED, WHILE                             
C  IRNEW = 1 GIVES RECOVERY AND                                         
C  IRNEW = 2 TURNS RECOVERY OFF.                                        
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - ILLEGAL VALUE OF IRNEW.                                        
C    2 - CALLED WHILE IN AN ERROR STATE.                                
C                                                                       
C/6S                                                                    
C     IF (IRNEW.LT.0 .OR. IRNEW.GT.2)                                   
C    1   CALL SETERR(31HENTSRC - ILLEGAL VALUE OF IRNEW,31,1,2)         
C/7S                                                                    
      IF (IRNEW.LT.0 .OR. IRNEW.GT.2)                                   
     1   CALL SETERR('ENTSRC - ILLEGAL VALUE OF IRNEW',31,1,2)          
C/                                                                      
C                                                                       
      IROLD=I8SAVE(2,IRNEW,IRNEW.NE.0)                                  
C                                                                       
C  IF HAVE AN ERROR STATE, STOP EXECUTION.                              
C                                                                       
C/6S                                                                    
C     IF (I8SAVE(1,0,.FALSE.) .NE. 0) CALL SETERR                       
C    1   (39HENTSRC - CALLED WHILE IN AN ERROR STATE,39,2,2)            
C/7S                                                                    
      IF (I8SAVE(1,0,.FALSE.) .NE. 0) CALL SETERR                       
     1   ('ENTSRC - CALLED WHILE IN AN ERROR STATE',39,2,2)             
C/                                                                      
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE RETSRC(IROLD)                                          
C                                                                       
C  THIS ROUTINE SETS LRECOV = IROLD.                                    
C                                                                       
C  IF THE CURRENT ERROR BECOMES UNRECOVERABLE,                          
C  THE MESSAGE IS PRINTED AND EXECUTION STOPS.                          
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - ILLEGAL VALUE OF IROLD.                                        
C                                                                       
C/6S                                                                    
C     IF (IROLD.LT.1 .OR. IROLD.GT.2)                                   
C    1  CALL SETERR(31HRETSRC - ILLEGAL VALUE OF IROLD,31,1,2)          
C/7S                                                                    
      IF (IROLD.LT.1 .OR. IROLD.GT.2)                                   
     1  CALL SETERR('RETSRC - ILLEGAL VALUE OF IROLD',31,1,2)           
C/                                                                      
C                                                                       
      ITEMP=I8SAVE(2,IROLD,.TRUE.)                                      
C                                                                       
C  IF THE CURRENT ERROR IS NOW UNRECOVERABLE, PRINT AND STOP.           
C                                                                       
      IF (IROLD.EQ.1 .OR. I8SAVE(1,0,.FALSE.).EQ.0) RETURN              
C                                                                       
        CALL EPRINT                                                     
        STOP                                                            
C                                                                       
      END                                                               
      INTEGER FUNCTION I8TSEL(INOW)                                     
C                                                                       
C  TO RETURN I8TSEL = THE POINTER TO THE CURRENT ENTER-BLOCK AND        
C  SET THE CURRENT POINTER TO INOW.                                     
C                                                                       
C  START WITH NO BACK-POINTER.                                          
C                                                                       
      DATA IENTER/0/                                                    
C                                                                       
      I8TSEL=IENTER                                                     
      IF (INOW.GE.0) IENTER=INOW                                        
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      INTEGER FUNCTION ISTKQU(ITYPE)                                    
C                                                                       
C  RETURNS THE NUMBER OF ITEMS OF TYPE ITYPE THAT REMAIN                
C  TO BE ALLOCATED IN ONE REQUEST.                                      
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN                         
C    2 - ITYPE .LE. 0 .OR. ITYPE .GE. 6                                 
C                                                                       
      COMMON /CSTAK/DSTAK                                               
C                                                                       
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ISTAK(1000)                                               
      INTEGER ISIZE(5)                                                  
C                                                                       
      LOGICAL INIT                                                      
C                                                                       
      EQUIVALENCE (DSTAK(1),ISTAK(1))                                   
      EQUIVALENCE (ISTAK(2),LNOW)                                       
      EQUIVALENCE (ISTAK(3),LUSED)                                      
      EQUIVALENCE (ISTAK(4),LMAX)                                       
      EQUIVALENCE (ISTAK(5),LBOOK)                                      
      EQUIVALENCE (ISTAK(6),ISIZE(1))                                   
C                                                                       
      DATA INIT/.TRUE./                                                 
C                                                                       
      IF (INIT) CALL I0TK00(INIT,500,4)                                 
C                                                                       
C/6S                                                                    
C     IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR  
C    1   (47HISTKQU - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN,           
C    2    47,1,2)                                                       
C/7S                                                                    
      IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR  
     1   ('ISTKQU - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN',            
     2    47,1,2)                                                       
C/                                                                      
C                                                                       
C/6S                                                                    
C     IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR                         
C    1   (33HISTKQU - ITYPE.LE.0.OR.ITYPE.GE.6,33,2,2)                  
C/7S                                                                    
      IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR                         
     1   ('ISTKQU - ITYPE.LE.0.OR.ITYPE.GE.6',33,2,2)                   
C/                                                                      
C                                                                       
      ISTKQU = MAX0( ((LMAX-2)*ISIZE(2))/ISIZE(ITYPE)                   
     1             - (LNOW*ISIZE(2)-1)/ISIZE(ITYPE)                     
     2             - 1, 0 )                                             
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      INTEGER FUNCTION ISTKMD(NITEMS)                                   
C                                                                       
C  CHANGES THE LENGTH OF THE FRAME AT THE TOP OF THE STACK              
C  TO NITEMS.                                                           
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - LNOW OVERWRITTEN                                               
C    2 - ISTAK(LNOWO-1) OVERWRITTEN                                     
C                                                                       
      COMMON /CSTAK/DSTAK                                               
C                                                                       
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ISTAK(1000)                                               
C                                                                       
      EQUIVALENCE (DSTAK(1),ISTAK(1))                                   
      EQUIVALENCE (ISTAK(2),LNOW)                                       
C                                                                       
      LNOWO = LNOW                                                      
      CALL ISTKRL(1)                                                    
C                                                                       
      ITYPE = ISTAK(LNOWO-1)                                            
C                                                                       
C/6S                                                                    
C     IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR                         
C    1   (35HISTKMD - ISTAK(LNOWO-1) OVERWRITTEN,35,1,2)                
C/7S                                                                    
      IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR                         
     1   ('ISTKMD - ISTAK(LNOWO-1) OVERWRITTEN',35,1,2)                 
C/                                                                      
C                                                                       
      ISTKMD = ISTKGT(NITEMS,ITYPE)                                     
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE ISTKRL(NUMBER)                                         
C                                                                       
C  DE-ALLOCATES THE LAST (NUMBER) ALLOCATIONS MADE IN THE STACK         
C  BY ISTKGT.                                                           
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - NUMBER .LT. 0                                                  
C    2 - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN                         
C    3 - ATTEMPT TO DE-ALLOCATE NON-EXISTENT ALLOCATION                 
C    4 - THE POINTER AT ISTAK(LNOW) OVERWRITTEN                         
C                                                                       
      COMMON /CSTAK/DSTAK                                               
C                                                                       
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ISTAK(1000)                                               
      LOGICAL INIT                                                      
C                                                                       
      EQUIVALENCE (DSTAK(1),ISTAK(1))                                   
      EQUIVALENCE (ISTAK(1),LOUT)                                       
      EQUIVALENCE (ISTAK(2),LNOW)                                       
      EQUIVALENCE (ISTAK(3),LUSED)                                      
      EQUIVALENCE (ISTAK(4),LMAX)                                       
      EQUIVALENCE (ISTAK(5),LBOOK)                                      
C                                                                       
      DATA INIT/.TRUE./                                                 
C                                                                       
      IF (INIT) CALL I0TK00(INIT,500,4)                                 
C                                                                       
C/6S                                                                    
C     IF (NUMBER.LT.0) CALL SETERR(20HISTKRL - NUMBER.LT.0,20,1,2)      
C/7S                                                                    
      IF (NUMBER.LT.0) CALL SETERR('ISTKRL - NUMBER.LT.0',20,1,2)       
C/                                                                      
C                                                                       
C/6S                                                                    
C     IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR  
C    1   (47HISTKRL - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN,           
C    2    47,2,2)                                                       
C/7S                                                                    
      IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR  
     1   ('ISTKRL - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN',            
     2    47,2,2)                                                       
C/                                                                      
C                                                                       
      IN = NUMBER                                                       
 10      IF (IN.EQ.0) RETURN                                            
C                                                                       
C/6S                                                                    
C        IF (LNOW.LE.LBOOK) CALL SETERR                                 
C    1   (55HISTKRL - ATTEMPT TO DE-ALLOCATE NON-EXISTENT ALLOCATION,   
C    2    55,3,2)                                                       
C/7S                                                                    
         IF (LNOW.LE.LBOOK) CALL SETERR                                 
     1   ('ISTKRL - ATTEMPT TO DE-ALLOCATE NON-EXISTENT ALLOCATION',    
     2    55,3,2)                                                       
C/                                                                      
C                                                                       
C     CHECK TO MAKE SURE THE BACK POINTERS ARE MONOTONE.                
C                                                                       
C/6S                                                                    
C        IF (ISTAK(LNOW).LT.LBOOK.OR.ISTAK(LNOW).GE.LNOW-1) CALL SETERR 
C    1   (47HISTKRL - THE POINTER AT ISTAK(LNOW) OVERWRITTEN,           
C    2    47,4,2)                                                       
C/7S                                                                    
         IF (ISTAK(LNOW).LT.LBOOK.OR.ISTAK(LNOW).GE.LNOW-1) CALL SETERR 
     1   ('ISTKRL - THE POINTER AT ISTAK(LNOW) OVERWRITTEN',            
     2    47,4,2)                                                       
C/                                                                      
C                                                                       
         LOUT = LOUT-1                                                  
         LNOW = ISTAK(LNOW)                                             
         IN = IN-1                                                      
         GO TO 10                                                       
C                                                                       
      END                                                               
      INTEGER FUNCTION ISTKGT(NITEMS,ITYPE)                             
C                                                                       
C  ALLOCATES SPACE OUT OF THE INTEGER ARRAY ISTAK (IN COMMON            
C  BLOCK CSTAK) FOR AN ARRAY OF LENGTH NITEMS AND OF TYPE               
C  DETERMINED BY ITYPE AS FOLLOWS                                       
C                                                                       
C    1 - LOGICAL                                                        
C    2 - INTEGER                                                        
C    3 - REAL                                                           
C    4 - DOUBLE PRECISION                                               
C    5 - COMPLEX                                                        
C                                                                       
C  ON RETURN, THE ARRAY WILL OCCUPY                                     
C                                                                       
C    STAK(ISTKGT), STAK(ISTKGT+1), ..., STAK(ISTKGT-NITEMS+1)           
C                                                                       
C  WHERE STAK IS AN ARRAY OF TYPE ITYPE EQUIVALENCED TO ISTAK.          
C                                                                       
C  (FOR THOSE WANTING TO MAKE MACHINE DEPENDENT MODIFICATIONS           
C  TO SUPPORT OTHER TYPES, CODES 6,7,8,9,10,11 AND 12 HAVE              
C  BEEN RESERVED FOR 1/4 LOGICAL, 1/2 LOGICAL, 1/4 INTEGER,             
C  1/2 INTEGER, QUAD PRECISION, DOUBLE COMPLEX AND QUAD                 
C  COMPLEX, RESPECTIVELY.)                                              
C                                                                       
C  THE ALLOCATOR RESERVES THE FIRST TEN INTEGER WORDS OF THE STACK      
C  FOR ITS OWN INTERNAL BOOK-KEEPING. THESE ARE INITIALIZED BY          
C  THE INITIALIZING SUBPROGRAM I0TK00 UPON THE FIRST CALL               
C  TO A SUBPROGRAM IN THE ALLOCATION PACKAGE.                           
C                                                                       
C  THE USE OF THE FIRST FIVE WORDS IS DESCRIBED BELOW.                  
C                                                                       
C    ISTAK( 1) - LOUT,  THE NUMBER OF CURRENT ALLOCATIONS.              
C    ISTAK( 2) - LNOW,  THE CURRENT ACTIVE LENGTH OF THE STACK.         
C    ISTAK( 3) - LUSED, THE MAXIMUM VALUE OF ISTAK(2) ACHIEVED.         
C    ISTAK( 4) - LMAX,  THE MAXIMUM LENGTH THE STACK.                   
C    ISTAK( 5) - LBOOK, THE NUMBER OF WORDS USED FOR BOOKEEPING.        
C                                                                       
C  THE NEXT FIVE WORDS CONTAIN INTEGERS DESCRIBING THE AMOUNT           
C  OF STORAGE ALLOCATED BY THE FORTRAN SYSTEM TO THE VARIOUS            
C  DATA TYPES.  THE UNIT OF MEASUREMENT IS ARBITRARY AND MAY            
C  BE WORDS, BYTES OR BITS OR WHATEVER IS CONVENIENT.  THE              
C  VALUES CURRENTLY ASSUMED CORRESPOND TO AN ANS FORTRAN                
C  ENVIRONMENT.  FOR SOME MINI-COMPUTER SYSTEMS THE VALUES MAY          
C  HAVE TO BE CHANGED (SEE I0TK00).                                     
C                                                                       
C    ISTAK( 6) - THE NUMBER OF UNITS ALLOCATED TO LOGICAL               
C    ISTAK( 7) - THE NUMBER OF UNITS ALLOCATED TO INTEGER               
C    ISTAK( 8) - THE NUMBER OF UNITS ALLOCATED TO REAL                  
C    ISTAK( 9) - THE NUMBER OF UNITS ALLOCATED TO DOUBLE PRECISION      
C    ISTAK(10) - THE NUMBER OF UNITS ALLOCATED TO COMPLEX               
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - NITEMS .LT. 0                                                  
C    2 - ITYPE .LE. 0 .OR. ITYPE .GE. 6                                 
C    3 - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN                         
C    4 - STACK OVERFLOW                                                 
C                                                                       
      COMMON /CSTAK/DSTAK                                               
C                                                                       
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ISTAK(1000)                                               
      INTEGER ISIZE(5)                                                  
C                                                                       
      LOGICAL INIT                                                      
C                                                                       
      EQUIVALENCE (DSTAK(1),ISTAK(1))                                   
      EQUIVALENCE (ISTAK(1),LOUT)                                       
      EQUIVALENCE (ISTAK(2),LNOW)                                       
      EQUIVALENCE (ISTAK(3),LUSED)                                      
      EQUIVALENCE (ISTAK(4),LMAX)                                       
      EQUIVALENCE (ISTAK(5),LBOOK)                                      
      EQUIVALENCE (ISTAK(6),ISIZE(1))                                   
C                                                                       
      DATA INIT/.TRUE./                                                 
C                                                                       
      IF (INIT) CALL I0TK00(INIT,500,4)                                 
C                                                                       
C/6S                                                                    
C     IF (NITEMS.LT.0) CALL SETERR(20HISTKGT - NITEMS.LT.0,20,1,2)      
C/7S                                                                    
      IF (NITEMS.LT.0) CALL SETERR('ISTKGT - NITEMS.LT.0',20,1,2)       
C/                                                                      
C                                                                       
C/6S                                                                    
C     IF (ITYPE.LE.0 .OR. ITYPE.GE.6) CALL SETERR                       
C    1   (33HISTKGT - ITYPE.LE.0.OR.ITYPE.GE.6,33,2,2)                  
C/7S                                                                    
      IF (ITYPE.LE.0 .OR. ITYPE.GE.6) CALL SETERR                       
     1   ('ISTKGT - ITYPE.LE.0.OR.ITYPE.GE.6',33,2,2)                   
C/                                                                      
C                                                                       
C/6S                                                                    
C     IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR  
C    1   (47HISTKGT - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN,           
C    2    47,3,2)                                                       
C/7S                                                                    
      IF (LNOW.LT.LBOOK.OR.LNOW.GT.LUSED.OR.LUSED.GT.LMAX) CALL SETERR  
     1   ('ISTKGT - LNOW, LUSED, LMAX OR LBOOK OVERWRITTEN',            
     2    47,3,2)                                                       
C/                                                                      
C                                                                       
      ISTKGT = (LNOW*ISIZE(2)-1)/ISIZE(ITYPE) + 2                       
      I = ( (ISTKGT-1+NITEMS)*ISIZE(ITYPE) - 1 )/ISIZE(2) + 3           
C                                                                       
C  STACK OVERFLOW IS AN UNRECOVERABLE ERROR.                            
C                                                                       
C/6S                                                                    
C     IF (I.GT.LMAX) CALL SETERR(69HISTKGT - STACK TOO SHORT. ENLARGE IT
C    1 AND CALL ISTKIN IN MAIN PROGRAM.,69,4,2)                         
C/7S                                                                    
      IF (I.GT.LMAX) CALL SETERR('ISTKGT - STACK TOO SHORT. ENLARGE IT A
     *ND CALL ISTKIN IN MAIN PROGRAM.',69,4,2)                          
C/                                                                      
C                                                                       
C  ISTAK(I-1) CONTAINS THE TYPE FOR THIS ALLOCATION.                    
C  ISTAK(I  ) CONTAINS A POINTER TO THE END OF THE PREVIOUS             
C             ALLOCATION.                                               
C                                                                       
      ISTAK(I-1) = ITYPE                                                
      ISTAK(I  ) = LNOW                                                 
      LOUT = LOUT+1                                                     
      LNOW = I                                                          
      LUSED = MAX0(LUSED,LNOW)                                          
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE ISTKIN(NITEMS,ITYPE)                                   
C                                                                       
C  INITIALIZES THE STACK ALLOCATOR, SETTING THE LENGTH OF THE STACK.    
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - NITEMS .LE. 0                                                  
C    2 - ITYPE .LE. 0 .OR. ITYPE .GE. 6                                 
C                                                                       
      LOGICAL INIT                                                      
C                                                                       
      DATA INIT/.TRUE./                                                 
C                                                                       
C/6S                                                                    
C     IF (NITEMS.LE.0) CALL SETERR(20HISTKIN - NITEMS.LE.0,20,1,2)      
C/7S                                                                    
      IF (NITEMS.LE.0) CALL SETERR('ISTKIN - NITEMS.LE.0',20,1,2)       
C/                                                                      
C                                                                       
C/6S                                                                    
C     IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR                         
C    1   (33HISTKIN - ITYPE.LE.0.OR.ITYPE.GE.6,33,2,2)                  
C/7S                                                                    
      IF (ITYPE.LE.0.OR.ITYPE.GE.6) CALL SETERR                         
     1   ('ISTKIN - ITYPE.LE.0.OR.ITYPE.GE.6',33,2,2)                   
C/                                                                      
C                                                                       
      IF (INIT) CALL I0TK00(INIT,NITEMS,ITYPE)                          
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      INTEGER FUNCTION ISTKST(NFACT)                                    
C                                                                       
C  RETURNS CONTROL INFORMATION AS FOLLOWS                               
C                                                                       
C  NFACT    ITEM RETURNED                                               
C                                                                       
C    1         LOUT,  THE NUMBER OF CURRENT ALLOCATIONS                 
C    2         LNOW,  THE CURRENT ACTIVE LENGTH                         
C    3         LUSED, THE MAXIMUM USED                                  
C    4         LMAX,  THE MAXIMUM ALLOWED                               
C                                                                       
      COMMON /CSTAK/DSTAK                                               
C                                                                       
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ISTAK(1000)                                               
      INTEGER ISTATS(4)                                                 
      LOGICAL INIT                                                      
C                                                                       
      EQUIVALENCE (DSTAK(1),ISTAK(1))                                   
      EQUIVALENCE (ISTAK(1),ISTATS(1))                                  
C                                                                       
      DATA INIT/.TRUE./                                                 
C                                                                       
      IF (INIT) CALL I0TK00(INIT,500,4)                                 
C                                                                       
C/6S                                                                    
C     IF (NFACT.LE.0.OR.NFACT.GE.5) CALL SETERR                         
C    1   (33HISTKST - NFACT.LE.0.OR.NFACT.GE.5,33,1,2)                  
C/7S                                                                    
      IF (NFACT.LE.0.OR.NFACT.GE.5) CALL SETERR                         
     1   ('ISTKST - NFACT.LE.0.OR.NFACT.GE.5',33,1,2)                   
C/                                                                      
C                                                                       
      ISTKST = ISTATS(NFACT)                                            
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      REAL FUNCTION R1MACH(I)                                           
C                                                                       
C  SINGLE-PRECISION MACHINE CONSTANTS                                   
C                                                                       
C  R1MACH(1) = B**(EMIN-1), THE SMALLEST POSITIVE MAGNITUDE.            
C                                                                       
C  R1MACH(2) = B**EMAX*(1 - B**(-T)), THE LARGEST MAGNITUDE.            
C                                                                       
C  R1MACH(3) = B**(-T), THE SMALLEST RELATIVE SPACING.                  
C                                                                       
C  R1MACH(4) = B**(1-T), THE LARGEST RELATIVE SPACING.                  
C                                                                       
C  R1MACH(5) = LOG10(B)                                                 
C                                                                       
C  TO ALTER THIS FUNCTION FOR A PARTICULAR ENVIRONMENT,                 
C  THE DESIRED SET OF DATA STATEMENTS SHOULD BE ACTIVATED BY            
C  REMOVING THE C FROM COLUMN 1.                                        
C                                                                       
C  FOR IEEE-ARITHMETIC MACHINES (BINARY STANDARD), THE FIRST            
C  SET OF CONSTANTS BELOW SHOULD BE APPROPRIATE.                        
C                                                                       
C  WHERE POSSIBLE, DECIMAL, OCTAL OR HEXADECIMAL CONSTANTS ARE USED     
C  TO SPECIFY THE CONSTANTS EXACTLY.  SOMETIMES THIS REQUIRES USING     
C  EQUIVALENT INTEGER ARRAYS.  IF YOUR COMPILER USES HALF-WORD          
C  INTEGERS BY DEFAULT (SOMETIMES CALLED INTEGER*2), YOU MAY NEED TO    
C  CHANGE INTEGER TO INTEGER*4 OR OTHERWISE INSTRUCT YOUR COMPILER      
C  TO USE FULL-WORD INTEGERS IN THE NEXT 5 DECLARATIONS.                
C                                                                       
      INTEGER SMALL(2)                                                  
      INTEGER LARGE(2)                                                  
      INTEGER RIGHT(2)                                                  
      INTEGER DIVER(2)                                                  
      INTEGER LOG10(2)                                                  
      INTEGER SC                                                        
C                                                                       
      REAL RMACH(5)                                                     
C                                                                       
      EQUIVALENCE (RMACH(1),SMALL(1))                                   
      EQUIVALENCE (RMACH(2),LARGE(1))                                   
      EQUIVALENCE (RMACH(3),RIGHT(1))                                   
      EQUIVALENCE (RMACH(4),DIVER(1))                                   
      EQUIVALENCE (RMACH(5),LOG10(1))                                   
C                                                                       
C     MACHINE CONSTANTS FOR IEEE ARITHMETIC MACHINES, SUCH AS THE AT&T  
C     3B SERIES, MOTOROLA 68000 BASED MACHINES (E.G. SUN 3 AND AT&T     
C     PC 7300), AND 8087 BASED MICROS (E.G. IBM PC AND AT&T 6300).      
C                                                                       
C      DATA SMALL(1) /     8388608 /                                    
C      DATA LARGE(1) /  2139095039 /                                    
C      DATA RIGHT(1) /   864026624 /                                    
C      DATA DIVER(1) /   872415232 /                                    
C      DATA LOG10(1) /  1050288283 /, SC/987/                           
C                                                                       
C     MACHINE CONSTANTS FOR AMDAHL MACHINES.                            
C                                                                       
C      DATA SMALL(1) /    1048576 /                                     
C      DATA LARGE(1) / 2147483647 /                                     
C      DATA RIGHT(1) /  990904320 /                                     
C      DATA DIVER(1) / 1007681536 /                                     
C      DATA LOG10(1) / 1091781651 /, SC/987/                            
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM.                  
C                                                                       
C      DATA RMACH(1) / Z400800000 /                                     
C      DATA RMACH(2) / Z5FFFFFFFF /                                     
C      DATA RMACH(3) / Z4E9800000 /                                     
C      DATA RMACH(4) / Z4EA800000 /                                     
C      DATA RMACH(5) / Z500E730E8 /, SC/987/                            
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700/6700/7700 SYSTEMS.       
C                                                                       
C      DATA RMACH(1) / O1771000000000000 /                              
C      DATA RMACH(2) / O0777777777777777 /                              
C      DATA RMACH(3) / O1311000000000000 /                              
C      DATA RMACH(4) / O1301000000000000 /                              
C      DATA RMACH(5) / O1157163034761675 /, SC/987/                     
C                                                                       
C     MACHINE CONSTANTS FOR FTN4 ON THE CDC 6000/7000 SERIES.           
C                                                                       
C      DATA RMACH(1) / 00564000000000000000B /                          
C      DATA RMACH(2) / 37767777777777777776B /                          
C      DATA RMACH(3) / 16414000000000000000B /                          
C      DATA RMACH(4) / 16424000000000000000B /                          
C      DATA RMACH(5) / 17164642023241175720B /, SC/987/                 
C                                                                       
C     MACHINE CONSTANTS FOR FTN5 ON THE CDC 6000/7000 SERIES.           
C                                                                       
C      DATA RMACH(1) / O"00564000000000000000" /                        
C      DATA RMACH(2) / O"37767777777777777776" /                        
C      DATA RMACH(3) / O"16414000000000000000" /                        
C      DATA RMACH(4) / O"16424000000000000000" /                        
C      DATA RMACH(5) / O"17164642023241175720" /, SC/987/               
C                                                                       
C     MACHINE CONSTANTS FOR CONVEX C-1.                                 
C                                                                       
C      DATA RMACH(1) / '00800000'X /                                    
C      DATA RMACH(2) / '7FFFFFFF'X /                                    
C      DATA RMACH(3) / '34800000'X /                                    
C      DATA RMACH(4) / '35000000'X /                                    
C      DATA RMACH(5) / '3F9A209B'X /, SC/987/                           
C                                                                       
C     MACHINE CONSTANTS FOR THE CRAY 1, XMP, 2, AND 3.                  
C                                                                       
C      DATA RMACH(1) / 200034000000000000000B /                         
C      DATA RMACH(2) / 577767777777777777776B /                         
C      DATA RMACH(3) / 377224000000000000000B /                         
C      DATA RMACH(4) / 377234000000000000000B /                         
C      DATA RMACH(5) / 377774642023241175720B /, SC/987/                
C                                                                       
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200.             
C                                                                       
C     NOTE - IT MAY BE APPROPRIATE TO INCLUDE THE FOLLOWING LINE -      
C     STATIC RMACH(5)                                                   
C                                                                       
C      DATA SMALL/20K,0/,LARGE/77777K,177777K/                          
C      DATA RIGHT/35420K,0/,DIVER/36020K,0/                             
C      DATA LOG10/40423K,42023K/, SC/987/                               
C                                                                       
C     MACHINE CONSTANTS FOR THE HARRIS SLASH 6 AND SLASH 7.             
C                                                                       
C      DATA SMALL(1),SMALL(2) / '20000000, '00000201 /                  
C      DATA LARGE(1),LARGE(2) / '37777777, '00000177 /                  
C      DATA RIGHT(1),RIGHT(2) / '20000000, '00000352 /                  
C      DATA DIVER(1),DIVER(2) / '20000000, '00000353 /                  
C      DATA LOG10(1),LOG10(2) / '23210115, '00000377 /, SC/987/         
C                                                                       
C     MACHINE CONSTANTS FOR THE HONEYWELL DPS 8/70 SERIES.              
C                                                                       
C      DATA RMACH(1) / O402400000000 /                                  
C      DATA RMACH(2) / O376777777777 /                                  
C      DATA RMACH(3) / O714400000000 /                                  
C      DATA RMACH(4) / O716400000000 /                                  
C      DATA RMACH(5) / O776464202324 /, SC/987/                         
C                                                                       
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,                     
C     THE XEROX SIGMA 5/7/9 AND THE SEL SYSTEMS 85/86.                  
C                                                                       
C      DATA RMACH(1) / Z00100000 /                                      
C      DATA RMACH(2) / Z7FFFFFFF /                                      
C      DATA RMACH(3) / Z3B100000 /                                      
C      DATA RMACH(4) / Z3C100000 /                                      
C      DATA RMACH(5) / Z41134413 /, SC/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE INTERDATA 8/32                          
C     WITH THE UNIX SYSTEM FORTRAN 77 COMPILER.                         
C                                                                       
C     FOR THE INTERDATA FORTRAN VII COMPILER REPLACE                    
C     THE Z'S SPECIFYING HEX CONSTANTS WITH Y'S.                        
C                                                                       
C      DATA RMACH(1) / Z'00100000' /                                    
C      DATA RMACH(2) / Z'7EFFFFFF' /                                    
C      DATA RMACH(3) / Z'3B100000' /                                    
C      DATA RMACH(4) / Z'3C100000' /                                    
C      DATA RMACH(5) / Z'41134413' /, SC/987/                           
C                                                                       
C     MACHINE CONSTANTS FOR THE PDP-10 (KA OR KI PROCESSOR).            
C                                                                       
C      DATA RMACH(1) / "000400000000 /                                  
C      DATA RMACH(2) / "377777777777 /                                  
C      DATA RMACH(3) / "146400000000 /                                  
C      DATA RMACH(4) / "147400000000 /                                  
C      DATA RMACH(5) / "177464202324 /, SC/987/                         
C                                                                       
C     MACHINE CONSTANTS FOR PDP-11 FORTRANS SUPPORTING                  
C     32-BIT INTEGERS (EXPRESSED IN INTEGER AND OCTAL).                 
C                                                                       
C      DATA SMALL(1) /    8388608 /                                     
C      DATA LARGE(1) / 2147483647 /                                     
C      DATA RIGHT(1) /  880803840 /                                     
C      DATA DIVER(1) /  889192448 /                                     
C      DATA LOG10(1) / 1067065499 /, SC/987/                            
C                                                                       
C      DATA RMACH(1) / O00040000000 /                                   
C      DATA RMACH(2) / O17777777777 /                                   
C      DATA RMACH(3) / O06440000000 /                                   
C      DATA RMACH(4) / O06500000000 /                                   
C      DATA RMACH(5) / O07746420233 /, SC/987/                          
C                                                                       
C     MACHINE CONSTANTS FOR PDP-11 FORTRANS SUPPORTING                  
C     16-BIT INTEGERS  (EXPRESSED IN INTEGER AND OCTAL).                
C                                                                       
C      DATA SMALL(1),SMALL(2) /   128,     0 /                          
C      DATA LARGE(1),LARGE(2) / 32767,    -1 /                          
C      DATA RIGHT(1),RIGHT(2) / 13440,     0 /                          
C      DATA DIVER(1),DIVER(2) / 13568,     0 /                          
C      DATA LOG10(1),LOG10(2) / 16282,  8347 /, SC/987/                 
C                                                                       
C      DATA SMALL(1),SMALL(2) / O000200, O000000 /                      
C      DATA LARGE(1),LARGE(2) / O077777, O177777 /                      
C      DATA RIGHT(1),RIGHT(2) / O032200, O000000 /                      
C      DATA DIVER(1),DIVER(2) / O032400, O000000 /                      
C      DATA LOG10(1),LOG10(2) / O037632, O020233 /, SC/987/             
C                                                                       
C     MACHINE CONSTANTS FOR THE SEQUENT BALANCE 8000.                   
C                                                                       
C      DATA SMALL(1) / $00800000 /                                      
C      DATA LARGE(1) / $7F7FFFFF /                                      
C      DATA RIGHT(1) / $33800000 /                                      
C      DATA DIVER(1) / $34000000 /                                      
C      DATA LOG10(1) / $3E9A209B /, SC/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES.                     
C                                                                       
C      DATA RMACH(1) / O000400000000 /                                  
C      DATA RMACH(2) / O377777777777 /                                  
C      DATA RMACH(3) / O146400000000 /                                  
C      DATA RMACH(4) / O147400000000 /                                  
C      DATA RMACH(5) / O177464202324 /, SC/987/                         
C                                                                       
C     MACHINE CONSTANTS FOR THE VAX UNIX F77 COMPILER.                  
C                                                                       
C      DATA SMALL(1) /       128 /                                      
C      DATA LARGE(1) /    -32769 /                                      
C      DATA RIGHT(1) /     13440 /                                      
C      DATA DIVER(1) /     13568 /                                      
C      DATA LOG10(1) / 547045274 /, SC/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE VAX-11 WITH                             
C     FORTRAN IV-PLUS COMPILER.                                         
C                                                                       
C      DATA RMACH(1) / Z00000080 /                                      
C      DATA RMACH(2) / ZFFFF7FFF /                                      
C      DATA RMACH(3) / Z00003480 /                                      
C      DATA RMACH(4) / Z00003500 /                                      
C      DATA RMACH(5) / Z209B3F9A /, SC/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR VAX/VMS VERSION 2.2.                        
C                                                                       
       DATA RMACH(1) /       '80'X /                                    
       DATA RMACH(2) / 'FFFF7FFF'X /                                    
       DATA RMACH(3) /     '3480'X /                                    
       DATA RMACH(4) /     '3500'X /                                    
       DATA RMACH(5) / '209B3F9A'X /, SC/987/                           
                                                                        
C  ***  ISSUE STOP 778 IF ALL DATA STATEMENTS ARE COMMENTED...          
      IF (SC .NE. 987) STOP 778                                         
C/6S                                                                    
C     IF (I .LT. 1  .OR.  I .GT. 5)                                     
C    1   CALL SETERR(24HR1MACH - I OUT OF BOUNDS,24,1,2)                
C/7S                                                                    
      IF (I .LT. 1  .OR.  I .GT. 5)                                     
     1   CALL SETERR('R1MACH - I OUT OF BOUNDS',24,1,2)                 
C/                                                                      
C                                                                       
      R1MACH = RMACH(I)                                                 
      RETURN                                                            
C                                                                       
      END                                                               
      DOUBLE PRECISION FUNCTION D1MACH(I)                               
C                                                                       
C  DOUBLE-PRECISION MACHINE CONSTANTS                                   
C                                                                       
C  D1MACH( 1) = B**(EMIN-1), THE SMALLEST POSITIVE MAGNITUDE.           
C                                                                       
C  D1MACH( 2) = B**EMAX*(1 - B**(-T)), THE LARGEST MAGNITUDE.           
C                                                                       
C  D1MACH( 3) = B**(-T), THE SMALLEST RELATIVE SPACING.                 
C                                                                       
C  D1MACH( 4) = B**(1-T), THE LARGEST RELATIVE SPACING.                 
C                                                                       
C  D1MACH( 5) = LOG10(B)                                                
C                                                                       
C  TO ALTER THIS FUNCTION FOR A PARTICULAR ENVIRONMENT,                 
C  THE DESIRED SET OF DATA STATEMENTS SHOULD BE ACTIVATED BY            
C  REMOVING THE C FROM COLUMN 1.                                        
C                                                                       
C  FOR IEEE-ARITHMETIC MACHINES (BINARY STANDARD), ONE OF THE FIRST     
C  TWO SETS OF CONSTANTS BELOW SHOULD BE APPROPRIATE.                   
C                                                                       
C  WHERE POSSIBLE, DECIMAL, OCTAL OR HEXADECIMAL CONSTANTS ARE USED     
C  TO SPECIFY THE CONSTANTS EXACTLY.  SOMETIMES THIS REQUIRES USING     
C  EQUIVALENT INTEGER ARRAYS.  IF YOUR COMPILER USES HALF-WORD          
C  INTEGERS BY DEFAULT (SOMETIMES CALLED INTEGER*2), YOU MAY NEED TO    
C  CHANGE INTEGER TO INTEGER*4 OR OTHERWISE INSTRUCT YOUR COMPILER      
C  TO USE FULL-WORD INTEGERS IN THE NEXT 5 DECLARATIONS.                
C                                                                       
      INTEGER SMALL(4)                                                  
      INTEGER LARGE(4)                                                  
      INTEGER RIGHT(4)                                                  
      INTEGER DIVER(4)                                                  
      INTEGER LOG10(4)                                                  
      INTEGER SC                                                        
C                                                                       
      DOUBLE PRECISION DMACH(5)                                         
C                                                                       
      EQUIVALENCE (DMACH(1),SMALL(1))                                   
      EQUIVALENCE (DMACH(2),LARGE(1))                                   
      EQUIVALENCE (DMACH(3),RIGHT(1))                                   
      EQUIVALENCE (DMACH(4),DIVER(1))                                   
      EQUIVALENCE (DMACH(5),LOG10(1))                                   
C                                                                       
C     MACHINE CONSTANTS FOR IEEE ARITHMETIC MACHINES, SUCH AS THE AT&T  
C     3B SERIES AND MOTOROLA 68000 BASED MACHINES (E.G. SUN 3 AND AT&T  
C     PC 7300), IN WHICH THE MOST SIGNIFICANT BYTE IS STORED FIRST.     
C                                                                       
C      DATA SMALL(1),SMALL(2) /    1048576,          0 /                
C      DATA LARGE(1),LARGE(2) / 2146435071,         -1 /                
C      DATA RIGHT(1),RIGHT(2) / 1017118720,          0 /                
C      DATA DIVER(1),DIVER(2) / 1018167296,          0 /                
C      DATA LOG10(1),LOG10(2) / 1070810131, 1352628735 /, SC/987/       
C                                                                       
C     MACHINE CONSTANTS FOR IEEE ARITHMETIC MACHINES AND 8087-BASED     
C     MICROS, SUCH AS THE IBM PC AND AT&T 6300, IN WHICH THE LEAST      
C     SIGNIFICANT BYTE IS STORED FIRST.                                 
C                                                                       
      DATA SMALL(1),SMALL(2) /          0,    1048576 /                
      DATA LARGE(1),LARGE(2) /         -1, 2146435071 /                
      DATA RIGHT(1),RIGHT(2) /          0, 1017118720 /                
      DATA DIVER(1),DIVER(2) /          0, 1018167296 /                
      DATA LOG10(1),LOG10(2) / 1352628735, 1070810131 /, SC/987/       
C                                                                       
C     MACHINE CONSTANTS FOR AMDAHL MACHINES.                            
C                                                                       
C      DATA SMALL(1),SMALL(2) /    1048576,          0 /                
C      DATA LARGE(1),LARGE(2) / 2147483647,         -1 /                
C      DATA RIGHT(1),RIGHT(2) /  856686592,          0 /                
C      DATA DIVER(1),DIVER(2) /  873463808,          0 /                
C      DATA LOG10(1),LOG10(2) / 1091781651, 1352628735 /, SC/987/       
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM.                  
C                                                                       
C      DATA SMALL(1) / ZC00800000 /                                     
C      DATA SMALL(2) / Z000000000 /                                     
C                                                                       
C      DATA LARGE(1) / ZDFFFFFFFF /                                     
C      DATA LARGE(2) / ZFFFFFFFFF /                                     
C                                                                       
C      DATA RIGHT(1) / ZCC5800000 /                                     
C      DATA RIGHT(2) / Z000000000 /                                     
C                                                                       
C      DATA DIVER(1) / ZCC6800000 /                                     
C      DATA DIVER(2) / Z000000000 /                                     
C                                                                       
C      DATA LOG10(1) / ZD00E730E7 /                                     
C      DATA LOG10(2) / ZC77800DC0 /, SC/987/                            
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700 SYSTEM.                  
C                                                                       
C      DATA SMALL(1) / O1771000000000000 /                              
C      DATA SMALL(2) / O0000000000000000 /                              
C                                                                       
C      DATA LARGE(1) / O0777777777777777 /                              
C      DATA LARGE(2) / O0007777777777777 /                              
C                                                                       
C      DATA RIGHT(1) / O1461000000000000 /                              
C      DATA RIGHT(2) / O0000000000000000 /                              
C                                                                       
C      DATA DIVER(1) / O1451000000000000 /                              
C      DATA DIVER(2) / O0000000000000000 /                              
C                                                                       
C      DATA LOG10(1) / O1157163034761674 /                              
C      DATA LOG10(2) / O0006677466732724 /, SC/987/                     
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 6700/7700 SYSTEMS.            
C                                                                       
C      DATA SMALL(1) / O1771000000000000 /                              
C      DATA SMALL(2) / O7770000000000000 /                              
C                                                                       
C      DATA LARGE(1) / O0777777777777777 /                              
C      DATA LARGE(2) / O7777777777777777 /                              
C                                                                       
C      DATA RIGHT(1) / O1461000000000000 /                              
C      DATA RIGHT(2) / O0000000000000000 /                              
C                                                                       
C      DATA DIVER(1) / O1451000000000000 /                              
C      DATA DIVER(2) / O0000000000000000 /                              
C                                                                       
C      DATA LOG10(1) / O1157163034761674 /                              
C      DATA LOG10(2) / O0006677466732724 /, SC/987/                     
C                                                                       
C     MACHINE CONSTANTS FOR FTN4 ON THE CDC 6000/7000 SERIES.           
C                                                                       
C      DATA SMALL(1) / 00564000000000000000B /                          
C      DATA SMALL(2) / 00000000000000000000B /                          
C                                                                       
C      DATA LARGE(1) / 37757777777777777777B /                          
C      DATA LARGE(2) / 37157777777777777774B /                          
C                                                                       
C      DATA RIGHT(1) / 15624000000000000000B /                          
C      DATA RIGHT(2) / 00000000000000000000B /                          
C                                                                       
C      DATA DIVER(1) / 15634000000000000000B /                          
C      DATA DIVER(2) / 00000000000000000000B /                          
C                                                                       
C      DATA LOG10(1) / 17164642023241175717B /                          
C      DATA LOG10(2) / 16367571421742254654B /, SC/987/                 
C                                                                       
C     MACHINE CONSTANTS FOR FTN5 ON THE CDC 6000/7000 SERIES.           
C                                                                       
C      DATA SMALL(1) / O"00564000000000000000" /                        
C      DATA SMALL(2) / O"00000000000000000000" /                        
C                                                                       
C      DATA LARGE(1) / O"37757777777777777777" /                        
C      DATA LARGE(2) / O"37157777777777777774" /                        
C                                                                       
C      DATA RIGHT(1) / O"15624000000000000000" /                        
C      DATA RIGHT(2) / O"00000000000000000000" /                        
C                                                                       
C      DATA DIVER(1) / O"15634000000000000000" /                        
C      DATA DIVER(2) / O"00000000000000000000" /                        
C                                                                       
C      DATA LOG10(1) / O"17164642023241175717" /                        
C      DATA LOG10(2) / O"16367571421742254654" /, SC/987/               
C                                                                       
C     MACHINE CONSTANTS FOR CONVEX C-1                                  
C                                                                       
C      DATA SMALL(1),SMALL(2) / '00100000'X, '00000000'X /              
C      DATA LARGE(1),LARGE(2) / '7FFFFFFF'X, 'FFFFFFFF'X /              
C      DATA RIGHT(1),RIGHT(2) / '3CC00000'X, '00000000'X /              
C      DATA DIVER(1),DIVER(2) / '3CD00000'X, '00000000'X /              
C      DATA LOG10(1),LOG10(2) / '3FF34413'X, '509F79FF'X /, SC/987/     
C                                                                       
C     MACHINE CONSTANTS FOR THE CRAY 1, XMP, 2, AND 3.                  
C                                                                       
C      DATA SMALL(1) / 201354000000000000000B /                         
C      DATA SMALL(2) / 000000000000000000000B /                         
C                                                                       
C      DATA LARGE(1) / 577767777777777777777B /                         
C      DATA LARGE(2) / 000007777777777777776B /                         
C                                                                       
C      DATA RIGHT(1) / 376434000000000000000B /                         
C      DATA RIGHT(2) / 000000000000000000000B /                         
C                                                                       
C      DATA DIVER(1) / 376444000000000000000B /                         
C      DATA DIVER(2) / 000000000000000000000B /                         
C                                                                       
C      DATA LOG10(1) / 377774642023241175717B /                         
C      DATA LOG10(2) / 000007571421742254654B /, SC/987/                
C                                                                       
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200              
C                                                                       
C     NOTE - IT MAY BE APPROPRIATE TO INCLUDE THE FOLLOWING LINE -      
C     STATIC DMACH(5)                                                   
C                                                                       
C      DATA SMALL/20K,3*0/,LARGE/77777K,3*177777K/                      
C      DATA RIGHT/31420K,3*0/,DIVER/32020K,3*0/                         
C      DATA LOG10/40423K,42023K,50237K,74776K/, SC/987/                 
C                                                                       
C     MACHINE CONSTANTS FOR THE HARRIS SLASH 6 AND SLASH 7              
C                                                                       
C      DATA SMALL(1),SMALL(2) / '20000000, '00000201 /                  
C      DATA LARGE(1),LARGE(2) / '37777777, '37777577 /                  
C      DATA RIGHT(1),RIGHT(2) / '20000000, '00000333 /                  
C      DATA DIVER(1),DIVER(2) / '20000000, '00000334 /                  
C      DATA LOG10(1),LOG10(2) / '23210115, '10237777 /, SC/987/         
C                                                                       
C     MACHINE CONSTANTS FOR THE HONEYWELL DPS 8/70 SERIES.              
C                                                                       
C      DATA SMALL(1),SMALL(2) / O402400000000, O000000000000 /          
C      DATA LARGE(1),LARGE(2) / O376777777777, O777777777777 /          
C      DATA RIGHT(1),RIGHT(2) / O604400000000, O000000000000 /          
C      DATA DIVER(1),DIVER(2) / O606400000000, O000000000000 /          
C      DATA LOG10(1),LOG10(2) / O776464202324, O117571775714 /, SC/987/ 
C                                                                       
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,                     
C     THE XEROX SIGMA 5/7/9 AND THE SEL SYSTEMS 85/86.                  
C                                                                       
C      DATA SMALL(1),SMALL(2) / Z00100000, Z00000000 /                  
C      DATA LARGE(1),LARGE(2) / Z7FFFFFFF, ZFFFFFFFF /                  
C      DATA RIGHT(1),RIGHT(2) / Z33100000, Z00000000 /                  
C      DATA DIVER(1),DIVER(2) / Z34100000, Z00000000 /                  
C      DATA LOG10(1),LOG10(2) / Z41134413, Z509F79FF /, SC/987/         
C                                                                       
C     MACHINE CONSTANTS FOR THE INTERDATA 8/32                          
C     WITH THE UNIX SYSTEM FORTRAN 77 COMPILER.                         
C                                                                       
C     FOR THE INTERDATA FORTRAN VII COMPILER REPLACE                    
C     THE Z'S SPECIFYING HEX CONSTANTS WITH Y'S.                        
C                                                                       
C      DATA SMALL(1),SMALL(2) / Z'00100000', Z'00000000' /              
C      DATA LARGE(1),LARGE(2) / Z'7EFFFFFF', Z'FFFFFFFF' /              
C      DATA RIGHT(1),RIGHT(2) / Z'33100000', Z'00000000' /              
C      DATA DIVER(1),DIVER(2) / Z'34100000', Z'00000000' /              
C      DATA LOG10(1),LOG10(2) / Z'41134413', Z'509F79FF' /, SC/987/     
C                                                                       
C     MACHINE CONSTANTS FOR THE PDP-10 (KA PROCESSOR).                  
C                                                                       
C      DATA SMALL(1),SMALL(2) / "033400000000, "000000000000 /          
C      DATA LARGE(1),LARGE(2) / "377777777777, "344777777777 /          
C      DATA RIGHT(1),RIGHT(2) / "113400000000, "000000000000 /          
C      DATA DIVER(1),DIVER(2) / "114400000000, "000000000000 /          
C      DATA LOG10(1),LOG10(2) / "177464202324, "144117571776 /, SC/987/ 
C                                                                       
C     MACHINE CONSTANTS FOR THE PDP-10 (KI PROCESSOR).                  
C                                                                       
C      DATA SMALL(1),SMALL(2) / "000400000000, "000000000000 /          
C      DATA LARGE(1),LARGE(2) / "377777777777, "377777777777 /          
C      DATA RIGHT(1),RIGHT(2) / "103400000000, "000000000000 /          
C      DATA DIVER(1),DIVER(2) / "104400000000, "000000000000 /          
C      DATA LOG10(1),LOG10(2) / "177464202324, "047674776746 /, SC/987/ 
C                                                                       
C     MACHINE CONSTANTS FOR PDP-11 FORTRANS SUPPORTING                  
C     32-BIT INTEGERS (EXPRESSED IN INTEGER AND OCTAL).                 
C                                                                       
C      DATA SMALL(1),SMALL(2) /    8388608,           0 /               
C      DATA LARGE(1),LARGE(2) / 2147483647,          -1 /               
C      DATA RIGHT(1),RIGHT(2) /  612368384,           0 /               
C      DATA DIVER(1),DIVER(2) /  620756992,           0 /               
C      DATA LOG10(1),LOG10(2) / 1067065498, -2063872008 /, SC/987/      
C                                                                       
C      DATA SMALL(1),SMALL(2) / O00040000000, O00000000000 /            
C      DATA LARGE(1),LARGE(2) / O17777777777, O37777777777 /            
C      DATA RIGHT(1),RIGHT(2) / O04440000000, O00000000000 /            
C      DATA DIVER(1),DIVER(2) / O04500000000, O00000000000 /            
C      DATA LOG10(1),LOG10(2) / O07746420232, O20476747770 /, SC/987/   
C                                                                       
C     MACHINE CONSTANTS FOR PDP-11 FORTRANS SUPPORTING                  
C     16-BIT INTEGERS (EXPRESSED IN INTEGER AND OCTAL).                 
C                                                                       
C      DATA SMALL(1),SMALL(2) /    128,      0 /                        
C      DATA SMALL(3),SMALL(4) /      0,      0 /                        
C                                                                       
C      DATA LARGE(1),LARGE(2) /  32767,     -1 /                        
C      DATA LARGE(3),LARGE(4) /     -1,     -1 /                        
C                                                                       
C      DATA RIGHT(1),RIGHT(2) /   9344,      0 /                        
C      DATA RIGHT(3),RIGHT(4) /      0,      0 /                        
C                                                                       
C      DATA DIVER(1),DIVER(2) /   9472,      0 /                        
C      DATA DIVER(3),DIVER(4) /      0,      0 /                        
C                                                                       
C      DATA LOG10(1),LOG10(2) /  16282,   8346 /                        
C      DATA LOG10(3),LOG10(4) / -31493, -12296 /, SC/987/               
C                                                                       
C      DATA SMALL(1),SMALL(2) / O000200, O000000 /                      
C      DATA SMALL(3),SMALL(4) / O000000, O000000 /                      
C                                                                       
C      DATA LARGE(1),LARGE(2) / O077777, O177777 /                      
C      DATA LARGE(3),LARGE(4) / O177777, O177777 /                      
C                                                                       
C      DATA RIGHT(1),RIGHT(2) / O022200, O000000 /                      
C      DATA RIGHT(3),RIGHT(4) / O000000, O000000 /                      
C                                                                       
C      DATA DIVER(1),DIVER(2) / O022400, O000000 /                      
C      DATA DIVER(3),DIVER(4) / O000000, O000000 /                      
C                                                                       
C      DATA LOG10(1),LOG10(2) / O037632, O020232 /                      
C      DATA LOG10(3),LOG10(4) / O102373, O147770 /, SC/987/             
C                                                                       
C     MACHINE CONSTANTS FOR THE PRIME 50 SERIES SYSTEMS                 
C     WITH 32-BIT INTEGERS AND 64V MODE INSTRUCTIONS,                   
C     SUPPLIED BY IGOR BRAY.                                            
C                                                                       
C      DATA SMALL(1),SMALL(2) / :10000000000, :00000100001 /            
C      DATA LARGE(1),LARGE(2) / :17777777777, :37777677775 /            
C      DATA RIGHT(1),RIGHT(2) / :10000000000, :00000000122 /            
C      DATA DIVER(1),DIVER(2) / :10000000000, :00000000123 /            
C      DATA LOG10(1),LOG10(2) / :11504046501, :07674600177 /, SC/987/   
C                                                                       
C     MACHINE CONSTANTS FOR THE SEQUENT BALANCE 8000                    
C                                                                       
C      DATA SMALL(1),SMALL(2) / $00000000,  $00100000 /                 
C      DATA LARGE(1),LARGE(2) / $FFFFFFFF,  $7FEFFFFF /                 
C      DATA RIGHT(1),RIGHT(2) / $00000000,  $3CA00000 /                 
C      DATA DIVER(1),DIVER(2) / $00000000,  $3CB00000 /                 
C      DATA LOG10(1),LOG10(2) / $509F79FF,  $3FD34413 /, SC/987/        
C                                                                       
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES.                     
C                                                                       
C      DATA SMALL(1),SMALL(2) / O000040000000, O000000000000 /          
C      DATA LARGE(1),LARGE(2) / O377777777777, O777777777777 /          
C      DATA RIGHT(1),RIGHT(2) / O170540000000, O000000000000 /          
C      DATA DIVER(1),DIVER(2) / O170640000000, O000000000000 /          
C      DATA LOG10(1),LOG10(2) / O177746420232, O411757177572 /, SC/987/ 
C                                                                       
C     MACHINE CONSTANTS FOR THE VAX UNIX F77 COMPILER                   
C                                                                       
C      DATA SMALL(1),SMALL(2) /        128,           0 /               
C      DATA LARGE(1),LARGE(2) /     -32769,          -1 /               
C      DATA RIGHT(1),RIGHT(2) /       9344,           0 /               
C      DATA DIVER(1),DIVER(2) /       9472,           0 /               
C      DATA LOG10(1),LOG10(2) /  546979738,  -805796613 /, SC/987/      
C                                                                       
C     MACHINE CONSTANTS FOR THE VAX-11 WITH                             
C     FORTRAN IV-PLUS COMPILER                                          
C                                                                       
C      DATA SMALL(1),SMALL(2) / Z00000080, Z00000000 /                  
C      DATA LARGE(1),LARGE(2) / ZFFFF7FFF, ZFFFFFFFF /                  
C      DATA RIGHT(1),RIGHT(2) / Z00002480, Z00000000 /                  
C      DATA DIVER(1),DIVER(2) / Z00002500, Z00000000 /                  
C      DATA LOG10(1),LOG10(2) / Z209A3F9A, ZCFF884FB /, SC/987/         
C                                                                       
C     MACHINE CONSTANTS FOR VAX/VMS VERSION 2.2                         
C                                                                       
c       DATA SMALL(1),SMALL(2) /       '80'X,        '0'X /              
c       DATA LARGE(1),LARGE(2) / 'FFFF7FFF'X, 'FFFFFFFF'X /              
c       DATA RIGHT(1),RIGHT(2) /     '2480'X,        '0'X /              
c       DATA DIVER(1),DIVER(2) /     '2500'X,        '0'X /              
c       DATA LOG10(1),LOG10(2) / '209A3F9A'X, 'CFF884FB'X /, SC/987/     
                                                                        
C  ***  ISSUE STOP 779 IF ALL DATA STATEMENTS ARE COMMENTED...          
      IF (SC .NE. 987) STOP 779                                         
C/6S                                                                    
C     IF (I .LT. 1  .OR.  I .GT. 5)                                     
C    1   CALL SETERR(24HD1MACH - I OUT OF BOUNDS,24,1,2)                
C/7S                                                                    
      IF (I .LT. 1  .OR.  I .GT. 5)                                     
     1   CALL SETERR('D1MACH - I OUT OF BOUNDS',24,1,2)                 
C/                                                                      
C                                                                       
      D1MACH = DMACH(I)                                                 
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE N5ERR(MESSG, NMESSG, NERR, IOPT)                       
      INTEGER NMESSG, NERR, IOPT                                        
C/6S                                                                    
C     INTEGER MESSG(1)                                                  
C/7S                                                                    
      CHARACTER*1 MESSG(NMESSG)                                         
C/                                                                      
C  N5ERR IS A PROCEDURE USED TO REDEFINE AN ERROR STATE.                
      CALL ERROFF                                                       
      CALL SETERR(MESSG, NMESSG, NERR, IOPT)                            
      RETURN                                                            
      END                                                               
      INTEGER FUNCTION NERROR(NERR)                                     
C                                                                       
C  RETURNS NERROR = NERR = THE VALUE OF THE ERROR FLAG LERROR.          
C                                                                       
      NERROR=I8SAVE(1,0,.FALSE.)                                        
      NERR=NERROR                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE ERROFF                                                 
C                                                                       
C  TURNS OFF THE ERROR STATE OFF BY SETTING LERROR=0.                   
C                                                                       
      I=I8SAVE(1,0,.TRUE.)                                              
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE SETERR(MESSG,NMESSG,NERR,IOPT)                         
C                                                                       
C  SETERR SETS LERROR = NERR, OPTIONALLY PRINTS THE MESSAGE AND DUMPS   
C  ACCORDING TO THE FOLLOWING RULES...                                  
C                                                                       
C    IF IOPT = 1 AND RECOVERING      - JUST REMEMBER THE ERROR.         
C    IF IOPT = 1 AND NOT RECOVERING  - PRINT AND STOP.                  
C    IF IOPT = 2                     - PRINT, DUMP AND STOP.            
C                                                                       
C  INPUT                                                                
C                                                                       
C    MESSG  - THE ERROR MESSAGE.                                        
C    NMESSG - THE LENGTH OF THE MESSAGE, IN CHARACTERS.                 
C    NERR   - THE ERROR NUMBER. MUST HAVE NERR NON-ZERO.                
C    IOPT   - THE OPTION. MUST HAVE IOPT=1 OR 2.                        
C                                                                       
C  ERROR STATES -                                                       
C                                                                       
C    1 - MESSAGE LENGTH NOT POSITIVE.                                   
C    2 - CANNOT HAVE NERR=0.                                            
C    3 - AN UNRECOVERED ERROR FOLLOWED BY ANOTHER ERROR.                
C    4 - BAD VALUE FOR IOPT.                                            
C                                                                       
C  ONLY THE FIRST 72 CHARACTERS OF THE MESSAGE ARE PRINTED.             
C                                                                       
C  THE ERROR HANDLER CALLS A SUBROUTINE NAMED SDUMP TO PRODUCE A        
C  SYMBOLIC DUMP.                                                       
C                                                                       
C/6S                                                                    
C     INTEGER MESSG(1)                                                  
C/7S                                                                    
      CHARACTER*1 MESSG(NMESSG)                                         
C/                                                                      
C                                                                       
C  THE UNIT FOR ERROR MESSAGES.                                         
C                                                                       
      IWUNIT=I1MACH(4)                                                  
C                                                                       
      IF (NMESSG.GE.1) GO TO 10                                         
C                                                                       
C  A MESSAGE OF NON-POSITIVE LENGTH IS FATAL.                           
C                                                                       
        WRITE(IWUNIT,9000)                                              
 9000   FORMAT(52H1ERROR    1 IN SETERR - MESSAGE LENGTH NOT POSITIVE.) 
        GO TO 60                                                        
C                                                                       
C  NW IS THE NUMBER OF WORDS THE MESSAGE OCCUPIES.                      
C  (I1MACH(6) IS THE NUMBER OF CHARACTERS PER WORD.)                    
C                                                                       
 10   NW=(MIN0(NMESSG,72)-1)/I1MACH(6)+1                                
C                                                                       
      IF (NERR.NE.0) GO TO 20                                           
C                                                                       
C  CANNOT TURN THE ERROR STATE OFF USING SETERR.                        
C  (I8SAVE SETS A FATAL ERROR HERE.)                                    
C                                                                       
        WRITE(IWUNIT,9001)                                              
 9001   FORMAT(42H1ERROR    2 IN SETERR - CANNOT HAVE NERR=0//          
     1         34H THE CURRENT ERROR MESSAGE FOLLOWS///)                
        CALL E9RINT(MESSG,NW,NERR,.TRUE.)                               
        ITEMP=I8SAVE(1,1,.TRUE.)                                        
        GO TO 50                                                        
C                                                                       
C  SET LERROR AND TEST FOR A PREVIOUS UNRECOVERED ERROR.                
C                                                                       
 20   IF (I8SAVE(1,NERR,.TRUE.).EQ.0) GO TO 30                          
C                                                                       
        WRITE(IWUNIT,9002)                                              
 9002   FORMAT(23H1ERROR    3 IN SETERR -,                              
     1         48H AN UNRECOVERED ERROR FOLLOWED BY ANOTHER ERROR.//    
     2         48H THE PREVIOUS AND CURRENT ERROR MESSAGES FOLLOW.///)  
        CALL EPRINT                                                     
        CALL E9RINT(MESSG,NW,NERR,.TRUE.)                               
        GO TO 50                                                        
C                                                                       
C  SAVE THIS MESSAGE IN CASE IT IS NOT RECOVERED FROM PROPERLY.         
C                                                                       
 30   CALL E9RINT(MESSG,NW,NERR,.TRUE.)                                 
C                                                                       
      IF (IOPT.EQ.1 .OR. IOPT.EQ.2) GO TO 40                            
C                                                                       
C  MUST HAVE IOPT = 1 OR 2.                                             
C                                                                       
        WRITE(IWUNIT,9003)                                              
 9003   FORMAT(42H1ERROR    4 IN SETERR - BAD VALUE FOR IOPT//          
     1         34H THE CURRENT ERROR MESSAGE FOLLOWS///)                
        GO TO 50                                                        
C                                                                       
C  IF THE ERROR IS FATAL, PRINT, DUMP, AND STOP                         
C                                                                       
 40   IF (IOPT.EQ.2) GO TO 50                                           
C                                                                       
C  HERE THE ERROR IS RECOVERABLE                                        
C                                                                       
C  IF THE RECOVERY MODE IS IN EFFECT, OK, JUST RETURN                   
C                                                                       
      IF (I8SAVE(2,0,.FALSE.).EQ.1) RETURN                              
C                                                                       
C  OTHERWISE PRINT AND STOP                                             
C                                                                       
      CALL EPRINT                                                       
      STOP                                                              
C                                                                       
 50   CALL EPRINT                                                       
 60   CALL SDUMP                                                        
      STOP                                                              
C                                                                       
      END                                                               
      SUBROUTINE SDUMP                                                  
C   THIS IS THE STANDARD DUMP ROUTINE FOR THE PORT LIBRARY.             
C   FIRST IT PROVIDES A FORMATTED DUMP OF THE PORT STACK.               
C   THEN IT CALLS THE LOCAL (PREFERABLY SYMBOLIC) DUMP ROUTINE.         
      CALL STKDMP                                                       
      CALL FDUMP                                                        
      RETURN                                                            
      END                                                               
      SUBROUTINE STKDMP                                                 
C                                                                       
C  THIS PROCEDURE PROVIDES A DUMP OF THE PORT STACK.                    
C                                                                       
C  WRITTEN BY D. D. WARNER.                                             
C                                                                       
C  MOSTLY REWRITTEN BY P. A. FOX, OCTOBER 13, 1982                      
C  AND COMMENTS ADDED.                                                  
C                                                                       
C  ALLOCATED REGIONS OF THE STACK ARE PRINTED OUT IN THE APPROPRIATE    
C  FORMAT, EXCEPT IF THE STACK APPEARS TO HAVE BEEN OVERWRITTEN.        
C  IF OVERWRITE SEEMS TO HAVE HAPPENED, THE ENTIRE STACK IS PRINTED OUT 
C  IN UNSTRUCTURED FORM, ONCE FOR EACH OF THE POSSIBLE                  
C  (LOGICAL, INTEGER, REAL, DOUBLE PRECISION, OR COMPLEX) FORMATS.      
C                                                                       
      COMMON /CSTAK/ DSTAK                                              
      DOUBLE PRECISION DSTAK(500)                                       
      REAL RSTAK(1000)                                                  
C/R                                                                     
C     REAL CMSTAK(2,500)                                                
C/C                                                                     
      COMPLEX CMSTAK(500)                                               
C/                                                                      
      INTEGER ISTAK(1000)                                               
      LOGICAL LSTAK(1000)                                               
C                                                                       
      INTEGER LOUT, LNOW, LUSED, LMAX, LBOOK                            
      INTEGER LLOUT, BPNTR                                              
      INTEGER IPTR, ERROUT, MCOL, NITEMS                                
      INTEGER WR, DR, WD, DD, WI                                        
      INTEGER LNG(5), ISIZE(5)                                          
      INTEGER I, LNEXT, ITYPE, I1MACH                                   
C                                                                       
      LOGICAL INIT, TRBL1, TRBL2                                        
C                                                                       
      EQUIVALENCE (DSTAK(1), ISTAK(1))                                  
      EQUIVALENCE (DSTAK(1), LSTAK(1))                                  
      EQUIVALENCE (DSTAK(1), RSTAK(1))                                  
C/R                                                                     
C     EQUIVALENCE (DSTAK(1), CMSTAK(1,1))                               
C/C                                                                     
      EQUIVALENCE (DSTAK(1), CMSTAK(1))                                 
C/                                                                      
      EQUIVALENCE (ISTAK(1), LOUT)                                      
      EQUIVALENCE (ISTAK(2), LNOW)                                      
      EQUIVALENCE (ISTAK(3), LUSED)                                     
      EQUIVALENCE (ISTAK(4), LMAX)                                      
      EQUIVALENCE (ISTAK(5), LBOOK)                                     
      EQUIVALENCE (ISTAK(6), ISIZE(1))                                  
C                                                                       
      DATA MCOL/132/                                                    
      DATA INIT/.TRUE./                                                 
C                                                                       
C  I0TK00 CHECKS TO SEE IF THE FIRST TEN, BOOKKEEPING, LOCATIONS OF     
C  THE STACK HAVE BEEN INITIALIZED (AND DOES IT, IF NEEDED).            
C                                                                       
      IF (INIT) CALL I0TK00(INIT, 500, 4)                               
C                                                                       
C                                                                       
C  I1MACH(4) IS THE STANDARD ERROR MESSAGE WRITE UNIT.                  
C                                                                       
      ERROUT = I1MACH(4)                                                
      WRITE (ERROUT,  9901)                                             
 9901   FORMAT (11H1STACK DUMP)                                         
C                                                                       
C                                                                       
C  FIND THE MACHINE-DEPENDENT FORMATS FOR PRINTING - BUT ADD 1 TO       
C  THE WIDTH TO GET SEPARATION BETWEEN ITEMS, AND SUBTRACT 1 FROM       
C  THE NUMBER OF DIGITS AFTER THE DECIMAL POINT TO ALLOW FOR THE        
C  1P IN THE DUMP FORMAT OF 1PEW.D                                      
C                                                                       
C  (NOTE, THAT ALTHOUGH IT IS NOT NECESSARY, 2 HAS BEEN ADDED TO        
C   THE INTEGER WIDTH, WI, TO CONFORM WITH DAN WARNERS PREVIOUS         
C   USAGE - SO PEOPLE CAN COMPARE DUMPS WITH ONES THEY HAVE HAD         
C   AROUND FOR A LONG TIME.)                                            
C                                                                       
       CALL FRMATR(WR,DR)                                               
       CALL FRMATD(WD,DD)                                               
       CALL FRMATI(WI)                                                  
C                                                                       
       WR = WR+1                                                        
       WD = WD+1                                                        
       WI = WI+2                                                        
       DR = DR-1                                                        
       DD = DD-1                                                        
C                                                                       
C  CHECK, IN VARIOUS WAYS, THE BOOKKEEPING PART OF THE STACK TO SEE     
C  IF THINGS WERE OVERWRITTEN.                                          
C                                                                       
C  LOUT  IS THE NUMBER OF CURRENT ALLOCATIONS                           
C  LNOW  IS THE CURRENT ACTIVE LENGTH OF THE STACK                      
C  LUSED IS THE MAXIMUM VALUE OF LNOW ACHIEVED                          
C  LMAX  IS THE MAXIMUM LENGTH OF THE STACK                             
C  LBOOK IS THE NUMBER OF WORDS USED FOR BOOK-KEEPING                   
C                                                                       
      TRBL1 = LBOOK .NE. 10                                             
      IF (.NOT. TRBL1) TRBL1 = LMAX .LT. 12                             
      IF (.NOT. TRBL1) TRBL1 = LMAX .LT. LUSED                          
      IF (.NOT. TRBL1) TRBL1 = LUSED .LT. LNOW                          
      IF (.NOT. TRBL1) TRBL1 = LNOW .LT. LBOOK                          
      IF (.NOT. TRBL1) TRBL1 = LOUT .LT. 0                              
      IF (.NOT. TRBL1) GO TO 10                                         
C                                                                       
         WRITE (ERROUT,  9902)                                          
 9902      FORMAT (29H0STACK HEADING IS OVERWRITTEN)                    
         WRITE (ERROUT,  9903)                                          
 9903      FORMAT (47H UNSTRUCTURED DUMP OF THE DEFAULT STACK FOLLOWS)  
C                                                                       
C  SINCE INFORMATION IS LOST, SIMPLY SET THE USUAL DEFAULT VALUES FOR   
C  THE LENGTH OF THE ENTIRE STACK IN TERMS OF EACH (LOGICAL, INTEGER,   
C  ETC.,) TYPE.                                                         
C                                                                       
      LNG(1) = 1000                                                     
      LNG(2) = 1000                                                     
      LNG(3) = 1000                                                     
      LNG(4) = 500                                                      
      LNG(5) = 500                                                      
C                                                                       
C                                                                       
         CALL U9DMP(LNG, MCOL, WI, WR, DR, WD, DD)                      
         GO TO  110                                                     
C                                                                       
C  WRITE OUT THE STORAGE UNITS USED BY EACH TYPE OF VARIABLE            
C                                                                       
   10    WRITE (ERROUT,  9904)                                          
 9904      FORMAT (19H0STORAGE PARAMETERS)                              
         WRITE (ERROUT,  9905) ISIZE(1)                                 
 9905      FORMAT (18H LOGICAL          , I7, 14H STORAGE UNITS)        
         WRITE (ERROUT,  9906) ISIZE(2)                                 
 9906      FORMAT (18H INTEGER          , I7, 14H STORAGE UNITS)        
         WRITE (ERROUT,  9907) ISIZE(3)                                 
 9907      FORMAT (18H REAL             , I7, 14H STORAGE UNITS)        
         WRITE (ERROUT,  9908) ISIZE(4)                                 
 9908      FORMAT (18H DOUBLE PRECISION , I7, 14H STORAGE UNITS)        
         WRITE (ERROUT,  9909) ISIZE(5)                                 
 9909      FORMAT (18H COMPLEX          , I7, 14H STORAGE UNITS)        
C                                                                       
C  WRITE OUT THE CURRENT STACK STATISTICS (I.E. USAGE)                  
C                                                                       
         WRITE (ERROUT,  9910)                                          
 9910      FORMAT (17H0STACK STATISTICS)                                
         WRITE (ERROUT,  9911) LMAX                                     
 9911      FORMAT (23H STACK SIZE            , I7)                      
         WRITE (ERROUT,  9912) LUSED                                    
 9912      FORMAT (23H MAXIMUM STACK USED    , I7)                      
         WRITE (ERROUT,  9913) LNOW                                     
 9913      FORMAT (23H CURRENT STACK USED    , I7)                      
         WRITE (ERROUT,  9914) LOUT                                     
 9914      FORMAT (23H NUMBER OF ALLOCATIONS , I7)                      
C                                                                       
C  HERE AT LEAST THE BOOKKEEPING PART OF THE STACK HAS NOT BEEN         
C  OVERWRITTEN.                                                         
C                                                                       
C  STACKDUMP WORKS BACKWARDS FROM THE END (MOST RECENT ALLOCATION) OF   
C  THE STACK, PRINTING INFORMATION, BUT ALWAYS CHECKING TO SEE IF       
C  THE POINTERS FOR AN ALLOCATION HAVE BEEN OVERWRITTEN.                
C                                                                       
C  LLOUT COUNTS THE NUMBER OF ALLOCATIONS STILL LEFT TO PRINT           
C  SO LLOUT IS INITIALLY LOUT OR ISTAK(1).                              
C                                                                       
C  THE STACK ALLOCATION ROUTINE PUTS, AT THE END OF EACH ALLOCATION,    
C  TWO EXTRA SPACES - ONE FOR THE TYPE OF THE ALLOCATION AND THE NEXT   
C  TO HOLD A BACK POINTER TO THE PREVIOUS ALLOCATION.                   
C  THE BACK POINTER IS THEREFORE INITIALLY LOCATED AT THE INITIAL END,  
C  LNOW, OF THE STACK.                                                  
C  CALL THIS LOCATION BPNTR.                                            
C                                                                       
          LLOUT = LOUT                                                  
          BPNTR = LNOW                                                  
C                                                                       
C  IF WE ARE DONE, THE BACK POINTER POINTS BACK INTO THE BOOKKEEPING    
C  PART OF THE STACK.                                                   
C                                                                       
C  IF WE ARE NOT DONE, OBTAIN THE NEXT REGION TO PRINT AND GET ITS TYPE.
C                                                                       
   20    IF (BPNTR .LE. LBOOK) GO TO  110                               
C                                                                       
            LNEXT = ISTAK(BPNTR)                                        
            ITYPE = ISTAK(BPNTR-1)                                      
C                                                                       
C  SEE IF ANY OF THESE NEW DATA ARE INCONSISTENT - WHICH WOULD SIGNAL   
C  AN OVERWRITE.                                                        
C                                                                       
            TRBL2 = LNEXT .LT. LBOOK                                    
            IF (.NOT. TRBL2) TRBL2 = BPNTR .LE. LNEXT                   
            IF (.NOT. TRBL2) TRBL2 = ITYPE .LT. 0                       
            IF (.NOT. TRBL2) TRBL2 = 5 .LT. ITYPE                       
            IF (.NOT. TRBL2) GO TO 40                                   
C                                                                       
C  HERE THERE SEEMS TO HAVE BEEN A PARTIAL OVERWRITE.                   
C  COMPUTE THE LENGTH OF THE ENTIRE STACK IN TERMS OF THE VALUES GIVEN  
C  IN THE BOOKKEEPING PART OF THE STACK (WHICH, AT LEAST, SEEMS NOT TO  
C  HAVE BEEN OVERWRITTEN), AND DO AN UNFORMATTED DUMP, AND RETURN.      
C                                                                       
               WRITE (ERROUT,  9915)                                    
 9915            FORMAT (28H0STACK PARTIALLY OVERWRITTEN)               
               WRITE (ERROUT,  9916)                                    
 9916          FORMAT (45H UNSTRUCTURED DUMP OF REMAINING STACK FOLLOWS)
C                                                                       
         DO  30 I = 1, 5                                                
            LNG(I) = (BPNTR*ISIZE(2)-1)/ISIZE(I)+1                      
   30    CONTINUE                                                       
C                                                                       
               CALL U9DMP(LNG, MCOL, WI, WR, DR, WD, DD)                
               GO TO  110                                               
C                                                                       
C                                                                       
C  COMES HERE EACH TIME TO PRINT NEXT (BACK) ALLOCATION.                
C                                                                       
C  AT THIS POINT BPNTR POINTS TO THE END OF THE ALLOCATION ABOUT TO     
C  BE PRINTED, LNEXT = ISTAK(BPNTR) POINTS BACK TO THE END OF THE       
C  PREVIOUS ALLOCATION, AND ITYPE = ISTAK(BPNTR-1) GIVES THE TYPE OF    
C  THE ALLOCATION ABOUT TO BE PRINTED.                                  
C                                                                       
C  THE PRINTING ROUTINES NEED TO KNOW THE START OF THE ALLOCATION AND   
C  THE NUMBER OF ITEMS.                                                 
C  THESE ARE COMPUTED FROM THE EQUATIONS USED WHEN THE FUNCTION ISTKGT  
C  COMPUTED THE ORIGINAL ALLOCATION - THE POINTER TO THE                
C  START OF THE ALLOCATION WAS COMPUTED BY ISTKGT FROM THE (THEN)       
C  END OF THE PREVIOUS ALLOCATION VIA THE FORMULA,                      
C                                                                       
C           ISTKGT = (LNOW*ISIZE(2)-1)/ISIZE(ITYPE) + 2                 
C                                                                       
   40       IPTR   = (LNEXT*ISIZE(2)-1)/ISIZE(ITYPE) + 2                
C                                                                       
C  THE FUNCTION ISTKGT THEN FOUND NEW END OF THE STACK, LNOW, FROM THE  
C  FORMULA                                                              
C                                                                       
C          I = ( (ISTKGT-1+NITEMS)*ISIZE(ITYPE) - 1 )/ISIZE(2) + 3      
C                                                                       
C  HERE WE SOLVE THIS FOR NITEMS TO DETERMINE THE NUMBER OF LOCATIONS   
C  IN THIS ALLOCATION.                                                  
C                                                                       
            NITEMS = 1-IPTR + ((BPNTR-3)*ISIZE(2)+1)/ISIZE(ITYPE)       
C                                                                       
C                                                                       
C  USE THE TYPE (INTEGER, REAL, ETC.) TO DTERMINE WHICH PRINTING        
C  ROUTINE TO USE.                                                      
C                                                                       
               IF (ITYPE .EQ. 1) GO TO  50                              
               IF (ITYPE .EQ. 2) GO TO  60                              
               IF (ITYPE .EQ. 3) GO TO  70                              
               IF (ITYPE .EQ. 4) GO TO  80                              
               IF (ITYPE .EQ. 5) GO TO  90                              
C                                                                       
   50          WRITE (ERROUT,  9917) LLOUT, IPTR                        
 9917            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =, 
     1            I7, 23H,          TYPE LOGICAL)                       
               CALL A9RNTL(LSTAK(IPTR), NITEMS, ERROUT, MCOL)           
               GO TO  100                                               
C                                                                       
   60          WRITE (ERROUT,  9918) LLOUT, IPTR                        
 9918            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =, 
     1            I7, 23H,          TYPE INTEGER)                       
               CALL A9RNTI(ISTAK(IPTR), NITEMS, ERROUT, MCOL, WI)       
               GO TO  100                                               
C                                                                       
   70          WRITE (ERROUT,  9919) LLOUT, IPTR                        
 9919            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =, 
     1            I7, 20H,          TYPE REAL)                          
               CALL A9RNTR(RSTAK(IPTR), NITEMS, ERROUT, MCOL, WR, DR)   
               GO TO  100                                               
C                                                                       
   80          WRITE (ERROUT,  9920) LLOUT, IPTR                        
 9920            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =, 
     1            I7, 32H,          TYPE DOUBLE PRECISION)              
               CALL A9RNTD(DSTAK(IPTR), NITEMS, ERROUT, MCOL, WD, DD)   
               GO TO  100                                               
C                                                                       
   90          WRITE (ERROUT,  9921) LLOUT, IPTR                        
 9921            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =, 
     1            I7, 23H,          TYPE COMPLEX)                       
C/R                                                                     
C              CALL A9RNTC(CMSTAK(1,IPTR), NITEMS, ERROUT, MCOL, WR,DR) 
C/C                                                                     
               CALL A9RNTC(CMSTAK(IPTR), NITEMS, ERROUT, MCOL, WR, DR)  
C/                                                                      
C                                                                       
 100        BPNTR = LNEXT                                               
            LLOUT = LLOUT-1                                             
            GO TO 20                                                    
C                                                                       
  110  WRITE (ERROUT,  9922)                                            
 9922   FORMAT (18H0END OF STACK DUMP)                                  
      RETURN                                                            
      END                                                               
      SUBROUTINE U9DMP(LNG, NCOL, WI, WR, DR, WD, DD)                   
C                                                                       
C  THIS SUBROUTINE ASSUMES THAT THE TYPE (INTEGER, ETC.) OF THE DATA    
C  IN THE PORT STACK IS NOT KNOWN - SO IT PRINTS OUT, IN ALL FORMATS    
C  THE STACK CONTENTS, USING THE ARRAY OUTPUT ROUTINES APRNTX.          
C                                                                       
C  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, NOVEMBER 8, 1982.        
C                                                                       
C  INPUT PARAMETERS -                                                   
C                                                                       
C    LNG      - AN INTEGER VECTOR ARRAY CONTAINING IN                   
C               LNG(1) THE LENGTH OF THE ARRAY IF LOGICAL               
C               LNG(2) THE LENGTH OF THE ARRAY IF INTEGER               
C               LNG(3) THE LENGTH OF THE ARRAY IF REAL                  
C               LNG(4) THE LENGTH OF THE ARRAY IF DOUBLE PRECISION      
C               LNG(5) THE LENGTH OF THE ARRAY IF COMPLEX               
C                                                                       
C    NCOL     - THE NUMBER OF SPACES ACROSS A PRINTED LINE              
C                                                                       
C    WI       - THE FORMAT WIDTH FOR AN INTEGER                         
C                                                                       
C    WR       - THE FORMAT WIDTH FOR A REAL (W IN 1PEW.D)               
C                                                                       
C    DR       - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT            
C               (THE D IN THE 1PEW.D FORMULA)                           
C                                                                       
C    WD       - THE FORMAT WIDTH FOR A REAL (W IN 1PDW.D)               
C                                                                       
C    DD       - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT            
C               (THE D IN THE 1PDW.D FORMULA)                           
C                                                                       
C                                                                       
C  ERROR STATES - NONE.  U9DMP IS CALLED BY SETERR,                     
C  SO IT CANNOT CALL SETERR.                                            
C                                                                       
C                                                                       
      INTEGER LNG(5), NCOL, WI, WR, DR, WD                              
      INTEGER DD                                                        
      COMMON /CSTAK/ DSTAK                                              
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ERROUT, ISTAK(1000), I1MACH                               
      REAL RSTAK(1000)                                                  
      LOGICAL LSTAK(1000)                                               
C/R                                                                     
C     REAL CMSTAK(2,500)                                                
C     EQUIVALENCE (DSTAK(1), CMSTAK(1,1))                               
C/C                                                                     
      COMPLEX CMSTAK(500)                                               
      EQUIVALENCE (DSTAK(1), CMSTAK(1))                                 
C/                                                                      
      EQUIVALENCE (DSTAK(1), ISTAK(1))                                  
      EQUIVALENCE (DSTAK(1), LSTAK(1))                                  
      EQUIVALENCE (DSTAK(1), RSTAK(1))                                  
C                                                                       
      ERROUT = I1MACH(4)                                                
C                                                                       
      WRITE (ERROUT,  1)                                                
   1  FORMAT (14H0LOGICAL STACK)                                        
      CALL A9RNTL(LSTAK, LNG(1), ERROUT, NCOL)                          
      WRITE (ERROUT,  2)                                                
   2  FORMAT (14H0INTEGER STACK)                                        
      CALL A9RNTI(ISTAK, LNG(2), ERROUT, NCOL, WI)                      
      WRITE (ERROUT,  3)                                                
   3  FORMAT (11H0REAL STACK)                                           
      CALL A9RNTR(RSTAK, LNG(3), ERROUT, NCOL, WR, DR)                  
      WRITE (ERROUT,  4)                                                
   4  FORMAT (23H0DOUBLE PRECISION STACK)                               
      CALL A9RNTD(DSTAK, LNG(4), ERROUT, NCOL, WD, DD)                  
      WRITE (ERROUT,  5)                                                
   5  FORMAT (14H0COMPLEX STACK)                                        
      CALL A9RNTC(CMSTAK, LNG(5), ERROUT, NCOL, WR, DR)                 
C                                                                       
      RETURN                                                            
      END                                                               
      SUBROUTINE A9RNTC(A, NITEMS, IOUT, MCOL, W, D)                    
C                                                                       
C  THIS IS THE DOCUMENTED ROUTINE APRNTC, BUT WITHOUT THE CALLS TO      
C  SETERR- BECAUSE IT IS CALLED BY SETERR.                              
C                                                                       
C  THIS SUBROUTINE PRINTS OUT NITEMS FROM THE COMPLEX ARRAY, A, ON      
C  OUTPUT UNIT IOUT, USING A MAXIMUM OF MCOL PRINT SPACES.              
C  THE OUTPUT FORMAT IS 2(1PEW.D).                                      
C  THE PROGRAM PUTS AS MANY VALUES ON A LINE AS POSSIBLE.               
C  W SHOULD BE INPUT AS THE ACTUAL WIDTH +1 FOR A SPACE BETWEEN VALUES. 
C                                                                       
C  DUPLICATE LINES ARE NOT ALL PRINTED, BUT ARE INDICATED BY ASTERISKS. 
C                                                                       
C  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, OCTOBER 21, 1982.        
C                                                                       
C  THE LINE WIDTH IS COMPUTED AS THE MINIMUM OF THE INPUT MCOL AND 160. 
C  IF THE LINE WIDTH IS TO BE INCREASED ABOVE 160, THE BUFFERS LINE()   
C  AND LAST(), WHICH THE VALUES TO BE PRINTED ON ONE LINE, MUST         
C  BE DIMENSIONED ACCORDINGLY.                                          
C                                                                       
C  INPUT PARAMETERS -                                                   
C                                                                       
C    A        - THE START OF THE COMPLEX ARRAY TO BE PRINTED            
C                                                                       
C    NITEMS   - THE NUMBER OF ITEMS TO BE PRINTED                       
C                                                                       
C    IOUT     - THE OUTPUT UNIT FOR PRINTING                            
C                                                                       
C    MCOL     - THE NUMBER OF SPACES ACROSS THE LINE                    
C                                                                       
C    W        - THE WIDTH OF THE PRINTED VALUE (1PEW.D)                 
C                                                                       
C    D        - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT (1PEW.D)   
C                                                                       
C                                                                       
C  ERROR STATES - NONE.  LOWER LEVEL ROUTINE CALLED BY                  
C  SETERR, SO IT CANNOT CALL SETERR.                                    
C                                                                       
      INTEGER  NITEMS, IOUT, MCOL, W, D                                 
C/R                                                                     
C     REAL A(2,NITEMS)                                                  
C/C                                                                     
      COMPLEX  A(NITEMS)                                                
C/                                                                      
C                                                                       
      INTEGER  MAX0, MIN0, WW, DD, EMIN, EMAX,                          
     1         EXPENT, I1MACH, ICEIL, IABS, I10WID                      
C/6S                                                                    
C     INTEGER  IFMT1(20), IFMT2(18), BLANK, STAR                        
C     INTEGER IFMT1C(20), IFMT2C(18)                                    
C     EQUIVALENCE (IFMT1(1),IFMT1C(1)), (IFMT2(1),IFMT2C(1))            
C/7S                                                                    
      CHARACTER*1  IFMT1(20), IFMT2(18), BLANK, STAR                    
      CHARACTER*20 IFMT1C                                               
      CHARACTER*18 IFMT2C                                               
      EQUIVALENCE (IFMT1(1),IFMT1C), (IFMT2(1),IFMT2C)                  
C/                                                                      
      INTEGER  INDW, NCOL, COUNT, I, J, K, ILINE, ILAST                 
      LOGICAL  DUP                                                      
C/R                                                                     
C     REAL LINE(2,18), LAST(2,18)                                       
C/C                                                                     
      COMPLEX  LINE(18), LAST(18)                                       
C/                                                                      
      REAL  LOGETA                                                      
C                                                                       
C/6S                                                                    
C     DATA BLANK/1H /, STAR/1H*/, INDW/7/, EXPENT/0/                    
C/7S                                                                    
      DATA BLANK/' '/, STAR/'*'/, INDW/7/, EXPENT/0/                    
C/                                                                      
C                                                                       
C  IFMT1 IS FOR THE ASTERISK LINES- IFMT2 FOR THE DATA LINES            
C                                                                       
C/6S                                                                    
C     DATA IFMT1( 1) /1H(/,  IFMT2( 1) /1H(/                            
C     DATA IFMT1( 2) /1H1/,  IFMT2( 2) /1H1/                            
C     DATA IFMT1( 3) /1HA/,  IFMT2( 3) /1HA/                            
C     DATA IFMT1( 4) /1H1/,  IFMT2( 4) /1H1/                            
C     DATA IFMT1( 5) /1H,/,  IFMT2( 5) /1H,/                            
C     DATA IFMT1( 6) /1H5/,  IFMT2( 6) /1HI/                            
C     DATA IFMT1( 7) /1HX/,  IFMT2( 7) /1H7/                            
C     DATA IFMT1( 8) /1H,/,  IFMT2( 8) /1H,/                            
C     DATA IFMT1( 9) /1H2/,  IFMT2( 9) /1H1/                            
C     DATA IFMT1(10) /1HA/,  IFMT2(10) /1HP/                            
C     DATA IFMT1(11) /1H1/,  IFMT2(11) /1H /                            
C     DATA IFMT1(12) /1H,/,  IFMT2(12) /1HE/                            
C     DATA IFMT1(13) /1H /,  IFMT2(13) /1H /                            
C     DATA IFMT1(14) /1H /,  IFMT2(14) /1H /                            
C     DATA IFMT1(15) /1HX/,  IFMT2(15) /1H./                            
C     DATA IFMT1(16) /1H,/,  IFMT2(16) /1H /                            
C     DATA IFMT1(17) /1H2/,  IFMT2(17) /1H /                            
C     DATA IFMT1(18) /1HA/,  IFMT2(18) /1H)/                            
C     DATA IFMT1(19) /1H1/                                              
C     DATA IFMT1(20) /1H)/                                              
C/7S                                                                    
      DATA IFMT1( 1) /'('/,  IFMT2( 1) /'('/                            
      DATA IFMT1( 2) /'1'/,  IFMT2( 2) /'1'/                            
      DATA IFMT1( 3) /'A'/,  IFMT2( 3) /'A'/                            
      DATA IFMT1( 4) /'1'/,  IFMT2( 4) /'1'/                            
      DATA IFMT1( 5) /','/,  IFMT2( 5) /','/                            
      DATA IFMT1( 6) /'5'/,  IFMT2( 6) /'I'/                            
      DATA IFMT1( 7) /'X'/,  IFMT2( 7) /'7'/                            
      DATA IFMT1( 8) /','/,  IFMT2( 8) /','/                            
      DATA IFMT1( 9) /'2'/,  IFMT2( 9) /'1'/                            
      DATA IFMT1(10) /'A'/,  IFMT2(10) /'P'/                            
      DATA IFMT1(11) /'1'/,  IFMT2(11) /' '/                            
      DATA IFMT1(12) /','/,  IFMT2(12) /'E'/                            
      DATA IFMT1(13) /' '/,  IFMT2(13) /' '/                            
      DATA IFMT1(14) /' '/,  IFMT2(14) /' '/                            
      DATA IFMT1(15) /'X'/,  IFMT2(15) /'.'/                            
      DATA IFMT1(16) /','/,  IFMT2(16) /' '/                            
      DATA IFMT1(17) /'2'/,  IFMT2(17) /' '/                            
      DATA IFMT1(18) /'A'/,  IFMT2(18) /')'/                            
      DATA IFMT1(19) /'1'/                                              
      DATA IFMT1(20) /')'/                                              
C/                                                                      
C                                                                       
C     EXPENT IS USED AS A FIRST-TIME SWITCH TO SIGNAL IF THE            
C     MACHINE-VALUE CONSTANTS HAVE BEEN COMPUTED.                       
C                                                                       
      IF (EXPENT .GT. 0) GO TO 10                                       
         LOGETA = ALOG10(FLOAT(I1MACH(10)))                             
         EMIN   = ICEIL(LOGETA*FLOAT(IABS(I1MACH(12)-1)))               
         EMAX   = ICEIL(LOGETA*FLOAT(I1MACH(13)))                       
         EXPENT = I10WID(MAX0(EMIN, EMAX))                              
C                                                                       
C     COMPUTE THE FORMATS.                                              
C                                                                       
   10 WW = MIN0(99, MAX0(W, 5+EXPENT))                                  
      CALL S88FMT(2, WW, IFMT2(13))                                     
      DD = MIN0(D, (WW-(5+EXPENT)))                                     
      CALL S88FMT(2, DD, IFMT2(16))                                     
C                                                                       
C  NCOL IS THE NUMBER OF VALUES TO BE PRINTED ACROSS THE LINE.          
C                                                                       
      NCOL = MAX0(1, MIN0(9, (MIN0(MCOL,160)-INDW)/(2*WW)))             
      CALL S88FMT(1, (2*NCOL), IFMT2(11))                               
      WW = WW-2                                                         
C                                                                       
C  THE ASTERISKS ARE POSITIONED RIGHT-ADJUSTED IN THE W-WIDTH SPACE.    
      CALL S88FMT(2, WW, IFMT1(13))                                     
C                                                                       
C  I COUNTS THE NUMBER OF ITEMS TO BE PRINTED,                          
C  J COUNTS THE NUMBER ON A GIVEN LINE,                                 
C  COUNT COUNTS THE NUMBER OF DUPLICATE LINES.                          
C                                                                       
      I = 1                                                             
      J = 0                                                             
      COUNT = 0                                                         
C                                                                       
C  THE LOGICAL OF THE FOLLOWING IS ROUGHLY THIS -                       
C  IF THERE ARE STILL MORE ITEMS TO BE PRINTED, A LINE-                 
C  FULL IS PUT INTO THE ARRAY, LINE.                                    
C  WHENEVER A LINE IS PRINTED OUT, IT IS ALSO STUFFED INTO              
C  THE ARRAY, LAST, TO COMPARE WITH THE NEXT ONE COMING IN              
C  TO CHECK FOR REPEAT OR DUPLICATED LINES.                             
C  ALSO WHENEVER A LINE IS WRITTEN OUT, THE DUPLICATION                 
C  COUNTER, COUNT, IS SET TO ONE.                                       
C  THE ONLY MILDLY TRICKY PART IS TO NOTE THAT COUNT HAS TO             
C  GO TO 3 BEFORE A LINE OF ASTERISKS IS PRINTED BECAUSE                
C  OF COURSE NO SUCH LINE IS PRINTED FOR JUST A PAIR OF                 
C  DUPLICATE LINES.                                                     
C                                                                       
C  ILINE IS PRINTED AS THE INDEX OF THE FIRST ARRAY ELEMENT             
C  IN A LINE.                                                           
C                                                                       
C                                                                       
   20 IF (I .GT. NITEMS)  GO TO 90                                      
        J = J+1                                                         
C/R                                                                     
C       LINE(1,J) = A(1,I)                                              
C       LINE(2,J) = A(2,I)                                              
C/C                                                                     
        LINE(J) = A(I)                                                  
C/                                                                      
        IF (J .EQ. 1) ILINE = I                                         
        IF (J .LT. NCOL .AND. I .LT. NITEMS) GO TO 80                   
          IF (COUNT .EQ. 0) GO TO 50                                    
            DUP = .TRUE.                                                
            DO 30 K=1,NCOL                                              
C/R                                                                     
C             IF (LAST(1,K) .NE. LINE(1,K)  .OR.                        
C    1            LAST(2,K) .NE. LINE(2,K))                             
C    2            DUP = .FALSE.                                         
C/C                                                                     
              IF (REAL(LAST(K)) .NE. REAL(LINE(K))  .OR.                
     1            AIMAG(LAST(K)) .NE. AIMAG(LINE(K)))                   
     2            DUP = .FALSE.                                         
C/                                                                      
   30       CONTINUE                                                    
            IF (I .EQ. NITEMS  .AND.  J .LT. NCOL) DUP = .FALSE.        
            IF (.NOT. DUP .AND. COUNT .EQ. 1) GO TO 50                  
              IF (.NOT. DUP) GO TO 40                                   
                COUNT = COUNT+1                                         
                IF (COUNT .EQ. 3) WRITE(IOUT, IFMT1C) BLANK,            
     1                                 STAR, STAR, STAR, STAR           
                IF (I .EQ. NITEMS)  GO TO 50                            
                  GO TO 70                                              
C/R                                                                     
C  40         WRITE(IOUT, IFMT2C) BLANK, ILAST, (LAST(1,K),             
C    1              LAST(2,K), K=1,NCOL)                                
C  50     WRITE(IOUT, IFMT2C) BLANK, ILINE, (LINE(1,K),                 
C    1              LINE(2,K), K=1,J)                                   
C/C                                                                     
   40         WRITE(IOUT, IFMT2C) BLANK, ILAST, (LAST(K), K=1,NCOL)     
   50     WRITE(IOUT, IFMT2C) BLANK, ILINE, (LINE(K), K=1,J)            
C/                                                                      
          COUNT = 1                                                     
          DO 60 K=1,NCOL                                                
C/R                                                                     
C           LAST(1,K) = LINE(1,K)                                       
C  60       LAST(2,K) = LINE(2,K)                                       
C/C                                                                     
   60       LAST(K) = LINE(K)                                           
C/                                                                      
   70     ILAST = ILINE                                                 
          J = 0                                                         
   80   I = I+1                                                         
        GO TO 20                                                        
   90 RETURN                                                            
      END                                                               
      SUBROUTINE A9RNTD(A, NITEMS, IOUT, MCOL, W, D)                    
C                                                                       
C  THIS IS THE DOCUMENTED ROUTINE APRNTD, BUT WITHOUT THE CALLS TO      
C  SETERR - BECAUSE IT IS CALLED BY SETERR.                             
C                                                                       
C  THIS SUBROUTINE PRINTS OUT NITEMS FROM THE DOUBLE PRECISION ARRAY,   
C  A, ON OUTPUT UNIT IOUT, USING A MAXIMUM OF MCOL PRINT SPACES.        
C  THE OUTPUT FORMAT IS 1PDW.D.                                         
C  THE PROGRAM PUTS AS MANY VALUES ON A LINE AS POSSIBLE.               
C  W SHOULD BE INPUT AS THE ACTUAL WIDTH +1 FOR A SPACE BETWEEN VALUES. 
C                                                                       
C  DUPLICATE LINES ARE NOT ALL PRINTED, BUT ARE INDICATED BY ASTERISKS. 
C                                                                       
C  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, OCTOBER 21, 1982.        
C                                                                       
C  THE LINE WIDTH IS COMPUTED AS THE MINIMUM OF THE INPUT MCOL AND 160. 
C  IF THE LINE WIDTH IS TO BE INCREASED ABOVE 160, THE BUFFERS LINE()   
C  AND LAST(), WHICH THE VALUES TO BE PRINTED ON ONE LINE, MUST         
C  BE DIMENSIONED ACCORDINGLY.                                          
C                                                                       
C  INPUT PARAMETERS -                                                   
C                                                                       
C    A        - THE START OF THE DOUBLE PRECISION ARRAY TO BE PRINTED   
C                                                                       
C    NITEMS   - THE NUMBER OF ITEMS TO BE PRINTED                       
C                                                                       
C    IOUT     - THE OUTPUT UNIT FOR PRINTING                            
C                                                                       
C    MCOL     - THE NUMBER OF SPACES ACROSS THE LINE                    
C                                                                       
C    W        - THE WIDTH OF THE PRINTED VALUE (1PDW.D)                 
C                                                                       
C    D        - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT (1PDW.D)   
C                                                                       
C                                                                       
C  ERROR STATES - NONE.  LOWER LEVEL ROUTINE CALLED BY                  
C  SETERR, SO IT CANNOT CALL SETERR.                                    
C                                                                       
      INTEGER  NITEMS, IOUT, MCOL, W, D                                 
      DOUBLE PRECISION  A(NITEMS)                                       
C                                                                       
      INTEGER  MAX0, MIN0, WW, DD, EMIN, EMAX,                          
     1         EXPENT, I1MACH, ICEIL, IABS, I10WID                      
C/6S                                                                    
C     INTEGER  IFMT1(20), IFMT1C(20), IFMT2(18), IFMT2C(18), BLANK, STAR
C     EQUIVALENCE (IFMT1(1), IFMT1C(1)), (IFMT2(1), IFMT2C(1))          
C/7S                                                                    
      CHARACTER*1  IFMT1(20), IFMT2(18), BLANK, STAR                    
      CHARACTER*20 IFMT1C                                               
      CHARACTER*18 IFMT2C                                               
      EQUIVALENCE (IFMT1(1), IFMT1C), (IFMT2(1), IFMT2C)                
C/                                                                      
      INTEGER  INDW, NCOL, COUNT, I, J, K, ILINE, ILAST                 
      LOGICAL  DUP                                                      
      DOUBLE PRECISION  LINE(18), LAST(18)                              
      REAL  LOGETA                                                      
C                                                                       
C/6S                                                                    
C     DATA BLANK/1H /, STAR/1H*/, INDW/7/, EXPENT/0/                    
C/7S                                                                    
      DATA BLANK/' '/, STAR/'*'/, INDW/7/, EXPENT/0/                    
C/                                                                      
C                                                                       
C  IFMT1 IS FOR THE ASTERISK LINES- IFMT2 FOR THE DATA LINES            
C                                                                       
C/6S                                                                    
C     DATA IFMT1( 1) /1H(/,  IFMT2( 1) /1H(/                            
C     DATA IFMT1( 2) /1H1/,  IFMT2( 2) /1H1/                            
C     DATA IFMT1( 3) /1HA/,  IFMT2( 3) /1HA/                            
C     DATA IFMT1( 4) /1H1/,  IFMT2( 4) /1H1/                            
C     DATA IFMT1( 5) /1H,/,  IFMT2( 5) /1H,/                            
C     DATA IFMT1( 6) /1H5/,  IFMT2( 6) /1HI/                            
C     DATA IFMT1( 7) /1HX/,  IFMT2( 7) /1H7/                            
C     DATA IFMT1( 8) /1H,/,  IFMT2( 8) /1H,/                            
C     DATA IFMT1( 9) /1H2/,  IFMT2( 9) /1H1/                            
C     DATA IFMT1(10) /1HA/,  IFMT2(10) /1HP/                            
C     DATA IFMT1(11) /1H1/,  IFMT2(11) /1H /                            
C     DATA IFMT1(12) /1H,/,  IFMT2(12) /1HD/                            
C     DATA IFMT1(13) /1H /,  IFMT2(13) /1H /                            
C     DATA IFMT1(14) /1H /,  IFMT2(14) /1H /                            
C     DATA IFMT1(15) /1HX/,  IFMT2(15) /1H./                            
C     DATA IFMT1(16) /1H,/,  IFMT2(16) /1H /                            
C     DATA IFMT1(17) /1H2/,  IFMT2(17) /1H /                            
C     DATA IFMT1(18) /1HA/,  IFMT2(18) /1H)/                            
C     DATA IFMT1(19) /1H1/                                              
C     DATA IFMT1(20) /1H)/                                              
C/7S                                                                    
      DATA IFMT1( 1) /'('/,  IFMT2( 1) /'('/                            
      DATA IFMT1( 2) /'1'/,  IFMT2( 2) /'1'/                            
      DATA IFMT1( 3) /'A'/,  IFMT2( 3) /'A'/                            
      DATA IFMT1( 4) /'1'/,  IFMT2( 4) /'1'/                            
      DATA IFMT1( 5) /','/,  IFMT2( 5) /','/                            
      DATA IFMT1( 6) /'5'/,  IFMT2( 6) /'I'/                            
      DATA IFMT1( 7) /'X'/,  IFMT2( 7) /'7'/                            
      DATA IFMT1( 8) /','/,  IFMT2( 8) /','/                            
      DATA IFMT1( 9) /'2'/,  IFMT2( 9) /'1'/                            
      DATA IFMT1(10) /'A'/,  IFMT2(10) /'P'/                            
      DATA IFMT1(11) /'1'/,  IFMT2(11) /' '/                            
      DATA IFMT1(12) /','/,  IFMT2(12) /'D'/                            
      DATA IFMT1(13) /' '/,  IFMT2(13) /' '/                            
      DATA IFMT1(14) /' '/,  IFMT2(14) /' '/                            
      DATA IFMT1(15) /'X'/,  IFMT2(15) /'.'/                            
      DATA IFMT1(16) /','/,  IFMT2(16) /' '/                            
      DATA IFMT1(17) /'2'/,  IFMT2(17) /' '/                            
      DATA IFMT1(18) /'A'/,  IFMT2(18) /')'/                            
      DATA IFMT1(19) /'1'/                                              
      DATA IFMT1(20) /')'/                                              
C/                                                                      
C                                                                       
C     EXPENT IS USED AS A FIRST-TIME SWITCH TO SIGNAL IF THE            
C     MACHINE-VALUE CONSTANTS HAVE BEEN COMPUTED.                       
C                                                                       
      IF (EXPENT .GT. 0) GO TO 10                                       
         LOGETA = ALOG10(FLOAT(I1MACH(10)))                             
         EMIN = ICEIL(LOGETA*FLOAT(IABS(I1MACH(15)-1)))                 
         EMAX = ICEIL(LOGETA*FLOAT(I1MACH(16)))                         
         EXPENT = I10WID(MAX0(EMIN, EMAX))                              
C                                                                       
C     COMPUTE THE FORMATS.                                              
C                                                                       
   10 WW = MIN0(99, MAX0(W, 5+EXPENT))                                  
      CALL S88FMT(2, WW, IFMT2(13))                                     
      DD = MIN0(D, (WW-(5+EXPENT)))                                     
      CALL S88FMT(2, DD, IFMT2(16))                                     
C                                                                       
C  NCOL IS THE NUMBER OF VALUES TO BE PRINTED ACROSS THE LINE.          
C                                                                       
      NCOL = MAX0(1, MIN0(9, (MIN0(MCOL,160)-INDW)/WW))                 
      CALL S88FMT(1, NCOL, IFMT2(11))                                   
      WW = WW-2                                                         
C  THE ASTERISKS ARE POSITIONED RIGHT-ADJUSTED IN THE W-WIDTH SPACE.    
      CALL S88FMT(2, WW, IFMT1(13))                                     
C                                                                       
C  I COUNTS THE NUMBER OF ITEMS TO BE PRINTED,                          
C  J COUNTS THE NUMBER ON A GIVEN LINE,                                 
C  COUNT COUNTS THE NUMBER OF DUPLICATE LINES.                          
C                                                                       
      I = 1                                                             
      J = 0                                                             
      COUNT = 0                                                         
C                                                                       
C  THE LOGICAL OF THE FOLLOWING IS ROUGHLY THIS -                       
C  IF THERE ARE STILL MORE ITEMS TO BE PRINTED, A LINE-                 
C  FULL IS PUT INTO THE ARRAY, LINE.                                    
C  WHENEVER A LINE IS PRINTED OUT, IT IS ALSO STUFFED INTO              
C  THE ARRAY, LAST, TO COMPARE WITH THE NEXT ONE COMING IN              
C  TO CHECK FOR REPEAT OR DUPLICATED LINES.                             
C  ALSO WHENEVER A LINE IS WRITTEN OUT, THE DUPLICATION                 
C  COUNTER, COUNT, IS SET TO ONE.                                       
C  THE ONLY MILDLY TRICKY PART IS TO NOTE THAT COUNT HAS TO             
C  GO TO 3 BEFORE A LINE OF ASTERISKS IS PRINTED BECAUSE                
C  OF COURSE NO SUCH LINE IS PRINTED FOR JUST A PAIR OF                 
C  DUPLICATE LINES.                                                     
C                                                                       
C  ILINE IS PRINTED AS THE INDEX OF THE FIRST ARRAY ELEMENT             
C  IN A LINE.                                                           
C                                                                       
   20 IF (I .GT. NITEMS)  GO TO 90                                      
        J = J+1                                                         
        LINE(J) = A(I)                                                  
        IF (J .EQ. 1) ILINE = I                                         
        IF (J .LT. NCOL .AND. I .LT. NITEMS) GO TO 80                   
          IF (COUNT .EQ. 0) GO TO 50                                    
            DUP = .TRUE.                                                
            DO 30 K=1,NCOL                                              
   30         IF (LAST(K) .NE. LINE(K)) DUP = .FALSE.                   
            IF (I .EQ. NITEMS  .AND.  J .LT. NCOL) DUP = .FALSE.        
            IF (.NOT. DUP .AND. COUNT .EQ. 1) GO TO 50                  
              IF (.NOT. DUP) GO TO 40                                   
                COUNT = COUNT+1                                         
                IF (COUNT .EQ. 3) WRITE(IOUT, IFMT1C) BLANK,            
     1                                 STAR, STAR, STAR, STAR           
                IF (I .EQ. NITEMS)  GO TO 50                            
                  GO TO 70                                              
   40         WRITE(IOUT, IFMT2C) BLANK, ILAST, (LAST(K), K=1,NCOL)     
   50     WRITE(IOUT, IFMT2C) BLANK, ILINE, (LINE(K), K=1,J)            
          COUNT = 1                                                     
          DO 60 K=1,NCOL                                                
   60       LAST(K) = LINE(K)                                           
   70     ILAST = ILINE                                                 
          J = 0                                                         
   80   I = I+1                                                         
        GO TO 20                                                        
   90 RETURN                                                            
      END                                                               
      SUBROUTINE A9RNTI(A, NITEMS, IOUT, MCOL, W)                       
C                                                                       
C  THIS IS THE DOCUMENTED ROUTINE APRNTI, BUT WITHOUT THE CALLS TO      
C  SETERR - BECAUSE IT IS CALLED BY SETERR.                             
C                                                                       
C  THIS SUBROUTINE PRINTS OUT NITEMS FROM THE INTEGER ARRAY, A, ON      
C  OUTPUT UNIT IOUT, USING A MAXIMUM OF MCOL PRINT SPACES.              
C  THE OUTPUT FORMAT IS IW.                                             
C  THE PROGRAM PUTS AS MANY VALUES ON A LINE AS POSSIBLE.               
C  W SHOULD BE INPUT AS THE ACTUAL WIDTH +1 FOR A SPACE BETWEEN VALUES. 
C                                                                       
C  DUPLICATE LINES ARE NOT ALL PRINTED, BUT ARE INDICATED BY ASTERISKS. 
C                                                                       
C  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, OCTOBER 21, 1982.        
C                                                                       
C  THE LINE WIDTH IS COMPUTED AS THE MINIMUM OF THE INPUT MCOL AND 160. 
C  IF THE LINE WIDTH IS TO BE INCREASED ABOVE 160, THE BUFFERS LINE()   
C  AND LAST(), WHICH THE VALUES TO BE PRINTED ON ONE LINE, MUST         
C  BE DIMENSIONED ACCORDINGLY.                                          
C                                                                       
C  INPUT PARAMETERS -                                                   
C                                                                       
C    A        - THE START OF THE INTEGER ARRAY TO BE PRINTED            
C                                                                       
C    NITEMS   - THE NUMBER OF ITEMS TO BE PRINTED                       
C                                                                       
C    IOUT     - THE OUTPUT UNIT FOR PRINTING                            
C                                                                       
C    MCOL     - THE NUMBER OF SPACES ACROSS THE LINE                    
C                                                                       
C    W        - THE WIDTH OF THE PRINTED VALUE (IW)                     
C                                                                       
C                                                                       
C  ERROR STATES - NONE. LOWER LEVEL ROUTINE CALLED BY                   
C  SETERR, SO IT CANNOT CALL SETERR.                                    
C                                                                       
C                                                                       
      INTEGER  NITEMS, IOUT, MCOL, W                                    
      INTEGER  A(NITEMS)                                                
C                                                                       
      INTEGER  MAX0, MIN0, WW                                           
C/6S                                                                    
C     INTEGER  IFMT1(20), IFMT1C(20), IFMT2(14), IFMT2C(14), BLANK, STAR
C     EQUIVALENCE (IFMT1(1), IFMT1C(1)), (IFMT2(1), IFMT2C(1))          
C/7S                                                                    
      CHARACTER*1  IFMT1(20), IFMT2(14), BLANK, STAR                    
      CHARACTER*20 IFMT1C                                               
      CHARACTER*14 IFMT2C                                               
      EQUIVALENCE (IFMT1(1), IFMT1C), (IFMT2(1), IFMT2C)                
C/                                                                      
      INTEGER  INDW, NCOL, COUNT, I, J, K, ILINE, ILAST                 
      LOGICAL  DUP                                                      
      INTEGER  LINE(40), LAST(40)                                       
C                                                                       
C/6S                                                                    
C     DATA BLANK/1H /, STAR/1H*/, INDW/7/                               
C/7S                                                                    
      DATA BLANK/' '/, STAR/'*'/, INDW/7/                               
C/                                                                      
C                                                                       
C  IFMT1 IS FOR THE ASTERISK LINES- IFMT2 FOR THE DATA LINES            
C                                                                       
C/6S                                                                    
C     DATA IFMT1( 1) /1H(/,  IFMT2( 1) /1H(/                            
C     DATA IFMT1( 2) /1H1/,  IFMT2( 2) /1H1/                            
C     DATA IFMT1( 3) /1HA/,  IFMT2( 3) /1HA/                            
C     DATA IFMT1( 4) /1H1/,  IFMT2( 4) /1H1/                            
C     DATA IFMT1( 5) /1H,/,  IFMT2( 5) /1H,/                            
C     DATA IFMT1( 6) /1H5/,  IFMT2( 6) /1HI/                            
C     DATA IFMT1( 7) /1HX/,  IFMT2( 7) /1H7/                            
C     DATA IFMT1( 8) /1H,/,  IFMT2( 8) /1H,/                            
C     DATA IFMT1( 9) /1H2/,  IFMT2( 9) /1H /                            
C     DATA IFMT1(10) /1HA/,  IFMT2(10) /1H /                            
C     DATA IFMT1(11) /1H1/,  IFMT2(11) /1HI/                            
C     DATA IFMT1(12) /1H,/,  IFMT2(12) /1H /                            
C     DATA IFMT1(13) /1H /,  IFMT2(13) /1H /                            
C     DATA IFMT1(14) /1H /,  IFMT2(14) /1H)/                            
C     DATA IFMT1(15) /1HX/                                              
C     DATA IFMT1(16) /1H,/                                              
C     DATA IFMT1(17) /1H2/                                              
C     DATA IFMT1(18) /1HA/                                              
C     DATA IFMT1(19) /1H1/                                              
C     DATA IFMT1(20) /1H)/                                              
C/7S                                                                    
      DATA IFMT1( 1) /'('/,  IFMT2( 1) /'('/                            
      DATA IFMT1( 2) /'1'/,  IFMT2( 2) /'1'/                            
      DATA IFMT1( 3) /'A'/,  IFMT2( 3) /'A'/                            
      DATA IFMT1( 4) /'1'/,  IFMT2( 4) /'1'/                            
      DATA IFMT1( 5) /','/,  IFMT2( 5) /','/                            
      DATA IFMT1( 6) /'5'/,  IFMT2( 6) /'I'/                            
      DATA IFMT1( 7) /'X'/,  IFMT2( 7) /'7'/                            
      DATA IFMT1( 8) /','/,  IFMT2( 8) /','/                            
      DATA IFMT1( 9) /'2'/,  IFMT2( 9) /' '/                            
      DATA IFMT1(10) /'A'/,  IFMT2(10) /' '/                            
      DATA IFMT1(11) /'1'/,  IFMT2(11) /'I'/                            
      DATA IFMT1(12) /','/,  IFMT2(12) /' '/                            
      DATA IFMT1(13) /' '/,  IFMT2(13) /' '/                            
      DATA IFMT1(14) /' '/,  IFMT2(14) /')'/                            
      DATA IFMT1(15) /'X'/                                              
      DATA IFMT1(16) /','/                                              
      DATA IFMT1(17) /'2'/                                              
      DATA IFMT1(18) /'A'/                                              
      DATA IFMT1(19) /'1'/                                              
      DATA IFMT1(20) /')'/                                              
C/                                                                      
C                                                                       
C     COMPUTE THE FORMATS.                                              
C                                                                       
        WW = MIN0(99, MAX0(W, 2))                                       
        CALL S88FMT(2, WW, IFMT2(12))                                   
        NCOL = MAX0(1, MIN0(99, (MIN0(MCOL,160) - INDW)/WW))            
        CALL S88FMT(2, NCOL, IFMT2(9))                                  
        WW = WW-2                                                       
        CALL S88FMT(2, WW, IFMT1(13))                                   
C                                                                       
C  THE ASTERISKS ARE POSITIONED RIGHT-ADJUSTED IN THE W-WIDTH SPACE.    
      CALL S88FMT(2, WW, IFMT1(13))                                     
C                                                                       
C  I COUNTS THE NUMBER OF ITEMS TO BE PRINTED,                          
C  J COUNTS THE NUMBER ON A GIVEN LINE,                                 
C  COUNT COUNTS THE NUMBER OF DUPLICATE LINES.                          
C                                                                       
  10  I = 1                                                             
      J = 0                                                             
      COUNT = 0                                                         
C                                                                       
C  THE LOGICAL OF THE FOLLOWING IS ROUGHLY THIS -                       
C  IF THERE ARE STILL MORE ITEMS TO BE PRINTED, A LINE-                 
C  FULL IS PUT INTO THE ARRAY, LINE.                                    
C  WHENEVER A LINE IS PRINTED OUT, IT IS ALSO STUFFED INTO              
C  THE ARRAY, LAST, TO COMPARE WITH THE NEXT ONE COMING IN              
C  TO CHECK FOR REPEAT OR DUPLICATED LINES.                             
C  ALSO WHENEVER A LINE IS WRITTEN OUT, THE DUPLICATION                 
C  COUNTER, COUNT, IS SET TO ONE.                                       
C  THE ONLY MILDLY TRICKY PART IS TO NOTE THAT COUNT HAS TO             
C  GO TO 3 BEFORE A LINE OF ASTERISKS IS PRINTED BECAUSE                
C  OF COURSE NO SUCH LINE IS PRINTED FOR JUST A PAIR OF                 
C  DUPLICATE LINES.                                                     
C                                                                       
C  ILINE IS PRINTED AS THE INDEX OF THE FIRST ARRAY ELEMENT             
C  IN A LINE.                                                           
C                                                                       
   20 IF (I .GT. NITEMS)  GO TO 90                                      
        J = J+1                                                         
        LINE(J) = A(I)                                                  
        IF (J .EQ. 1) ILINE = I                                         
        IF (J .LT. NCOL .AND. I .LT. NITEMS) GO TO 80                   
          IF (COUNT .EQ. 0) GO TO 50                                    
            DUP = .TRUE.                                                
            DO 30 K=1,NCOL                                              
   30         IF (LAST(K) .NE. LINE(K)) DUP = .FALSE.                   
            IF (I .EQ. NITEMS  .AND.  J .LT. NCOL) DUP = .FALSE.        
            IF (.NOT. DUP .AND. COUNT .EQ. 1) GO TO 50                  
              IF (.NOT. DUP) GO TO 40                                   
                COUNT = COUNT+1                                         
                IF (COUNT .EQ. 3) WRITE(IOUT, IFMT1C) BLANK,            
     1                                 STAR, STAR, STAR, STAR           
                IF (I .EQ. NITEMS)  GO TO 50                            
                  GO TO 70                                              
   40         WRITE(IOUT, IFMT2C) BLANK, ILAST, (LAST(K), K=1,NCOL)     
   50     WRITE(IOUT, IFMT2C) BLANK, ILINE, (LINE(K), K=1,J)            
          COUNT = 1                                                     
          DO 60 K=1,NCOL                                                
   60       LAST(K) = LINE(K)                                           
   70     ILAST = ILINE                                                 
          J = 0                                                         
   80   I = I+1                                                         
        GO TO 20                                                        
   90 RETURN                                                            
      END                                                               
      SUBROUTINE A9RNTL(A, NITEMS, IOUT, MCOL)                          
C                                                                       
C  THIS IS THE DOCUMENTED ROUTINE APRNTL, BUT WITHOUT THE CALLS TO      
C  SETERR - BECAUSE IT IS CALLED BY SETERR.                             
C                                                                       
C  THIS SUBROUTINE PRINTS OUT NITEMS FROM THE LOGICAL ARRAY, A, ON      
C  OUTPUT UNIT IOUT, USING A MAXIMUM OF MCOL PRINT SPACES.              
C  THE T OR F VALUES ARE PRINTED RIGHT-ADJUSTED IN A FIELD OF WIDTH 4.  
C                                                                       
C  DUPLICATE LINES ARE NOT ALL PRINTED, BUT ARE INDICATED BY ASTERISKS. 
C                                                                       
C  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, OCTOBER 21, 1982.        
C                                                                       
C  THE LINE WIDTH IS COMPUTED AS THE MINIMUM OF THE INPUT MCOL AND 160. 
C  IF THE LINE WIDTH IS TO BE INCREASED ABOVE 160, THE BUFFERS LINE()   
C  AND LAST(), WHICH THE VALUES TO BE PRINTED ON ONE LINE, MUST         
C  BE DIMENSIONED ACCORDINGLY.                                          
C                                                                       
C  INPUT PARAMETERS -                                                   
C                                                                       
C    A        - THE START OF THE LOGICAL ARRAY TO BE PRINTED            
C                                                                       
C    NITEMS   - THE NUMBER OF ITEMS TO BE PRINTED                       
C                                                                       
C    IOUT     - THE OUTPUT UNIT FOR PRINTING                            
C                                                                       
C    MCOL     - THE NUMBER OF SPACES ACROSS THE LINE                    
C                                                                       
C                                                                       
C  ERROR STATES - NONE.  LOWER LEVEL ROUTINE CALLED BY                  
C  SETERR, SO IT CANNOT CALL SETERR.                                    
C                                                                       
C                                                                       
      INTEGER  NITEMS, IOUT, MCOL                                       
      LOGICAL  A(NITEMS)                                                
C                                                                       
      INTEGER  MAX0, MIN0                                               
C/6S                                                                    
C     INTEGER  IFMT1(20), IFMT1C(20), IFMT2(19), IFMT2C(19), BLANK,     
C    1         STAR, TCHAR, FCHAR                                       
C     INTEGER  LINE(40), LAST(40)                                       
C     EQUIVALENCE (IFMT1(1), IFMT1C(1)), (IFMT2(1), IFMT2C(1))          
C/7S                                                                    
      CHARACTER*1  IFMT1(20), IFMT2(19), BLANK, STAR, TCHAR, FCHAR      
      CHARACTER*20 IFMT1C                                               
      CHARACTER*19 IFMT2C                                               
      EQUIVALENCE (IFMT1(1), IFMT1C), (IFMT2(1), IFMT2C)                
      CHARACTER*1  LINE(40), LAST(40)                                   
C/                                                                      
      INTEGER  INDW, NCOL, COUNT, I, J, K, ILINE, ILAST                 
      LOGICAL  DUP                                                      
C                                                                       
C/6S                                                                    
C     DATA BLANK/1H /, STAR/1H*/, TCHAR/1HT/, FCHAR/1HF/, INDW/7/       
C/7S                                                                    
      DATA BLANK/' '/, STAR/'*'/, TCHAR/'T'/, FCHAR/'F'/, INDW/7/       
C/                                                                      
C                                                                       
C                                                                       
C  IFMT1 IS FOR THE ASTERISK LINES- IFMT2 FOR THE DATA LINES            
C                                                                       
C/6S                                                                    
C     DATA IFMT1( 1) /1H(/,  IFMT2( 1) /1H(/                            
C     DATA IFMT1( 2) /1H1/,  IFMT2( 2) /1H1/                            
C     DATA IFMT1( 3) /1HA/,  IFMT2( 3) /1HA/                            
C     DATA IFMT1( 4) /1H1/,  IFMT2( 4) /1H1/                            
C     DATA IFMT1( 5) /1H,/,  IFMT2( 5) /1H,/                            
C     DATA IFMT1( 6) /1H5/,  IFMT2( 6) /1HI/                            
C     DATA IFMT1( 7) /1HX/,  IFMT2( 7) /1H7/                            
C     DATA IFMT1( 8) /1H,/,  IFMT2( 8) /1H,/                            
C     DATA IFMT1( 9) /1H2/,  IFMT2( 9) /1H /                            
C     DATA IFMT1(10) /1HA/,  IFMT2(10) /1H /                            
C     DATA IFMT1(11) /1H1/,  IFMT2(11) /1H(/                            
C     DATA IFMT1(12) /1H,/,  IFMT2(12) /1H3/                            
C     DATA IFMT1(13) /1H /,  IFMT2(13) /1HX/                            
C     DATA IFMT1(14) /1H2/,  IFMT2(14) /1H,/                            
C     DATA IFMT1(15) /1HX/,  IFMT2(15) /1H1/                            
C     DATA IFMT1(16) /1H,/,  IFMT2(16) /1HA/                            
C     DATA IFMT1(17) /1H2/,  IFMT2(17) /1H1/                            
C     DATA IFMT1(18) /1HA/,  IFMT2(18) /1H)/                            
C     DATA IFMT1(19) /1H1/,  IFMT2(19) /1H)/                            
C     DATA IFMT1(20) /1H)/                                              
C/7S                                                                    
      DATA IFMT1( 1) /'('/,  IFMT2( 1) /'('/                            
      DATA IFMT1( 2) /'1'/,  IFMT2( 2) /'1'/                            
      DATA IFMT1( 3) /'A'/,  IFMT2( 3) /'A'/                            
      DATA IFMT1( 4) /'1'/,  IFMT2( 4) /'1'/                            
      DATA IFMT1( 5) /','/,  IFMT2( 5) /','/                            
      DATA IFMT1( 6) /'5'/,  IFMT2( 6) /'I'/                            
      DATA IFMT1( 7) /'X'/,  IFMT2( 7) /'7'/                            
      DATA IFMT1( 8) /','/,  IFMT2( 8) /','/                            
      DATA IFMT1( 9) /'2'/,  IFMT2( 9) /' '/                            
      DATA IFMT1(10) /'A'/,  IFMT2(10) /' '/                            
      DATA IFMT1(11) /'1'/,  IFMT2(11) /'('/                            
      DATA IFMT1(12) /','/,  IFMT2(12) /'3'/                            
      DATA IFMT1(13) /' '/,  IFMT2(13) /'X'/                            
      DATA IFMT1(14) /'2'/,  IFMT2(14) /','/                            
      DATA IFMT1(15) /'X'/,  IFMT2(15) /'1'/                            
      DATA IFMT1(16) /','/,  IFMT2(16) /'A'/                            
      DATA IFMT1(17) /'2'/,  IFMT2(17) /'1'/                            
      DATA IFMT1(18) /'A'/,  IFMT2(18) /')'/                            
      DATA IFMT1(19) /'1'/,  IFMT2(19) /')'/                            
      DATA IFMT1(20) /')'/                                              
C/                                                                      
C                                                                       
C                                                                       
C  COMPUTE THE NUMBER OF FIELDS OF 4 ACROSS A LINE.                     
C                                                                       
      NCOL = MAX0(1, MIN0(99, (MIN0(MCOL,160)-INDW)/4))                 
C                                                                       
C  THE ASTERISKS ARE POSITIONED RIGHT-ADJUSTED IN THE 4-CHARACTER SPACE.
      CALL S88FMT(2, NCOL, IFMT2(9))                                    
C                                                                       
C  I COUNTS THE NUMBER OF ITEMS TO BE PRINTED,                          
C  J COUNTS THE NUMBER ON A GIVEN LINE,                                 
C  COUNT COUNTS THE NUMBER OF DUPLICATE LINES.                          
C                                                                       
  10  I = 1                                                             
      J = 0                                                             
      COUNT = 0                                                         
C                                                                       
C  THE LOGICAL OF THE FOLLOWING IS ROUGHLY THIS -                       
C  IF THERE ARE STILL MORE ITEMS TO BE PRINTED, A LINE-                 
C  FULL IS PUT INTO THE ARRAY, LINE.                                    
C  WHENEVER A LINE IS PRINTED OUT, IT IS ALSO STUFFED INTO              
C  THE ARRAY, LAST, TO COMPARE WITH THE NEXT ONE COMING IN              
C  TO CHECK FOR REPEAT OR DUPLICATED LINES.                             
C  ALSO WHENEVER A LINE IS WRITTEN OUT, THE DUPLICATION                 
C  COUNTER, COUNT, IS SET TO ONE.                                       
C  THE ONLY MILDLY TRICKY PART IS TO NOTE THAT COUNT HAS TO             
C  GO TO 3 BEFORE A LINE OF ASTERISKS IS PRINTED BECAUSE                
C  OF COURSE NO SUCH LINE IS PRINTED FOR JUST A PAIR OF                 
C  DUPLICATE LINES.                                                     
C                                                                       
C  ILINE IS PRINTED AS THE INDEX OF THE FIRST ARRAY ELEMENT             
C  IN A LINE.                                                           
C                                                                       
   20 IF (I .GT. NITEMS)  GO TO 90                                      
        J = J+1                                                         
        LINE(J) = FCHAR                                                 
        IF ( A(I) )  LINE(J) = TCHAR                                    
        IF (J .EQ. 1) ILINE = I                                         
        IF (J .LT. NCOL .AND. I .LT. NITEMS) GO TO 80                   
          IF (COUNT .EQ. 0) GO TO 50                                    
            DUP = .TRUE.                                                
            DO 30 K=1,NCOL                                              
   30         IF (LAST(K) .NE. LINE(K)) DUP = .FALSE.                   
            IF (I .EQ. NITEMS  .AND.  J .LT. NCOL) DUP = .FALSE.        
            IF (.NOT. DUP .AND. COUNT .EQ. 1) GO TO 50                  
              IF (.NOT. DUP) GO TO 40                                   
                COUNT = COUNT+1                                         
                IF (COUNT .EQ. 3) WRITE(IOUT, IFMT1C) BLANK,            
     1                                 STAR, STAR, STAR, STAR           
                IF (I .EQ. NITEMS)  GO TO 50                            
                  GO TO 70                                              
   40         WRITE(IOUT, IFMT2C) BLANK, ILAST, (LAST(K), K=1,NCOL)     
   50     WRITE(IOUT, IFMT2C) BLANK, ILINE, (LINE(K), K=1,J)            
          COUNT = 1                                                     
          DO 60 K=1,NCOL                                                
   60       LAST(K) = LINE(K)                                           
   70     ILAST = ILINE                                                 
          J = 0                                                         
   80   I = I+1                                                         
        GO TO 20                                                        
   90 RETURN                                                            
      END                                                               
      SUBROUTINE A9RNTR(A, NITEMS, IOUT, MCOL, W, D)                    
C                                                                       
C  THIS IS THE DOCUMENTED ROUTINE APRNTR, BUT WITHOUT THE CALLS TO      
C  SETERR - BECAUSE IT IS CALLED BY SETERR.                             
C                                                                       
C  THIS SUBROUTINE PRINTS OUT NITEMS FROM THE REAL ARRAY, A, ON         
C  OUTPUT UNIT IOUT, USING A MAXIMUM OF MCOL PRINT SPACES.              
C  THE OUTPUT FORMAT IS 1PEW.D.                                         
C  THE PROGRAM PUTS AS MANY VALUES ON A LINE AS POSSIBLE.               
C  W SHOULD BE INPUT AS THE ACTUAL WIDTH +1 FOR A SPACE BETWEEN VALUES. 
C                                                                       
C  DUPLICATE LINES ARE NOT ALL PRINTED, BUT ARE INDICATED BY ASTERISKS. 
C                                                                       
C  WRITTEN BY DAN WARNER, REVISED BY PHYL FOX, OCTOBER 21, 1982.        
C                                                                       
C  THE LINE WIDTH IS COMPUTED AS THE MINIMUM OF THE INPUT MCOL AND 160. 
C  IF THE LINE WIDTH IS TO BE INCREASED ABOVE 160, THE BUFFERS LINE()   
C  AND LAST(), WHICH THE VALUES TO BE PRINTED ON ONE LINE, MUST         
C  BE DIMENSIONED ACCORDINGLY.                                          
C                                                                       
C  INPUT PARAMETERS -                                                   
C                                                                       
C    A        - THE START OF THE REAL ARRAY TO BE PRINTED               
C                                                                       
C    NITEMS   - THE NUMBER OF ITEMS TO BE PRINTED                       
C                                                                       
C    IOUT     - THE OUTPUT UNIT FOR PRINTING                            
C                                                                       
C    MCOL     - THE NUMBER OF SPACES ACROSS THE LINE                    
C                                                                       
C    W        - THE WIDTH OF THE PRINTED VALUE (1PEW.D)                 
C                                                                       
C    D        - THE NUMBER OF DIGITS AFTER THE DECIMAL POINT (1PEW.D)   
C                                                                       
C                                                                       
C  ERROR STATES - NONE.  LOWER LEVEL ROUTINE CALLED BY                  
C  SETERR, SO IT CANNOT CALL SETERR.                                    
C                                                                       
C                                                                       
      INTEGER  NITEMS, IOUT, MCOL, W, D                                 
      REAL     A(NITEMS)                                                
C                                                                       
      INTEGER  MAX0, MIN0, WW, DD, EMIN, EMAX,                          
     1         EXPENT, I1MACH, ICEIL, IABS, I10WID                      
C/6S                                                                    
C     INTEGER  IFMT1(20), IFMT1C(20), IFMT2(18), IFMT2C(18), BLANK, STAR
C     EQUIVALENCE (IFMT1(1), IFMT1C(1)), (IFMT2(1), IFMT2C(1))          
C/7S                                                                    
      CHARACTER*1  IFMT1(20), IFMT2(18), BLANK, STAR                    
      CHARACTER*20 IFMT1C                                               
      CHARACTER*18 IFMT2C                                               
      EQUIVALENCE (IFMT1(1), IFMT1C), (IFMT2(1), IFMT2C)                
C/                                                                      
      INTEGER  INDW, NCOL, COUNT, I, J, K, ILINE, ILAST                 
      LOGICAL  DUP                                                      
      REAL     LINE(18), LAST(18), LOGETA                               
C                                                                       
C/6S                                                                    
C     DATA BLANK/1H /, STAR/1H*/, INDW/7/, EXPENT/0/                    
C/7S                                                                    
      DATA BLANK/' '/, STAR/'*'/, INDW/7/, EXPENT/0/                    
C/                                                                      
C                                                                       
C  IFMT1 IS FOR THE ASTERISK LINES- IFMT2 FOR THE DATA LINES            
C                                                                       
C/6S                                                                    
C     DATA IFMT1( 1) /1H(/,  IFMT2( 1) /1H(/                            
C     DATA IFMT1( 2) /1H1/,  IFMT2( 2) /1H1/                            
C     DATA IFMT1( 3) /1HA/,  IFMT2( 3) /1HA/                            
C     DATA IFMT1( 4) /1H1/,  IFMT2( 4) /1H1/                            
C     DATA IFMT1( 5) /1H,/,  IFMT2( 5) /1H,/                            
C     DATA IFMT1( 6) /1H5/,  IFMT2( 6) /1HI/                            
C     DATA IFMT1( 7) /1HX/,  IFMT2( 7) /1H7/                            
C     DATA IFMT1( 8) /1H,/,  IFMT2( 8) /1H,/                            
C     DATA IFMT1( 9) /1H2/,  IFMT2( 9) /1H1/                            
C     DATA IFMT1(10) /1HA/,  IFMT2(10) /1HP/                            
C     DATA IFMT1(11) /1H1/,  IFMT2(11) /1H /                            
C     DATA IFMT1(12) /1H,/,  IFMT2(12) /1HE/                            
C     DATA IFMT1(13) /1H /,  IFMT2(13) /1H /                            
C     DATA IFMT1(14) /1H /,  IFMT2(14) /1H /                            
C     DATA IFMT1(15) /1HX/,  IFMT2(15) /1H./                            
C     DATA IFMT1(16) /1H,/,  IFMT2(16) /1H /                            
C     DATA IFMT1(17) /1H2/,  IFMT2(17) /1H /                            
C     DATA IFMT1(18) /1HA/,  IFMT2(18) /1H)/                            
C     DATA IFMT1(19) /1H1/                                              
C     DATA IFMT1(20) /1H)/                                              
C/7S                                                                    
      DATA IFMT1( 1) /'('/,  IFMT2( 1) /'('/                            
      DATA IFMT1( 2) /'1'/,  IFMT2( 2) /'1'/                            
      DATA IFMT1( 3) /'A'/,  IFMT2( 3) /'A'/                            
      DATA IFMT1( 4) /'1'/,  IFMT2( 4) /'1'/                            
      DATA IFMT1( 5) /','/,  IFMT2( 5) /','/                            
      DATA IFMT1( 6) /'5'/,  IFMT2( 6) /'I'/                            
      DATA IFMT1( 7) /'X'/,  IFMT2( 7) /'7'/                            
      DATA IFMT1( 8) /','/,  IFMT2( 8) /','/                            
      DATA IFMT1( 9) /'2'/,  IFMT2( 9) /'1'/                            
      DATA IFMT1(10) /'A'/,  IFMT2(10) /'P'/                            
      DATA IFMT1(11) /'1'/,  IFMT2(11) /' '/                            
      DATA IFMT1(12) /','/,  IFMT2(12) /'E'/                            
      DATA IFMT1(13) /' '/,  IFMT2(13) /' '/                            
      DATA IFMT1(14) /' '/,  IFMT2(14) /' '/                            
      DATA IFMT1(15) /'X'/,  IFMT2(15) /'.'/                            
      DATA IFMT1(16) /','/,  IFMT2(16) /' '/                            
      DATA IFMT1(17) /'2'/,  IFMT2(17) /' '/                            
      DATA IFMT1(18) /'A'/,  IFMT2(18) /')'/                            
      DATA IFMT1(19) /'1'/                                              
      DATA IFMT1(20) /')'/                                              
C/                                                                      
C                                                                       
C                                                                       
C     EXPENT IS USED AS A FIRST-TIME SWITCH TO SIGNAL IF THE            
C     MACHINE-VALUE CONSTANTS HAVE BEEN COMPUTED.                       
C                                                                       
      IF (EXPENT .GT. 0) GO TO 10                                       
         LOGETA = ALOG10(FLOAT(I1MACH(10)))                             
         EMIN   = ICEIL(LOGETA*FLOAT(IABS(I1MACH(12)-1)))               
         EMAX   = ICEIL(LOGETA*FLOAT(I1MACH(13)))                       
         EXPENT = I10WID(MAX0(EMIN, EMAX))                              
C                                                                       
C     COMPUTE THE FORMATS.                                              
C                                                                       
   10 WW = MIN0(99, MAX0(W, 5+EXPENT))                                  
      CALL S88FMT(2, WW, IFMT2(13))                                     
      DD = MIN0(D, (WW-(5+EXPENT)))                                     
      CALL S88FMT(2, DD, IFMT2(16))                                     
C                                                                       
C  NCOL IS THE NUMBER OF VALUES TO BE PRINTED ACROSS THE LINE.          
C                                                                       
      NCOL = MAX0(1, MIN0(9, (MIN0(MCOL,160)-INDW)/WW))                 
      CALL S88FMT(1, NCOL, IFMT2(11))                                   
      WW = WW-2                                                         
C                                                                       
C  THE ASTERISKS ARE POSITIONED RIGHT-ADJUSTED IN THE W-WIDTH SPACE.    
      CALL S88FMT(2, WW, IFMT1(13))                                     
C                                                                       
C  I COUNTS THE NUMBER OF ITEMS TO BE PRINTED,                          
C  J COUNTS THE NUMBER ON A GIVEN LINE,                                 
C  COUNT COUNTS THE NUMBER OF DUPLICATE LINES.                          
C                                                                       
      I = 1                                                             
      J = 0                                                             
      COUNT = 0                                                         
C                                                                       
C  THE LOGICAL OF THE FOLLOWING IS ROUGHLY THIS -                       
C  IF THERE ARE STILL MORE ITEMS TO BE PRINTED, A LINE-                 
C  FULL IS PUT INTO THE ARRAY, LINE.                                    
C  WHENEVER A LINE IS PRINTED OUT, IT IS ALSO STUFFED INTO              
C  THE ARRAY, LAST, TO COMPARE WITH THE NEXT ONE COMING IN              
C  TO CHECK FOR REPEAT OR DUPLICATED LINES.                             
C  ALSO WHENEVER A LINE IS WRITTEN OUT, THE DUPLICATION                 
C  COUNTER, COUNT, IS SET TO ONE.                                       
C  THE ONLY MILDLY TRICKY PART IS TO NOTE THAT COUNT HAS TO             
C  GO TO 3 BEFORE A LINE OF ASTERISKS IS PRINTED BECAUSE                
C  OF COURSE NO SUCH LINE IS PRINTED FOR JUST A PAIR OF                 
C  DUPLICATE LINES.                                                     
C                                                                       
C  ILINE IS PRINTED AS THE INDEX OF THE FIRST ARRAY ELEMENT             
C  IN A LINE.                                                           
C                                                                       
   20 IF (I .GT. NITEMS)  GO TO 90                                      
        J = J+1                                                         
        LINE(J) = A(I)                                                  
        IF (J .EQ. 1) ILINE = I                                         
        IF (J .LT. NCOL .AND. I .LT. NITEMS) GO TO 80                   
          IF (COUNT .EQ. 0) GO TO 50                                    
            DUP = .TRUE.                                                
            DO 30 K=1,NCOL                                              
   30         IF (LAST(K) .NE. LINE(K)) DUP = .FALSE.                   
            IF (I .EQ. NITEMS  .AND.  J .LT. NCOL) DUP = .FALSE.        
            IF (.NOT. DUP .AND. COUNT .EQ. 1) GO TO 50                  
              IF (.NOT. DUP) GO TO 40                                   
                COUNT = COUNT+1                                         
                IF (COUNT .EQ. 3) WRITE(IOUT, IFMT1C) BLANK,            
     1                                 STAR, STAR, STAR, STAR           
                IF (I .EQ. NITEMS)  GO TO 50                            
                  GO TO 70                                              
   40         WRITE(IOUT, IFMT2C) BLANK, ILAST, (LAST(K), K=1,NCOL)     
   50     WRITE(IOUT, IFMT2C) BLANK, ILINE, (LINE(K), K=1,J)            
          COUNT = 1                                                     
          DO 60 K=1,NCOL                                                
   60       LAST(K) = LINE(K)                                           
   70     ILAST = ILINE                                                 
          J = 0                                                         
   80   I = I+1                                                         
        GO TO 20                                                        
   90 RETURN                                                            
      END                                                               
      SUBROUTINE FRMATD(WWIDTH, EWIDTH)                                 
C                                                                       
C  THIS SUBROUTINE COMPUTES, FOR THE FORMAT SPECIFICATION, DW.E, THE    
C  NUMBER OF DIGITS TO THE RIGHT OF THE DECIMAL POINT, E=EWIDTH, AND    
C  THE FIELD WIDTH, W=WWIDTH.                                           
C                                                                       
C  WWIDTH INCLUDES THE FIVE POSITIONS NEEDED FOR THE SIGN OF THE        
C  MANTISSA, THE SIGN OF THE EXPONENT, THE 0, THE DECIMAL POINT AND THE 
C  CHARACTER IN THE OUTPUT - +0.XXXXXXXXXD+YYYY                         
C                                                                       
C  THE FOLLOWING MACHINE-DEPENDENT VALUES ARE USED -                    
C                                                                       
C  I1MACH(10) - THE BASE, B                                             
C  I1MACH(14) - THE NUMBER OF BASE-B DIGITS IN THE MANTISSA             
C  I1MACH(15) - THE SMALLEST EXPONENT, EMIN                             
C  I1MACH(16) - THE LARGEST EXPONENT, EMAX                              
C                                                                       
      INTEGER I1MACH, ICEIL, IFLR, EWIDTH, WWIDTH                       
      INTEGER DEMIN, DEMAX, EXPWID                                      
      REAL BASE                                                         
C                                                                       
      BASE = I1MACH(10)                                                 
C                                                                       
      EWIDTH = ICEIL( ALOG10(BASE)*FLOAT(I1MACH(14)) )                  
C                                                                       
      DEMIN =  IFLR( ALOG10(BASE)*FLOAT(I1MACH(15)-1) ) + 1             
      DEMAX = ICEIL( ALOG10(BASE)*FLOAT(I1MACH(16)) )                   
      EXPWID = IFLR( ALOG10(FLOAT(MAX0(IABS(DEMIN),IABS(DEMAX)))) ) + 1 
      WWIDTH = EWIDTH + EXPWID + 5                                      
C                                                                       
      RETURN                                                            
      END                                                               
      SUBROUTINE FRMATI(IWIDTH)                                         
C                                                                       
C  THIS SUBROUTINE COMPUTES THE WIDTH, W=IWIDTH, IN THE FORMAT          
C  SPECIFICATION FOR INTEGER VARIABLES.                                 
C                                                                       
C  FRMATI SETS IWIDTH TO THE NUMBER OF CHARACTER POSITIONS NEEDED       
C  FOR WRITING OUT THE LARGEST INTEGER PLUS ONE POSITION FOR THE SIGN.  
C                                                                       
C  I1MACH(7) IS THE BASE, A, FOR INTEGER REPRESENTATION IN THE MACHINE. 
C  I1MACH(8) IS THE (MAXIMUM) NUMBER OF BASE A DIGITS.                  
C                                                                       
      INTEGER I1MACH, ICEIL, IWIDTH                                     
C                                                                       
      IWIDTH = ICEIL( ALOG10(FLOAT(I1MACH(7)))*FLOAT(I1MACH(8)) ) + 1   
C                                                                       
      RETURN                                                            
      END                                                               
      SUBROUTINE FRMATR(WWIDTH, EWIDTH)                                 
C                                                                       
C  THIS SUBROUTINE COMPUTES, FOR THE FORMAT SPECIFICATION, EW.E, THE    
C  NUMBER OF DIGITS TO THE RIGHT OF THE DECIMAL POINT, E=EWIDTH, AND    
C  THE FIELD WIDTH, W=WWIDTH.                                           
C                                                                       
C  WWIDTH INCLUDES THE FIVE POSITIONS NEEDED FOR THE SIGN OF THE        
C  MANTISSA, THE SIGN OF THE EXPONENT, THE 0, THE DECIMAL POINT AND THE 
C  CHARACTER IN THE OUTPUT - +0.XXXXXXXXXE+YYYY                         
C                                                                       
C  THE FOLLOWING MACHINE-DEPENDENT VALUES ARE USED -                    
C                                                                       
C  I1MACH(10) - THE BASE, B                                             
C  I1MACH(11) - THE NUMBER OF BASE-B DIGITS IN THE MANTISSA             
C  I1MACH(12) - THE SMALLEST EXPONENT, EMIN                             
C  I1MACH(13) - THE LARGEST EXPONENT, EMAX                              
C                                                                       
      INTEGER I1MACH, ICEIL, IFLR, EWIDTH, WWIDTH                       
      INTEGER DEMIN, DEMAX, EXPWID                                      
      REAL BASE                                                         
C                                                                       
      BASE = I1MACH(10)                                                 
C                                                                       
      EWIDTH = ICEIL( ALOG10(BASE)*FLOAT(I1MACH(11)) )                  
C                                                                       
      DEMIN =  IFLR( ALOG10(BASE)*FLOAT(I1MACH(12)-1) ) + 1             
      DEMAX = ICEIL( ALOG10(BASE)*FLOAT(I1MACH(13)) )                   
      EXPWID = IFLR( ALOG10(FLOAT(MAX0(IABS(DEMIN),IABS(DEMAX)))) ) + 1 
      WWIDTH = EWIDTH + EXPWID + 5                                      
C                                                                       
      RETURN                                                            
      END                                                               
      INTEGER FUNCTION I10WID(IX)                                       
      INTEGER IX                                                        
      INTEGER IABS, IY, DIGITS                                          
C     THIS FUNCTION RETURNS THE NUMBER OF DECIMAL                       
C     DIGITS REQUIRED TO REPRESENT THE INTEGER, IX.                     
      DIGITS = 0                                                        
      IY = IABS(IX)                                                     
   1  IF (IY .LT. 1) GOTO  2                                            
         DIGITS = DIGITS+1                                              
         IY = IY/10                                                     
         GOTO  1                                                        
   2  I10WID = DIGITS                                                   
      RETURN                                                            
      END                                                               
      SUBROUTINE I0TK00(LARG,NITEMS,ITYPE)                              
C                                                                       
C  INITIALIZES THE STACK TO NITEMS OF TYPE ITYPE                        
C                                                                       
      COMMON /CSTAK/DSTAK                                               
C                                                                       
      DOUBLE PRECISION DSTAK(500)                                       
      INTEGER ISTAK(1000)                                               
      LOGICAL LARG,INIT                                                 
      INTEGER ISIZE(5)                                                  
C                                                                       
      EQUIVALENCE (DSTAK(1),ISTAK(1))                                   
      EQUIVALENCE (ISTAK(1),LOUT)                                       
      EQUIVALENCE (ISTAK(2),LNOW)                                       
      EQUIVALENCE (ISTAK(3),LUSED)                                      
      EQUIVALENCE (ISTAK(4),LMAX)                                       
      EQUIVALENCE (ISTAK(5),LBOOK)                                      
      EQUIVALENCE (ISTAK(6),ISIZE(1))                                   
C                                                                       
      DATA INIT/.FALSE./                                                
C                                                                       
      LARG = .FALSE.                                                    
      IF (INIT) RETURN                                                  
C                                                                       
C  HERE TO INITIALIZE                                                   
C                                                                       
      INIT = .TRUE.                                                     
C                                                                       
C  SET DATA SIZES APPROPRIATE FOR A STANDARD CONFORMING                 
C  FORTRAN SYSTEM USING THE FORTRAN STORAGE UNIT AS THE                 
C  MEASURE OF SIZE.                                                     
C                                                                       
C  LOGICAL                                                              
      ISIZE(1) = 1                                                      
C  INTEGER                                                              
      ISIZE(2) = 1                                                      
C  REAL                                                                 
      ISIZE(3) = 1                                                      
C  DOUBLE PRECISION                                                     
      ISIZE(4) = 2                                                      
C  COMPLEX                                                              
      ISIZE(5) = 2                                                      
C                                                                       
      LBOOK = 10                                                        
      LNOW  = LBOOK                                                     
      LUSED = LBOOK                                                     
      LMAX  = MAX0( (NITEMS*ISIZE(ITYPE))/ISIZE(2), 12 )                
      LOUT  = 0                                                         
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      REAL FUNCTION CEIL(X)                                             
C                                                                       
C  CEIL RETURNS CEIL(X)                                                 
C                                                                       
      CEIL = FLOAT( INT(X) )                                            
      IF (X .LE. 0.0) RETURN                                            
      IF (CEIL .NE. X) CEIL = CEIL + 1.0                                
C                                                                       
      RETURN                                                            
      END                                                               
      DOUBLE PRECISION FUNCTION DCEIL(X)                                
C                                                                       
C  DCEIL RETURNS CEIL(X)                                                
C                                                                       
      DOUBLE PRECISION X                                                
C                                                                       
      DCEIL = DBLE( FLOAT ( IDINT(X) ) )                                
      IF (X .LE. 0.0D0) RETURN                                          
      IF (DCEIL .NE. X) DCEIL = DCEIL + 1.0D0                           
C                                                                       
      RETURN                                                            
      END                                                               
      INTEGER FUNCTION ICEIL(X)                                         
C                                                                       
C  ICEIL RETURNS CEIL(X)                                                
C                                                                       
      ICEIL = INT(X)                                                    
      IF (X .LE. 0.0) RETURN                                            
      IF (FLOAT(ICEIL) .NE. X) ICEIL = ICEIL + 1                        
C                                                                       
      RETURN                                                            
      END                                                               
      INTEGER FUNCTION IDCEIL(X)                                        
C                                                                       
C  IDCEIL RETURNS CEIL(X)                                               
C                                                                       
      DOUBLE PRECISION X                                                
C                                                                       
      IDCEIL = IDINT(X)                                                 
      IF (X .LE. 0.0D0) RETURN                                          
      IF (DBLE(FLOAT(IDCEIL)) .NE. X) IDCEIL = IDCEIL + 1               
C                                                                       
      RETURN                                                            
      END                                                               
      REAL FUNCTION FLR(X)                                              
C                                                                       
C  FLR RETURNS FLR(X)                                                   
C                                                                       
      FLR = FLOAT( INT(X) )                                             
      IF (X .GE. 0.0) RETURN                                            
      IF (FLR .NE. X) FLR = FLR - 1.0                                   
C                                                                       
      RETURN                                                            
      END                                                               
      DOUBLE PRECISION FUNCTION DFLR(X)                                 
C                                                                       
C  DFLR RETURNS FLR(X)                                                  
C                                                                       
      DOUBLE PRECISION X                                                
C                                                                       
      DFLR = DBLE( FLOAT ( IDINT(X) ) )                                 
      IF (X .GE. 0.0D0) RETURN                                          
      IF (DFLR .NE. X) DFLR = DFLR - 1.0D0                              
C                                                                       
      RETURN                                                            
      END                                                               
      INTEGER FUNCTION IFLR(X)                                          
C                                                                       
C  IFLR RETURNS FLR(X)                                                  
C                                                                       
      IFLR = INT(X)                                                     
      IF (X .GE. 0.0) RETURN                                            
      IF (FLOAT(IFLR) .NE. X) IFLR = IFLR - 1                           
C                                                                       
      RETURN                                                            
      END                                                               
      INTEGER FUNCTION IDFLR(X)                                         
C                                                                       
C  IDFLR RETURNS FLR(X)                                                 
C                                                                       
      DOUBLE PRECISION X                                                
C                                                                       
      IDFLR = IDINT(X)                                                  
      IF (X .GE. 0.0D0) RETURN                                          
      IF (DBLE(FLOAT(IDFLR)) .NE. X) IDFLR = IDFLR - 1                  
C                                                                       
      RETURN                                                            
      END                                                               
      SUBROUTINE EPRINT                                                 
C                                                                       
C  THIS SUBROUTINE PRINTS THE LAST ERROR MESSAGE, IF ANY.               
C                                                                       
C/6S                                                                    
C     INTEGER MESSG(1)                                                  
C/7S                                                                    
      CHARACTER*1 MESSG(1)                                              
C/                                                                      
C                                                                       
      CALL E9RINT(MESSG,1,1,.FALSE.)                                    
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE E9RINT(MESSG,NW,NERR,SAVE)                             
C                                                                       
C  THIS ROUTINE STORES THE CURRENT ERROR MESSAGE OR PRINTS THE OLD ONE, 
C  IF ANY, DEPENDING ON WHETHER OR NOT SAVE = .TRUE. .                  
C                                                                       
C  CHANGED, BY P.FOX, MAY 18, 1983, FROM THE ORIGINAL VERSION IN ORDER  
C  TO GET RID OF THE FORTRAN CARRIAGE CONTROL LINE OVERWRITE            
C  CHARACTER +, WHICH HAS ALWAYS CAUSED TROUBLE.                        
C  FOR THE RECORD, THE PREVIOUS VERSION HAD THE FOLLOWING ARRAY         
C  AND CALLS -   (WHERE CCPLUS WAS DECLARED OF TYPE INTEGER)            
C                                                                       
C      DATA CCPLUS  / 1H+ /                                             
C                                                                       
C      DATA FMT( 1) / 1H( /                                             
C      DATA FMT( 2) / 1HA /                                             
C      DATA FMT( 3) / 1H1 /                                             
C      DATA FMT( 4) / 1H, /                                             
C      DATA FMT( 5) / 1H1 /                                             
C      DATA FMT( 6) / 1H4 /                                             
C      DATA FMT( 7) / 1HX /                                             
C      DATA FMT( 8) / 1H, /                                             
C      DATA FMT( 9) / 1H7 /                                             
C      DATA FMT(10) / 1H2 /                                             
C      DATA FMT(11) / 1HA /                                             
C      DATA FMT(12) / 1HX /                                             
C      DATA FMT(13) / 1HX /                                             
C      DATA FMT(14) / 1H) /                                             
C                                                                       
C        CALL S88FMT(2,I1MACH(6),FMT(12))                               
C        WRITE(IWUNIT,FMT) CCPLUS,(MESSGP(I),I=1,NWP)                   
C                                                                       
C/6S                                                                    
C     INTEGER MESSG(NW)                                                 
C/7S                                                                    
      CHARACTER*1 MESSG(NW)                                             
C/                                                                      
      LOGICAL SAVE                                                      
C                                                                       
C  MESSGP STORES AT LEAST THE FIRST 72 CHARACTERS OF THE PREVIOUS       
C  MESSAGE. ITS LENGTH IS MACHINE DEPENDENT AND MUST BE AT LEAST        
C                                                                       
C       1 + 71/(THE NUMBER OF CHARACTERS STORED PER INTEGER WORD).      
C                                                                       
C/6S                                                                    
C     INTEGER MESSGP(36),FMT(10), FMT10(10)                             
C     EQUIVALENCE (FMT(1),FMT10(1))                                     
C/7S                                                                    
      CHARACTER*1 MESSGP(72),FMT(10)                                    
      CHARACTER*10 FMT10                                                
      EQUIVALENCE (FMT(1),FMT10)                                        
C/                                                                      
C                                                                       
C  START WITH NO PREVIOUS MESSAGE.                                      
C                                                                       
C/6S                                                                    
C     DATA MESSGP(1)/1H1/, NWP/0/, NERRP/0/                             
C/7S                                                                    
      DATA MESSGP(1)/'1'/, NWP/0/, NERRP/0/                             
C/                                                                      
C                                                                       
C  SET UP THE FORMAT FOR PRINTING THE ERROR MESSAGE.                    
C  THE FORMAT IS SIMPLY (A1,14X,72AXX) WHERE XX=I1MACH(6) IS THE        
C  NUMBER OF CHARACTERS STORED PER INTEGER WORD.                        
C                                                                       
C/6S                                                                    
C     DATA FMT( 1) / 1H( /                                              
C     DATA FMT( 2) / 1H3 /                                              
C     DATA FMT( 3) / 1HX /                                              
C     DATA FMT( 4) / 1H, /                                              
C     DATA FMT( 5) / 1H7 /                                              
C     DATA FMT( 6) / 1H2 /                                              
C     DATA FMT( 7) / 1HA /                                              
C     DATA FMT( 8) / 1HX /                                              
C     DATA FMT( 9) / 1HX /                                              
C     DATA FMT(10) / 1H) /                                              
C/7S                                                                    
      DATA FMT( 1) / '(' /                                              
      DATA FMT( 2) / '3' /                                              
      DATA FMT( 3) / 'X' /                                              
      DATA FMT( 4) / ',' /                                              
      DATA FMT( 5) / '7' /                                              
      DATA FMT( 6) / '2' /                                              
      DATA FMT( 7) / 'A' /                                              
      DATA FMT( 8) / 'X' /                                              
      DATA FMT( 9) / 'X' /                                              
      DATA FMT(10) / ')' /                                              
C/                                                                      
C                                                                       
      IF (.NOT.SAVE) GO TO 20                                           
C                                                                       
C  SAVE THE MESSAGE.                                                    
C                                                                       
        NWP=NW                                                          
        NERRP=NERR                                                      
        DO 10 I=1,NW                                                    
 10     MESSGP(I)=MESSG(I)                                              
C                                                                       
        GO TO 30                                                        
C                                                                       
 20   IF (I8SAVE(1,0,.FALSE.).EQ.0) GO TO 30                            
C                                                                       
C  PRINT THE MESSAGE.                                                   
C                                                                       
        IWUNIT=I1MACH(4)                                                
        WRITE(IWUNIT,9000) NERRP                                        
 9000   FORMAT(7H ERROR ,I4,4H IN )                                     
C                                                                       
        CALL S88FMT(2,I1MACH(6),FMT( 8))                                
        WRITE(IWUNIT,FMT10) (MESSGP(I),I=1,NWP)                         
C                                                                       
 30   RETURN                                                            
C                                                                       
      END                                                               
      INTEGER FUNCTION I1MACH(I)                                        
C                                                                       
C  I/O UNIT NUMBERS.                                                    
C                                                                       
C    I1MACH( 1) = THE STANDARD INPUT UNIT.                              
C                                                                       
C    I1MACH( 2) = THE STANDARD OUTPUT UNIT.                             
C                                                                       
C    I1MACH( 3) = THE STANDARD PUNCH UNIT.                              
C                                                                       
C    I1MACH( 4) = THE STANDARD ERROR MESSAGE UNIT.                      
C                                                                       
C  WORDS.                                                               
C                                                                       
C    I1MACH( 5) = THE NUMBER OF BITS PER INTEGER STORAGE UNIT.          
C                                                                       
C    I1MACH( 6) = THE NUMBER OF CHARACTERS PER CHARACTER STORAGE UNIT.  
C                 FOR FORTRAN 77, THIS IS ALWAYS 1.  FOR FORTRAN 66,    
C                 CHARACTER STORAGE UNIT = INTEGER STORAGE UNIT.        
C                                                                       
C  INTEGERS.                                                            
C                                                                       
C    ASSUME INTEGERS ARE REPRESENTED IN THE S-DIGIT, BASE-A FORM        
C                                                                       
C               SIGN ( X(S-1)*A**(S-1) + ... + X(1)*A + X(0) )          
C                                                                       
C               WHERE 0 .LE. X(I) .LT. A FOR I=0,...,S-1.               
C                                                                       
C    I1MACH( 7) = A, THE BASE.                                          
C                                                                       
C    I1MACH( 8) = S, THE NUMBER OF BASE-A DIGITS.                       
C                                                                       
C    I1MACH( 9) = A**S - 1, THE LARGEST MAGNITUDE.                      
C                                                                       
C  FLOATING-POINT NUMBERS.                                              
C                                                                       
C    ASSUME FLOATING-POINT NUMBERS ARE REPRESENTED IN THE T-DIGIT,      
C    BASE-B FORM                                                        
C                                                                       
C               SIGN (B**E)*( (X(1)/B) + ... + (X(T)/B**T) )            
C                                                                       
C               WHERE 0 .LE. X(I) .LT. B FOR I=1,...,T,                 
C               0 .LT. X(1), AND EMIN .LE. E .LE. EMAX.                 
C                                                                       
C    I1MACH(10) = B, THE BASE.                                          
C                                                                       
C  SINGLE-PRECISION                                                     
C                                                                       
C    I1MACH(11) = T, THE NUMBER OF BASE-B DIGITS.                       
C                                                                       
C    I1MACH(12) = EMIN, THE SMALLEST EXPONENT E.                        
C                                                                       
C    I1MACH(13) = EMAX, THE LARGEST EXPONENT E.                         
C                                                                       
C  DOUBLE-PRECISION                                                     
C                                                                       
C    I1MACH(14) = T, THE NUMBER OF BASE-B DIGITS.                       
C                                                                       
C    I1MACH(15) = EMIN, THE SMALLEST EXPONENT E.                        
C                                                                       
C    I1MACH(16) = EMAX, THE LARGEST EXPONENT E.                         
C                                                                       
C  TO ALTER THIS FUNCTION FOR A PARTICULAR ENVIRONMENT,                 
C  THE DESIRED SET OF DATA STATEMENTS SHOULD BE ACTIVATED BY            
C  REMOVING THE C FROM COLUMN 1.  ALSO, THE VALUES OF                   
C  I1MACH(1) - I1MACH(4) SHOULD BE CHECKED FOR CONSISTENCY              
C  WITH THE LOCAL OPERATING SYSTEM.  FOR FORTRAN 77, YOU MAY WISH       
C  TO ADJUST THE DATA STATEMENT SO IMACH(6) IS SET TO 1, AND            
C  THEN TO COMMENT OUT THE EXECUTABLE TEST ON I .EQ. 6 BELOW.           
C                                                                       
C  FOR IEEE-ARITHMETIC MACHINES (BINARY STANDARD), THE FIRST            
C  SET OF CONSTANTS BELOW SHOULD BE APPROPRIATE, EXCEPT PERHAPS         
C  FOR IMACH(1) - IMACH(4).                                             
C                                                                       
      INTEGER IMACH(16),OUTPUT,SANITY                                   
C                                                                       
      EQUIVALENCE (IMACH(4),OUTPUT)                                     
C                                                                       
C     MACHINE CONSTANTS FOR IEEE ARITHMETIC MACHINES, SUCH AS THE AT&T  
C     3B SERIES, MOTOROLA 68000 BASED MACHINES (E.G. SUN 3 AND AT&T     
C     PC 7300), AND 8087 BASED MICROS (E.G. IBM PC AND AT&T 6300).      
C                                                                       
       DATA IMACH( 1) /    5 /                                          
       DATA IMACH( 2) /    6 /                                          
       DATA IMACH( 3) /    7 /                                          
       DATA IMACH( 4) /    6 /                                          
       DATA IMACH( 5) /   32 /                                          
       DATA IMACH( 6) /    4 /                                          
       DATA IMACH( 7) /    2 /                                          
       DATA IMACH( 8) /   31 /                                          
       DATA IMACH( 9) / 2147483647 /                                    
       DATA IMACH(10) /    2 /                                          
       DATA IMACH(11) /   24 /                                          
       DATA IMACH(12) / -125 /                                          
       DATA IMACH(13) /  128 /                                          
       DATA IMACH(14) /   53 /                                          
       DATA IMACH(15) / -1021 /                                         
       DATA IMACH(16) /  1024 /, SANITY/987/                            
C                                                                       
C     MACHINE CONSTANTS FOR AMDAHL MACHINES.                            
C                                                                       
C      DATA IMACH( 1) /   5 /                                           
C      DATA IMACH( 2) /   6 /                                           
C      DATA IMACH( 3) /   7 /                                           
C      DATA IMACH( 4) /   6 /                                           
C      DATA IMACH( 5) /  32 /                                           
C      DATA IMACH( 6) /   4 /                                           
C      DATA IMACH( 7) /   2 /                                           
C      DATA IMACH( 8) /  31 /                                           
C      DATA IMACH( 9) / 2147483647 /                                    
C      DATA IMACH(10) /  16 /                                           
C      DATA IMACH(11) /   6 /                                           
C      DATA IMACH(12) / -64 /                                           
C      DATA IMACH(13) /  63 /                                           
C      DATA IMACH(14) /  14 /                                           
C      DATA IMACH(15) / -64 /                                           
C      DATA IMACH(16) /  63 /, SANITY/987/                              
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM.                  
C                                                                       
C      DATA IMACH( 1) /    7 /                                          
C      DATA IMACH( 2) /    2 /                                          
C      DATA IMACH( 3) /    2 /                                          
C      DATA IMACH( 4) /    2 /                                          
C      DATA IMACH( 5) /   36 /                                          
C      DATA IMACH( 6) /    4 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   33 /                                          
C      DATA IMACH( 9) / Z1FFFFFFFF /                                    
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   24 /                                          
C      DATA IMACH(12) / -256 /                                          
C      DATA IMACH(13) /  255 /                                          
C      DATA IMACH(14) /   60 /                                          
C      DATA IMACH(15) / -256 /                                          
C      DATA IMACH(16) /  255 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700 SYSTEM.                  
C                                                                       
C      DATA IMACH( 1) /   5 /                                           
C      DATA IMACH( 2) /   6 /                                           
C      DATA IMACH( 3) /   7 /                                           
C      DATA IMACH( 4) /   6 /                                           
C      DATA IMACH( 5) /  48 /                                           
C      DATA IMACH( 6) /   6 /                                           
C      DATA IMACH( 7) /   2 /                                           
C      DATA IMACH( 8) /  39 /                                           
C      DATA IMACH( 9) / O0007777777777777 /                             
C      DATA IMACH(10) /   8 /                                           
C      DATA IMACH(11) /  13 /                                           
C      DATA IMACH(12) / -50 /                                           
C      DATA IMACH(13) /  76 /                                           
C      DATA IMACH(14) /  26 /                                           
C      DATA IMACH(15) / -50 /                                           
C      DATA IMACH(16) /  76 /, SANITY/987/                              
C                                                                       
C     MACHINE CONSTANTS FOR THE BURROUGHS 6700/7700 SYSTEMS.            
C                                                                       
C      DATA IMACH( 1) /   5 /                                           
C      DATA IMACH( 2) /   6 /                                           
C      DATA IMACH( 3) /   7 /                                           
C      DATA IMACH( 4) /   6 /                                           
C      DATA IMACH( 5) /  48 /                                           
C      DATA IMACH( 6) /   6 /                                           
C      DATA IMACH( 7) /   2 /                                           
C      DATA IMACH( 8) /  39 /                                           
C      DATA IMACH( 9) / O0007777777777777 /                             
C      DATA IMACH(10) /   8 /                                           
C      DATA IMACH(11) /  13 /                                           
C      DATA IMACH(12) / -50 /                                           
C      DATA IMACH(13) /  76 /                                           
C      DATA IMACH(14) /  26 /                                           
C      DATA IMACH(15) / -32754 /                                        
C      DATA IMACH(16) /  32780 /, SANITY/987/                           
C                                                                       
C     MACHINE CONSTANTS FOR FTN4 ON THE CDC 6000/7000 SERIES.           
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   60 /                                          
C      DATA IMACH( 6) /   10 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   48 /                                          
C      DATA IMACH( 9) / 00007777777777777777B /                         
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   47 /                                          
C      DATA IMACH(12) / -929 /                                          
C      DATA IMACH(13) / 1070 /                                          
C      DATA IMACH(14) /   94 /                                          
C      DATA IMACH(15) / -929 /                                          
C      DATA IMACH(16) / 1069 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR FTN5 ON THE CDC 6000/7000 SERIES.           
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   60 /                                          
C      DATA IMACH( 6) /   10 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   48 /                                          
C      DATA IMACH( 9) / O"00007777777777777777" /                       
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   47 /                                          
C      DATA IMACH(12) / -929 /                                          
C      DATA IMACH(13) / 1070 /                                          
C      DATA IMACH(14) /   94 /                                          
C      DATA IMACH(15) / -929 /                                          
C      DATA IMACH(16) / 1069 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR CONVEX C-1.                                 
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   32 /                                          
C      DATA IMACH( 6) /    4 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   31 /                                          
C      DATA IMACH( 9) / 2147483647 /                                    
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   24 /                                          
C      DATA IMACH(12) / -128 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   53 /                                          
C      DATA IMACH(15) /-1024 /                                          
C      DATA IMACH(16) / 1023 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE CRAY 1, XMP, 2, AND 3.                  
C                                                                       
C      DATA IMACH( 1) /     5 /                                         
C      DATA IMACH( 2) /     6 /                                         
C      DATA IMACH( 3) /   102 /                                         
C      DATA IMACH( 4) /     6 /                                         
C      DATA IMACH( 5) /    64 /                                         
C      DATA IMACH( 6) /     8 /                                         
C      DATA IMACH( 7) /     2 /                                         
C      DATA IMACH( 8) /    63 /                                         
C      DATA IMACH( 9) /  777777777777777777777B /                       
C      DATA IMACH(10) /     2 /                                         
C      DATA IMACH(11) /    47 /                                         
C      DATA IMACH(12) / -8189 /                                         
C      DATA IMACH(13) /  8190 /                                         
C      DATA IMACH(14) /    94 /                                         
C      DATA IMACH(15) / -8099 /                                         
C      DATA IMACH(16) /  8190 /, SANITY/987/                            
C                                                                       
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200.             
C                                                                       
C      DATA IMACH( 1) /   11 /                                          
C      DATA IMACH( 2) /   12 /                                          
C      DATA IMACH( 3) /    8 /                                          
C      DATA IMACH( 4) /   10 /                                          
C      DATA IMACH( 5) /   16 /                                          
C      DATA IMACH( 6) /    2 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   15 /                                          
C      DATA IMACH( 9) /32767 /                                          
C      DATA IMACH(10) /   16 /                                          
C      DATA IMACH(11) /    6 /                                          
C      DATA IMACH(12) /  -64 /                                          
C      DATA IMACH(13) /   63 /                                          
C      DATA IMACH(14) /   14 /                                          
C      DATA IMACH(15) /  -64 /                                          
C      DATA IMACH(16) /   63 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE HARRIS SLASH 6 AND SLASH 7.             
C                                                                       
C      DATA IMACH( 1) /       5 /                                       
C      DATA IMACH( 2) /       6 /                                       
C      DATA IMACH( 3) /       0 /                                       
C      DATA IMACH( 4) /       6 /                                       
C      DATA IMACH( 5) /      24 /                                       
C      DATA IMACH( 6) /       3 /                                       
C      DATA IMACH( 7) /       2 /                                       
C      DATA IMACH( 8) /      23 /                                       
C      DATA IMACH( 9) / 8388607 /                                       
C      DATA IMACH(10) /       2 /                                       
C      DATA IMACH(11) /      23 /                                       
C      DATA IMACH(12) /    -127 /                                       
C      DATA IMACH(13) /     127 /                                       
C      DATA IMACH(14) /      38 /                                       
C      DATA IMACH(15) /    -127 /                                       
C      DATA IMACH(16) /     127 /, SANITY/987/                          
C                                                                       
C     MACHINE CONSTANTS FOR THE HONEYWELL DPS 8/70 SERIES.              
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /   43 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   36 /                                          
C      DATA IMACH( 6) /    4 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   35 /                                          
C      DATA IMACH( 9) / O377777777777 /                                 
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   27 /                                          
C      DATA IMACH(12) / -127 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   63 /                                          
C      DATA IMACH(15) / -127 /                                          
C      DATA IMACH(16) /  127 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,                     
C     THE XEROX SIGMA 5/7/9 AND THE SEL SYSTEMS 85/86.                  
C                                                                       
C      DATA IMACH( 1) /   5 /                                           
C      DATA IMACH( 2) /   6 /                                           
C      DATA IMACH( 3) /   7 /                                           
C      DATA IMACH( 4) /   6 /                                           
C      DATA IMACH( 5) /  32 /                                           
C      DATA IMACH( 6) /   4 /                                           
C      DATA IMACH( 7) /   2 /                                           
C      DATA IMACH( 8) /  31 /                                           
C      DATA IMACH( 9) / Z7FFFFFFF /                                     
C      DATA IMACH(10) /  16 /                                           
C      DATA IMACH(11) /   6 /                                           
C      DATA IMACH(12) / -64 /                                           
C      DATA IMACH(13) /  63 /                                           
C      DATA IMACH(14) /  14 /                                           
C      DATA IMACH(15) / -64 /                                           
C      DATA IMACH(16) /  63 /, SANITY/987/                              
C                                                                       
C     MACHINE CONSTANTS FOR THE INTERDATA 8/32                          
C     WITH THE UNIX SYSTEM FORTRAN 77 COMPILER.                         
C                                                                       
C     FOR THE INTERDATA FORTRAN VII COMPILER REPLACE                    
C     THE Z'S SPECIFYING HEX CONSTANTS WITH Y'S.                        
C                                                                       
C      DATA IMACH( 1) /   5 /                                           
C      DATA IMACH( 2) /   6 /                                           
C      DATA IMACH( 3) /   6 /                                           
C      DATA IMACH( 4) /   6 /                                           
C      DATA IMACH( 5) /  32 /                                           
C      DATA IMACH( 6) /   4 /                                           
C      DATA IMACH( 7) /   2 /                                           
C      DATA IMACH( 8) /  31 /                                           
C      DATA IMACH( 9) / Z'7FFFFFFF' /                                   
C      DATA IMACH(10) /  16 /                                           
C      DATA IMACH(11) /   6 /                                           
C      DATA IMACH(12) / -64 /                                           
C      DATA IMACH(13) /  62 /                                           
C      DATA IMACH(14) /  14 /                                           
C      DATA IMACH(15) / -64 /                                           
C      DATA IMACH(16) /  62 /, SANITY/987/                              
C                                                                       
C     MACHINE CONSTANTS FOR THE PDP-10 (KA PROCESSOR).                  
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   36 /                                          
C      DATA IMACH( 6) /    5 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   35 /                                          
C      DATA IMACH( 9) / "377777777777 /                                 
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   27 /                                          
C      DATA IMACH(12) / -128 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   54 /                                          
C      DATA IMACH(15) / -101 /                                          
C      DATA IMACH(16) /  127 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE PDP-10 (KI PROCESSOR).                  
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   36 /                                          
C      DATA IMACH( 6) /    5 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   35 /                                          
C      DATA IMACH( 9) / "377777777777 /                                 
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   27 /                                          
C      DATA IMACH(12) / -128 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   62 /                                          
C      DATA IMACH(15) / -128 /                                          
C      DATA IMACH(16) /  127 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR PDP-11 FORTRANS SUPPORTING                  
C     32-BIT INTEGER ARITHMETIC.                                        
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   32 /                                          
C      DATA IMACH( 6) /    4 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   31 /                                          
C      DATA IMACH( 9) / 2147483647 /                                    
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   24 /                                          
C      DATA IMACH(12) / -127 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   56 /                                          
C      DATA IMACH(15) / -127 /                                          
C      DATA IMACH(16) /  127 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR PDP-11 FORTRANS SUPPORTING                  
C     16-BIT INTEGER ARITHMETIC.                                        
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   16 /                                          
C      DATA IMACH( 6) /    2 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   15 /                                          
C      DATA IMACH( 9) / 32767 /                                         
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   24 /                                          
C      DATA IMACH(12) / -127 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   56 /                                          
C      DATA IMACH(15) / -127 /                                          
C      DATA IMACH(16) /  127 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR THE PRIME 50 SERIES SYSTEMS                 
C     WTIH 32-BIT INTEGERS AND 64V MODE INSTRUCTIONS,                   
C     SUPPLIED BY IGOR BRAY.                                            
C                                                                       
C      DATA IMACH( 1) /            1 /                                  
C      DATA IMACH( 2) /            1 /                                  
C      DATA IMACH( 3) /            2 /                                  
C      DATA IMACH( 4) /            1 /                                  
C      DATA IMACH( 5) /           32 /                                  
C      DATA IMACH( 6) /            4 /                                  
C      DATA IMACH( 7) /            2 /                                  
C      DATA IMACH( 8) /           31 /                                  
C      DATA IMACH( 9) / :17777777777 /                                  
C      DATA IMACH(10) /            2 /                                  
C      DATA IMACH(11) /           23 /                                  
C      DATA IMACH(12) /         -127 /                                  
C      DATA IMACH(13) /         +127 /                                  
C      DATA IMACH(14) /           47 /                                  
C      DATA IMACH(15) /       -32895 /                                  
C      DATA IMACH(16) /       +32637 /, SANITY/987/                     
C                                                                       
C     MACHINE CONSTANTS FOR THE SEQUENT BALANCE 8000.                   
C                                                                       
C      DATA IMACH( 1) /     0 /                                         
C      DATA IMACH( 2) /     0 /                                         
C      DATA IMACH( 3) /     7 /                                         
C      DATA IMACH( 4) /     0 /                                         
C      DATA IMACH( 5) /    32 /                                         
C      DATA IMACH( 6) /     1 /                                         
C      DATA IMACH( 7) /     2 /                                         
C      DATA IMACH( 8) /    31 /                                         
C      DATA IMACH( 9) /  2147483647 /                                   
C      DATA IMACH(10) /     2 /                                         
C      DATA IMACH(11) /    24 /                                         
C      DATA IMACH(12) /  -125 /                                         
C      DATA IMACH(13) /   128 /                                         
C      DATA IMACH(14) /    53 /                                         
C      DATA IMACH(15) / -1021 /                                         
C      DATA IMACH(16) /  1024 /, SANITY/987/                            
C                                                                       
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES.                     
C                                                                       
C     NOTE THAT THE PUNCH UNIT, I1MACH(3), HAS BEEN SET TO 7            
C     WHICH IS APPROPRIATE FOR THE UNIVAC-FOR SYSTEM.                   
C     IF YOU HAVE THE UNIVAC-FTN SYSTEM, SET IT TO 1.                   
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   36 /                                          
C      DATA IMACH( 6) /    6 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   35 /                                          
C      DATA IMACH( 9) / O377777777777 /                                 
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   27 /                                          
C      DATA IMACH(12) / -128 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   60 /                                          
C      DATA IMACH(15) /-1024 /                                          
C      DATA IMACH(16) / 1023 /, SANITY/987/                             
C                                                                       
C     MACHINE CONSTANTS FOR VAX.                                        
C                                                                       
C      DATA IMACH( 1) /    5 /                                          
C      DATA IMACH( 2) /    6 /                                          
C      DATA IMACH( 3) /    7 /                                          
C      DATA IMACH( 4) /    6 /                                          
C      DATA IMACH( 5) /   32 /                                          
C      DATA IMACH( 6) /    4 /                                          
C      DATA IMACH( 7) /    2 /                                          
C      DATA IMACH( 8) /   31 /                                          
C      DATA IMACH( 9) / 2147483647 /                                    
C      DATA IMACH(10) /    2 /                                          
C      DATA IMACH(11) /   24 /                                          
C      DATA IMACH(12) / -127 /                                          
C      DATA IMACH(13) /  127 /                                          
C      DATA IMACH(14) /   56 /                                          
C      DATA IMACH(15) / -127 /                                          
C      DATA IMACH(16) /  127 /, SANITY/987/                             
C                                                                       
C  ***  ISSUE STOP 777 IF ALL DATA STATEMENTS ARE COMMENTED...          
      IF (SANITY .NE. 987) STOP 777                                     
      IF (I .LT. 1  .OR.  I .GT. 16) GO TO 10                           
C                                                                       
      I1MACH = IMACH(I)                                                 
C/6S                                                                    
C/7S                                                                    
      IF (I .EQ. 6) I1MACH = 1                                          
C/                                                                      
      RETURN                                                            
C                                                                       
 10   WRITE(OUTPUT,9000)                                                
 9000 FORMAT(39H1ERROR    1 IN I1MACH - I OUT OF BOUNDS)                
C                                                                       
      CALL FDUMP                                                        
C                                                                       
      STOP                                                              
C                                                                       
      END                                                               
      INTEGER FUNCTION I8SAVE(ISW,IVALUE,SET)                           
C                                                                       
C  IF (ISW = 1) I8SAVE RETURNS THE CURRENT ERROR NUMBER AND             
C               SETS IT TO IVALUE IF SET = .TRUE. .                     
C                                                                       
C  IF (ISW = 2) I8SAVE RETURNS THE CURRENT RECOVERY SWITCH AND          
C               SETS IT TO IVALUE IF SET = .TRUE. .                     
C                                                                       
      LOGICAL SET                                                       
C                                                                       
      INTEGER IPARAM(2)                                                 
      EQUIVALENCE (IPARAM(1),LERROR) , (IPARAM(2),LRECOV)               
C                                                                       
C  START EXECUTION ERROR FREE AND WITH RECOVERY TURNED OFF.             
C                                                                       
      DATA LERROR/0/ , LRECOV/2/                                        
C                                                                       
      I8SAVE=IPARAM(ISW)                                                
      IF (SET) IPARAM(ISW)=IVALUE                                       
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      SUBROUTINE S88FMT( N, W, IFMT )                                   
C                                                                       
C  S88FMT  REPLACES IFMT(1), ... , IFMT(N) WITH                         
C  THE CHARACTERS CORRESPONDING TO THE N LEAST SIGNIFICANT              
C  DIGITS OF W.                                                         
C                                                                       
      INTEGER N,W                                                       
C/6S                                                                    
C     INTEGER IFMT(N)                                                   
C/7S                                                                    
      CHARACTER*1 IFMT(N)                                               
C/                                                                      
C                                                                       
      INTEGER NT,WT                                                     
C                                                                       
C/6S                                                                    
C     INTEGER DIGITS(10)                                                
C     DATA DIGITS( 1) / 1H0 /                                           
C     DATA DIGITS( 2) / 1H1 /                                           
C     DATA DIGITS( 3) / 1H2 /                                           
C     DATA DIGITS( 4) / 1H3 /                                           
C     DATA DIGITS( 5) / 1H4 /                                           
C     DATA DIGITS( 6) / 1H5 /                                           
C     DATA DIGITS( 7) / 1H6 /                                           
C     DATA DIGITS( 8) / 1H7 /                                           
C     DATA DIGITS( 9) / 1H8 /                                           
C     DATA DIGITS(10) / 1H9 /                                           
C/7S                                                                    
      CHARACTER*1 DIGITS(10)                                            
      DATA DIGITS( 1) / '0' /                                           
      DATA DIGITS( 2) / '1' /                                           
      DATA DIGITS( 3) / '2' /                                           
      DATA DIGITS( 4) / '3' /                                           
      DATA DIGITS( 5) / '4' /                                           
      DATA DIGITS( 6) / '5' /                                           
      DATA DIGITS( 7) / '6' /                                           
      DATA DIGITS( 8) / '7' /                                           
      DATA DIGITS( 9) / '8' /                                           
      DATA DIGITS(10) / '9' /                                           
C/                                                                      
C                                                                       
      NT = N                                                            
      WT = W                                                            
C                                                                       
 10   IF (NT .LE. 0) RETURN                                             
        IDIGIT = MOD( WT, 10 )                                          
        IFMT(NT) = DIGITS(IDIGIT+1)                                     
        WT = WT/10                                                      
        NT = NT - 1                                                     
        GO TO 10                                                        
C                                                                       
      END                                                               
      SUBROUTINE FDUMP                                                  
C  THIS IS A DUMMY ROUTINE TO BE SENT OUT ON                            
C  THE PORT SEDIT TAPE                                                  
C                                                                       
      RETURN                                                            
      END                                                               
C****END OF ROUTINES NEEDED FOR PORT 3 FRAMEWORK CHAPTER****************


