# Day of Week Calculator in LC3 Assembly
### By Nathan Button
### For CS 2810

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

  - Note if you load these in the wrong order you will need to set your PC counter to x3000
3. Execute the program.
4. In the consul window enter the month as a number (1 = January, 2=February . . . 12 = December)
5. In the consul window enter the day.
6. In the consul window enter the full year (i.e. 1995)
7. The program will print out the day of the week.
8. Repeat steps 4-7 for more dates
