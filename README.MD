# Day of Week Calculator in LC3 Assembly
#### By Nathan Button for CS 2810

## Description
This LC3 Assembly project takes a Georgian date and prints out what day of the week it was. It uses the Zeller Function to calculate the day

## Files
#### day_of_week.asm
The main driver and entry point for the program
#### prompt.asm
Prompts the user for the date and stores the decimal values for month, day, and year in R1, R2, and R3 respectively, then returns back to the main program
#### print_day.asm
Prints the value of R6 as a string representation of the day. (0 = Saturday, 1 = Sunday, . . . 6 = Friday)

## Building and Running
1. Using the LC3 Editor load each assembly file and assemble it.
2. Using the LC3 Simulator load the object files in the following order  
  - print_day.obj
  - prompt.obj
  - day_of_week.obj

  ** Note if you load these in the wrong order you will need to set your PC counter to x3000
3. Execute the program.
4. In the console window enter the month as a number (1 = January, 2=February . . . 12 = December)
5. In the console window enter the day.
6. In the console window enter the full year (i.e. 1995)
7. The program will print out the day of the week.
8. Repeat steps 4-7 for more dates

## Zeller Function
[Zeller Function](https://en.wikipedia.org/wiki/Zeller%27s_congruence) is a function to determine the day of the week from a date.

![](https://upload.wikimedia.org/math/a/f/c/afc4370e24fdc8720f2569d8a1b7d0d0.png) [^1]

Where
- h is the day of the week (0 = Saturday, 1 = Sunday, 2 = Monday, ..., 6 = Friday)
- q is the day of the month
- m is the month (3 = March, 4 = April, 5 = May, ..., 14 = February)
- K the year of the century (year MOD 100). For example, the zero-based centuries for 1995 and 2001 are 95 and 1 respectively
- J is the zero-based century ( year/100 ) For example, the zero-based centuries for 1995 and 2001 are 19 and 20 respectively

The formulas rely on the mathematician's definition of modulo division, which means that −2 mod 7 is equal to positive 5. Unfortunately, the way most computer languages implement the remainder function, −2 mod 7 returns a result of −2. We use a modified version of the equation to stop this from happening.

![](https://upload.wikimedia.org/math/5/1/2/5127c3c9c05a60a9aa66c8d34a8970a4.png) [^1]

[^1]: Images from wikipedia 
