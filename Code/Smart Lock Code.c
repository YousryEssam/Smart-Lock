/*
 * Smart Lock Code.c
 *
 * Created: 12/19/2023 2:43:31 AM
 * Author: Yousry Essam
 */

// Needed lib 
#include <alcd.h>
#include <delay.h>
#include <mega16.h>

// Needed Defins 
#define bit_set(r,b) r |=  1<<b
#define bit_clr(r,b) r &= ~(1<<b)
// Function declaration: 
char keyPad();
void startSmartLock();
void beepSound();
int findUser(char dig1, char dig2, char dig3);
unsigned char EE_Read(unsigned int address);
void EE_Write(unsigned int address, unsigned char data);
void initialPassCodes(char resetPc);// pass '1' to reset all PC any other char do nothing
int passCodeMatch( int id, char pas1, char pas2 , char pas3 );
void openDoor();
void closeDoor();
void changePass();
void ContactAdmin();
void AdminPassChange();
void newPassCode(int userId  , char dig1  , char dig2 , char dig3);
//Global Vars ;
char UsersIds[5][3];// Store IDs 
char UsersNames[5][8];// Store Names in same order of IDs 
void main(void){
       // Start Code; 
       startSmartLock();
       while (1){        
              char num , dig1 , dig2 , dig3 ,userId ;
              lcd_clear();
              lcd_gotoxy(2,1);
              lcd_printf("Press * to Login");
              num = keyPad();
              if(num != '*') continue;
              lcd_clear();
              lcd_printf("Enter your ID: ");// Ask for ID 
              // Take 3 Digit ID and print it to the user        
              dig1 = keyPad();        
              lcd_printf("%c" , dig1); 
              dig2 = keyPad();
              lcd_printf("%c" , dig2);
              dig3 = keyPad(); 
              lcd_printf("%c" , dig3);   
              delay_ms(1000);         
              
              // to Know user Id in data or is not Exist  
              userId = findUser(dig1, dig2, dig3 );
              lcd_clear();
              // if User id not exist 
              if(userId == 10) {        
                  lcd_printf("Wrong ID");
                  beepSound();
                  beepSound();
                  continue;
              }
              lcd_printf("Enter Pass Code: ");
              // Take 3 Digit ID and print it to the user        
              dig1 = keyPad();        
              lcd_printf("%c" , dig1); 
              dig2 = keyPad();
              lcd_printf("%c" , dig2);
              dig3 = keyPad(); 
              lcd_printf("%c" , dig3);
              delay_ms(1000); 
              
              lcd_clear();
              // In case pass does not match 
              if(passCodeMatch(userId , dig1 , dig2 , dig3 ) == 0 ){ 
                     lcd_printf("Sorry, Wrong PC");
                     beepSound();
                     continue;
              }
              
              lcd_printf("Welcom :%s \n   Door is opening" ,  UsersNames[userId]);
              openDoor();                                                   
              lcd_clear();
              lcd_printf("\n  Door is Closeing");
              closeDoor(); 
       }
             
}

// Program Functions :
interrupt [2] void Admininterrupt(void){
       AdminPassChange();
}
interrupt [3] void Setpc(void){
       changePass();
}
void newPassCode(int userId  , char dig1  , char dig2 , char dig3){

       lcd_clear();
       lcd_printf("New PC stored (:");
       EE_Write(userId*3 , dig1); 
       EE_Write(userId*3 + 1 , dig2); 
       EE_Write(userId*3 + 2 , dig3);
       delay_ms(1500); 
}
void AdminPassChange(){
       
       char  dig1 , dig2 , dig3 ,userId;
               
       lcd_clear();
       lcd_printf("Enter Admin PC: ");// Ask for ID 
                   
       // Take 3 Digit ID and print it to the user           
       dig1 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig2 = keyPad();
       lcd_printf("%c" , dig2);
       dig3 = keyPad(); 
       lcd_printf("%c" , dig3);     
       delay_ms(500);
       
       if(passCodeMatch( 0 , dig1 , dig2 , dig3 ) == 0){
              ContactAdmin();
              return ;
       }
       
       lcd_clear();
       lcd_printf("Student ID: ");// Ask for ID 
                   
       // Take 3 Digit ID and print it to the user        
             
       dig1 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig2 = keyPad();
       lcd_printf("%c" , dig2);
       dig3 = keyPad(); 
       lcd_printf("%c" , dig3);     
       delay_ms(500);
       
       // to Know user Id in data or is not Exist  
       userId = findUser(dig1, dig2, dig3 );
       lcd_clear();
       if ( userId == 10 ){
              ContactAdmin();
              return ;
       } 
       
       lcd_clear();
       lcd_printf("Enter new PC : ");
       dig1 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig2 = keyPad();
       lcd_printf("%c" , dig2);
       dig3 = keyPad(); 
       lcd_printf("%c" , dig3); 
       
       newPassCode(userId ,dig1 , dig2, dig3 ); 
}
void ContactAdmin(){
      lcd_clear();  
      lcd_printf("\nContact Admin");
      beepSound();
      beepSound();
}
void changePass(){
       char dig1 , dig2 , dig3 ,userId ,dig11 , dig22 , dig33 ;
       lcd_clear(); 
       lcd_printf("Enter ID : ");
       
       dig1 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig2 = keyPad();
       lcd_printf("%c" , dig2);
       dig3 = keyPad(); 
       lcd_printf("%c" , dig3); 
       
       userId = findUser(dig1, dig2, dig3 );
        
       if(userId == 10)// if User id not exist 
       {   
             ContactAdmin();
             return ;
       } 
       
       lcd_printf("\nEnter Old PC : "); 
       
       dig1 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig2 = keyPad();
       lcd_printf("%c" , dig2);
       dig3 = keyPad(); 
       lcd_printf("%c" , dig3); 
       
       if(passCodeMatch(userId , dig1 , dig2 , dig3 ) == 0 ){ 
              ContactAdmin();
              return ;
       }
       
       lcd_clear();
       lcd_printf("Enter new PC : ");
       dig1 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig2 = keyPad();
       lcd_printf("%c" , dig2);
       dig3 = keyPad(); 
       lcd_printf("%c" , dig3); 
       
       
       lcd_printf("\nRe-enter new PC : ");
       dig11 = keyPad();        
       lcd_printf("%c" , dig1); 
       dig22 = keyPad();
       lcd_printf("%c" , dig2);
       dig33 = keyPad(); 
       lcd_printf("%c" , dig3);
       
       if (dig1 != dig11 || dig2 != dig22 || dig3 !=dig33   ){
              ContactAdmin();
              return ;
       }
       newPassCode(userId ,dig1 , dig2, dig3 ); 
}
void closeDoor(){
      DDRC  |= (1 << 1);
      PORTC |= (1 << 1);
      delay_ms(2000);
      PORTC &= ~(1 << 1);
      delay_ms(2000);
}
void openDoor(){

      DDRC  |= (1 << 0);
      PORTC |= (1 << 0);
      delay_ms(2000);
      PORTC &= ~(1 << 0);
      delay_ms(2000);
      
}
int passCodeMatch ( int id , char pas1, char pas2 , char pas3 ){
       if(EE_Read(3*id ) == pas1 && 
          EE_Read(3*id + 1) == pas2 && 
          EE_Read(3*id + 2) == pas3 )
          {
              return 1;
          }
       return 0;
}
void initialPassCodes(char resetPc){
       if ( resetPc == '1' || 
           EE_Read(0) == 255 &&
           EE_Read(1) == 255 && 
           EE_Read(2) == 255  ){
                EE_Write(0 ,'2' );
                EE_Write(1 ,'0' );
                EE_Write(2 ,'3' );
                
                EE_Write(3 ,'1' );
                EE_Write(4 ,'2' );
                EE_Write(5 ,'9' );
                
                EE_Write(6 ,'3' );
                EE_Write(7 ,'2' );
                EE_Write(8 ,'5' );
                
                EE_Write(9 ,'4' );
                EE_Write(10 ,'2' );
                EE_Write(11 ,'6' );
                
                EE_Write(12 ,'0' );
                EE_Write(13 ,'7' );
                EE_Write(14 ,'9' );
           }

}
unsigned char EE_Read(unsigned int address){
       while(EECR.1 == 1);    //Wait till EEPROM is ready                  
       EEAR = address;        //Prepare the address you want to read from
       EECR.0 = 1;            //Execute read command
       return EEDR;
}
void EE_Write(unsigned int address, unsigned char data){
       while(EECR.1 == 1);    //Wait till EEPROM is ready                
       EEAR = address;        //Prepare the address you want to read from
       EEDR = data;           //Prepare the data you want to write in the address above
       EECR.2 = 1;            //Master write enable
       EECR.1 = 1;            //Write Enable
}
int findUser(char dig1, char dig2, char dig3){
       int i = 0 ;
       for (  ; i < 5 ; i = i + 1 ) {
              if(UsersIds[i][0] == dig1 && 
                 UsersIds[i][1] == dig2 && 
                 UsersIds[i][2] == dig3 ) 
                 return i;
       }  
       
       return 10;
}
void startSmartLock(){
       // interrupts 
       bit_set(MCUCR , 1);
       bit_set(MCUCR , 3);
       bit_clr(MCUCR , 0);
       bit_clr(MCUCR , 2);
       #asm("sei")
       bit_set(GICR , 6);
       bit_set(GICR , 7);
       
       // Set KeyPad port ;
       DDRB  = 0b00000111;
       PORTB = 0b11111000; 
       // Initiate LCD 
       lcd_init(20);   
       
       // Data 
       UsersIds[0][0]= '1';
       UsersIds[0][1]= '1';
       UsersIds[0][2]= '1'; 
                    
       UsersIds[1][0] ='1';
       UsersIds[1][1] ='2';
       UsersIds[1][2] ='6';
       
       UsersIds[2][0] ='1';
       UsersIds[2][1] ='2';
       UsersIds[2][2] ='8';
       
       UsersIds[3][0] ='1';
       UsersIds[3][1] ='3';
       UsersIds[3][2] ='0';
       
       UsersIds[4][0] ='1';
       UsersIds[4][1] ='3';
       UsersIds[4][2] ='2';
       
       
       UsersNames[0][0] = 'P';  
       UsersNames[0][1] = 'r';
       UsersNames[0][2] = 'o';
       UsersNames[0][3] = 'f';
                               
       
       UsersNames[1][0] = 'A';  
       UsersNames[1][1] = 'h';
       UsersNames[1][2] = 'm';
       UsersNames[1][3] = 'e';
       UsersNames[1][4] = 'd';
                              
       UsersNames[2][0] = 'A';  
       UsersNames[2][1] = 'm';
       UsersNames[2][2] = 'r';
       
       UsersNames[3][0] = 'A';  
       UsersNames[3][1] = 'd';
       UsersNames[3][2] = 'e';
       UsersNames[3][3] = 'l';  
       
       
       UsersNames[4][0] = 'O';  
       UsersNames[4][1] = 'm';
       UsersNames[4][2] = 'a';
       UsersNames[4][3] = 'r';
       initialPassCodes('0');
}
char keyPad(){
      while(1){     
            // C1 
            PORTB.0 = 0; PORTB.1 = 1; PORTB.2 = 1;
            //Only C1 is activated
            switch(PINB){
                case 0b11110110:
                while (PINB.3 == 0);
                return '1';
                break;
                
                case 0b11101110:
                while (PINB.4 == 0);
                return '4';
                break;
                
                case 0b11011110:
                while (PINB.5 == 0);
                return '7';
                break;
                
                case 0b10111110:
                while (PINB.6 == 0);
                return '*';
                break;
                
            }
            
            // C2
            PORTB.0 = 1; PORTB.1 = 0; PORTB.2 = 1;   
            //Only C2 is activated
            switch(PINB){
                case 0b11110101:
                while (PINB.3 == 0);
                return '2';
                break;
                
                case 0b11101101:
                while (PINB.4 == 0);
                return '5';
                break;
                
                case 0b11011101:
                while (PINB.5 == 0);
                return '8';
                break;
                
                case 0b10111101:
                while (PINB.6 == 0);
                return '0';
                break;
            }

            // C3
            PORTB.0 = 1; PORTB.1 = 1; PORTB.2 = 0;
            //Only C3 is activated
            switch(PINB){    
            
                case 0b11110011:
                while (PINB.3 == 0);
                return '3';
                break;
                
                case 0b11101011:
                while (PINB.4 == 0);
                return '6';
                break;
                
                case 0b11011011:
                while (PINB.5 == 0);
                return '9';
                break;
                
                case 0b10111011:
                while (PINB.6 == 0);
                return '#';
                break;
                
            }  
        
        }
}
void beepSound(){
      DDRD  |= (1 << 5);
      PORTD |= (1 << 5);
      delay_ms(200);
      PORTD &= ~(1 << 5);
      delay_ms(200);
}