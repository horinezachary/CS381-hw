### CS381 Homework
##### Zachary Horine, Jonathan Rich and Griffin Thenell
### HW5

#### Description
The [Karel language](https://en.wikipedia.org/wiki/Karel_(programming_language)) is a simple imperative programming language for directing an on-screen robot. The robot can move around a grid, pick up and place “beepers”, and test aspects of its environment to determine what to do next. The syntax of the language is based on [Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language)). You can read the [documentation for an open source implementation of Karel](http://karel.sourceforge.net/doc/html_mono/karel.html), if you’re interested.

In this assignment, you’ll be implementing an interpreter for a slightly modified version of Karel. This version is feature-complete with the real Karel, but the syntax has been updated to be a bit more concise and [orthogonal](https://en.wikipedia.org/wiki/Orthogonality#Computer_science).

A detailed description of the Karel language is provided at the link below. You should read this page, and the provided support files thoroughly.

[Karel Language Description – READ THIS!](http://web.engr.oregonstate.edu/~walkiner/teaching/cs381-wi19/hw/karel.html)

**Note that you should only change the template file, KarelSemantics.hs, since this is the only file you will submit. If you change the supporting files, we will not be able to run your code!

The support code is well documented, so you should start by reading the code and trying out the functions in GHCi. If you have any questions about this code, please post them to Piazza. Here is a brief overview:

**KarelSyntax.hs:** Defines the abstract syntax of Karel.

**KarelState.hs:** Karel’s program state is rather complicated compared to the other languages we’ve defined. This file defines types for representing this state and also several helper functions that perform all of the basic operations you will need to write the semantics.

**KarelExamples.hs:** Provides some simple worlds and Karel programs to use in testing.

**KarelTests.hs:** A test suite for evaluating your semantics, and for helping you understand exactly how it should behave.

**KarelSemantics.hs:** The template you will be completing. The types of the required functions are provided, along with a couple example cases to get you started.

#### Tasks
The overall task is to define an interpreter for Karel. An interpreter in Haskell corresponds very closely to a denotational semantics. Aside from some theoretical differences that we briefly discussed in class, another difference is that when writing an interpreter we care about pragmatic issues like providing useful error messages.

I have broken this large task down into several smaller tasks, ordered roughly by difficulty. Hopefully this helps you get started and make progress.

1. Define the valuation functions for Test. A test is essentially a query over the state of the world and the state of the robot, which can either be true or false. Therefore, the semantic domain is: `World -> Robot -> Bool`.

2. Define the valuation function for the first five constructs of Stmt (two of these are provided already). These statements manipulate the state of the world and/or robot. The ultimate result of evaluating a statement is a value of type Result. This is one of  
     **(1)** an OK value that contains the updated state of the world and robot  
     **(2)** a Done value that should only be produced by the Shutdown statement  
        **-OR-**  
     **(3)** an Error value that contains an error message.  
     **Note:** to get the tests to pass, you’ll have to reverse engineer the error messages by reading the doctests.

3. Extend the stmt evaluation function to handle blocks. Once you get to this point, you should be able to pass the first section of tests in KarelTests.hs.

4. Extend the stmt function to handle conditional statements (If). Now you can hopefully pass the conditional tests.

5. Extend the stmt function to handle macro calls. The lookup function in the Haskell Prelude is very handy for this! Now you can hopefully pass the macro tests.

6. Finally, extend the stmt function to handle the looping constructs. Now you should be able to pass all of the tests!


### HW4

MiniMiniLogo is a simplified version of the MiniLogo language that you worked with in HW3, which is itself a simplified version of the Logo language for programming simple 2D graphics.

MiniMiniLogo is like MiniLogo, except that it doesn’t have macros, variables, or addition. This leaves only a very simple syntax remaining.
```haskell
   int    ::= (any integer)
   prog   ::= ε | cmd ; prog --sequence of commands
   mode   ::= down   |   up  -- pen status
   cmd    ::= pen mode	--change pen mode
            | move ( int , int )	--move pen to a new position
```
The following MiniLogo program (to draw a 2x2 square with its bottom-left corner at the origin) is also a valid MiniMiniLogo program.
```haskell
pen up; move (0,0);
pen down; move (2,0); move (2,2);
          move (0,2); move (0,0);
```
A Haskell implementation of the abstract syntax of MiniMiniLogo is already provided for you in the file MiniMiniLogo.hs. It also provides some functions to generate programs that draw simple shapes.

In this assignment, you will be implementing the semantics of MiniMiniLogo. The meaning of a MiniMiniLogo program is: (1) the change in the state of the pen and (2) a list of lines to draw.

Conceptually, the execution environment for a MiniMiniLogo program consists of two parts:

a canvas rooted at position (0,0) and extending infinitely upward and to the right
a pen which is always located at a certain absolute point on the canvas, and which can be in one of two states, either up or down
The move command moves the position of the pen from one absolute point to another. If the pen is down when it moves, it draws a straight line connecting the two points. If the pen is up, it just moves to the new point but does not draw a line. The state of the pen can be changed using the pen command as illustrated in the example program above.

The support file Render.hs defines types for representing the state of the pen, and provides a library for rendering the output of a MiniMiniLogo program as an SVG image in an HTML5 file.

#### Tasks
1. Implement cmd, the semantic function for MiniMiniLogo commands (Cmd). Note that a command updates the state of the pen and possibly draws a line. Therefore, the semantic domain is State -> (State, Maybe Line).

2. Implement prog, the semantic function for MiniMiniLogo programs (Prog). A program changes the state of the pen and may draw several lines. Therefore, the semantic domain is State -> (State, [Line]).

3. After you have implemented prog, you can use the draw function in the template to run a MiniMiniLogo program and render its output to HTML, which you can then load in your browser. To see if your semantics is working correctly, you can compare the result of running draw demo with this image: MiniMiniLogo-Demo.png

#### Extra credit
Use your creativity to produce a MiniMiniLogo program that draws an amazing picture! I will show off the most amazing pictures (anonymously) in class.

To get extra credit, you must do two things:

- Define the amazing variable in the template file. This should be the MiniMiniLogo program that generates the amazing picture.

- Submit the .html file produced by running draw amazing. To make things easier for me, first rename this file to reflect your amazing picture. For example, if your amazing picture is the Mona Lisa, name the file MonaLisa.html.

The amount of extra credit awarded will be proportional to the technical impressiveness and/or artistry of the amazing picture.

To make a truly amazing picture, you will probably need to define some helper functions that generate parts of your MiniMiniLogo program, similar to box, nix, and steps in MiniMiniLogo.hs. You are free to define as many of these helper functions as you wish.

In the past, some students have also modified the Render.hs file to make their pictures even more amazing. If you decide to go down the rabbit hole, please also submit your modified Render.hs file so that we can reproduce your amazing picture.

### HW3

MiniLogo is toy version of the Logo language for programming simple 2D graphics. A MiniLogo program describes a graphic by a sequence of move commands that move a pen from one position to another on a Cartesian plane, drawing lines as it goes. For example, here is a MiniLogo program that draws a 2x2 square with its bottom-left corner at the origin.

    pen up; move (0,0);
    pen down; move (2,0); move (2,2);
          move (0,2); move (0,0);

Conceptually, the MiniLogo execution environment consists of two parts:

- a canvas rooted at position (0,0) and extending infinitely upward and to the right

- a pen which is always located at a certain position on the canvas, and which can be in one of two states, either up or down

The move command moves the position of the pen from one position to another. If the pen is down when it moves, it draws a straight line connecting the two positions. If the pen is up, it just moves to the new position but does not draw a line. The state of the pen can be changed using the pen command as illustrated in the example program above.

In addition to basic pen and move commands, a MiniLogo program can define and invoke macros. A macro is a procedure that takes some coordinate values as inputs and performs some commands. Within the body of a macro, commands can refer to input values by name. For example, here is the definition of a macro that draws a 2x2 square starting from an arbitrary origin.
```haskell
define square (x,y) {
  pen up; move (x,y);
  pen down; move (x+2,y); move (x+2,y+2);
            move (x,y+2); move (x,y);
}
```
Now, if I want to draw two squares in two different places, later in my program I can call the macro with two different sets of arguments. The following will draw two 2x2 squares, one anchored at position (3,5), the other anchored at (13,42).

call square (3,5); call square (13,42);
Notice in the definition of the square macro, that we can also perform addition on coordinate values.

The concrete syntax of the MiniLogo language is defined by the following grammar:
```haskell
num	::=	(any natural number)
var	::=	(any variable name)
macro	::=	(any macro name)

prog	::=	ε   |   cmd ; prog	sequence of commands

mode	::=	down   |   up	pen status

expr	::=	var	variable reference
|	num	literal number
|	expr + expr	addition expression

cmd	::=	pen mode	change pen mode
|	move ( expr , expr )	move pen to a new position
|	define macro ( var* ) { prog }  	define a macro
|	call macro ( expr* )	invoke a macro
```
### Tasks
1) Define the abstract syntax of MiniLogo as a set of Haskell data types. You should use built-in types for num, var, and macro. (If you want to define a type Num, you will have to hide that name from the Prelude).

2) Define a MiniLogo macro line (x1,y1,x2,y2) that (starting from anywhere on the canvas) draws a line segment from (x1,y1) to (x2,y2).

    * First, write the macro in MiniLogo concrete syntax (i.e. the notation defined by the grammar and used in the example programs above). Include this definition in a comment in your submission.

    * Second, encode the macro definition as a Haskell value using the data types defined in Task 1. This corresponds to the abstract syntax of MiniLogo. Your Haskell definition should start with something like line = Define "line" ...

3) Use the line macro you just defined to define a new MiniLogo macro nix (x,y,w,h) that draws a big “X” of width w and height h, starting from position (x,y). Your definition should not contain any move commands.

    * First, write the macro in MiniLogo concrete syntax and include this definition in a comment in your submission.

    * Second, encode the macro definition as a Haskell value, representing the abstract syntax of the definition.

4) Define a Haskell function `steps :: Int -> Prog` that constructs a MiniLogo program that draws a staircase of n steps starting from (0,0). Below is a visual illustration of what the generated program should draw for a couple different applications of steps.

    * Example output of steps function:
```
                 _____ (1,1)                          _____ (3,3)
                |                                    |      
           (0,0)|                         (1,2) _____|     
                                               |
                                          _____|
                                         |      
                                    (0,0)|
                  steps 1                         steps 3
```

5) Define a Haskell function `macros :: Prog -> [Macro]` that returns a list of the names of all of the macros that are defined anywhere in a given MiniLogo program. Don’t worry about duplicates—if a macro is defined more than once, the resulting list may include multiple copies of its name.

6) Define a Haskell function `pretty :: Prog -> String` that pretty-prints a MiniLogo program. That is, it transforms the abstract syntax (a Haskell value) into nicely formatted concrete syntax (a string of characters). Your pretty-printed program should look similar to the example programs given above; however, for simplicity you will probably want to print just one command per line.

In GHCi, you can render a string with newlines by applying the function putStrLn. So, to pretty-print a program p use: `putStrLn (pretty p)`.

For all of these tasks, you are free to define whatever helper functions you need. You may also use functions from the Prelude and Data.List. You may find the functions intersperse or intercalate in Data.List useful for inserting commas in your implementation of pretty.

#### Bonus Problems
These problems are not any harder than the other problems in the assignment. They are included mainly to give you a bit more practice writing Haskell functions that manipulate syntax, if you want that. However, as a little external incentive, you will earn a small amount of extra credit if you complete them both.

1. Define a Haskell function `optE :: Expr -> Expr` that partially evaluates expressions by replacing any additions of literals with the result. For example, given the expression `(2+3)+x, optE` should return the expression 5+x.

1. Define a Haskell function `optP :: Prog -> Prog` that optimizes all of the expressions contained in a given program using optE.
