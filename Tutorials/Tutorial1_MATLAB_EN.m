%% Block Course Tutorial 1: Programming in MATLAB

% 0. Introduction to the MATLAB Tutorial
%     0.1 Intro
%     0.2 Code and Text
% 1. Basic Concepts
%     1.1 Variables
%     1.2 Arrays and Matrices
%         1.2.1 Concatenating
%     1.3 Parentheses
%     1.4 Indexing
%     1.5 Functions
%     1.6 Control Structures
%         1.6.1 if-else
%         1.6.2 for loops
%         1.6.3 while loops
%     1.7 Plotting

% 0.1 Intro
% Welcome to your first step into the world of programming with MATLAB! In
% this tutorial, you will learn the basic functions and layout of MATLAB,
% so you can familiarize yourself with the programming environment and tools
% of MATLAB.
%
% MATLAB Programming Environment
% When you open MATLAB, you see a workspace with several windows. Each of
% these windows has a specific function, which we briefly explain here:
%
% The window in which you are currently reading this text is the (Live)
% Editor (see title above in the blue box). Here you can write and save
% scripts. Our tutorials are Live Scripts. These offer the advantage that
% results of calculations are always displayed immediately to the right of
% the code – ideal for learning step by step and presenting results
% clearly. For this to work, you should now briefly click on the green arrow
% 'Run' (in the 'Live Editor' tab) at the top. If everything worked, you
% should see 'Hello!' as an example right here on the right.
disp("Hello!")
%
% In the image, you see an arrangement of the various other windows of the
% workspace in MATLAB. These can be moved around as you like. If you ever
% lose track and want to restore the default settings, you can click on
% 'Layout' in the 'Home' tab and then on 'Default'.
%
% The Command Window (usually at the bottom) is the central window in which
% you can execute MATLAB commands directly. It works like a console where
% you can type commands and see the results immediately. However, the
% commands are not saved, which is why we normally write our code in the
% Editor.
%
% In the Workspace window, you see all variables currently stored in MATLAB
% (more on this later). This is like an overview of your workspace that
% shows which data you are currently using. Here you can check, edit, or
% delete variables. Currently, all loaded variables should be displayed
% there. Otherwise, you would need to (again) click the green arrow 'Run'
% (in the 'Live Editor' tab).
%
% The Current Folder window shows the folder in which your files are saved.
% It helps you quickly access scripts and data.
%
% At first glance, this can seem a bit overwhelming. But don't worry, for
% now you only need to follow the steps here in the Live Editor. You don't
% need to enter anything below; all the code is already correct. Focus on
% getting to know the user interface and understanding the content of the
% following chapters.
%
% This tutorial is designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how programming
% with MATLAB works. You will have many opportunities to apply what you've
% learned later in the block course. If there are excursions at the end of a
% chapter, these are intended for those who are particularly interested;
% however, many of the topics discussed there will be relevant in the
% practice parts of the block course. They can be skipped for now if you
% want to focus on the essential content.
%
% Another tip: If some commands are unclear, MATLAB always offers a 'Help'
% function. To do this, type "help command" in the command window below,
% for example: help disp

% 0.2 Code and Text
% In the following, you will find a mixture of MATLAB code and text. The
% text is displayed normally, like the sentence you are currently reading.
% The code is separated from the text by a different font and gray boxes.
% Here is a small example:

% Example for code box in MATLAB Live Script
exampleArray = [4, 5, 6, 7];

% You will probably notice below that all text in the code windows that is
% written behind a '%' character appears in green. These are called
% comments. These are used to give titles to individual parts of large
% scripts and to explain the code contained therein. Everything written in
% the comments is ignored by MATLAB and not executed.

EXCURSUS Fonts: The fonts used for programming are not randomly chosen!
Perhaps the font in the gray boxes reminds you of the result of working on
a typewriter. The idea behind it is exactly the same: With the typewriter,
all letters should take up exactly the same amount of space so that no
overlaps occur. In programming, this ensures a clean, clear structure. Such
fonts are called monospaced because all letters take up exactly the same
area.

% 1.1 Variables
% Variables are storage locations. They are important because they allow us
% to store values and reuse them later in the code without having to enter
% the value again each time.
%
% In MATLAB, we can create a variable by giving it a name and assigning it
% a value with the '=' character.

% Creating a variable 'a' for a number
a = 5

% So we can assign the value 5 to our variable 'a'. Let's do this now with
% an additional variable:

% Creating an additional variable 'b' for a number
b = 3

% Now we have assigned the value 3 to our second variable 'b'.
%
% With these variables, we can now perform any mathematical operations:

% Mathematical operations with variables
a + b    % Addition
a - b    % Subtraction
a * b    % Multiplication
a / b    % Division
sqrt(a)  % Square root
a^b      % Exponent

% On the right side, the results of the mathematical operations are now
% displayed. As you may have noticed, not only the bare numbers are output
% anymore, but now 'ans' appears before each result. MATLAB gives us the
% answer here (hence 'ans', from answer), but this is not saved! To save
% results, we assign them to a new variable.

% Mathematical operations with variables, results are saved
add  = a + b    % Addition
sub  = a - b    % Subtraction
mult = a * b    % Multiplication
div  = a / b    % Division
wurz = sqrt(a)  % Square root
exp  = a^b      % Exponent

% Now we have saved all variables! Normally, however, we don't want all
% results to be output directly, as this can become quite confusing in
% larger scripts. That's why in MATLAB we write the character ';' after
% each line whose output we don't want to see.

% Hidden output with ';'
add  = a + b;    % Addition

% To display what is in a variable, we can either enter its name or use the
% function 'disp' (display).

% Output of variable values
add
disp(add)

% On the right side of this window, the values stored in the variables 'a',
% 'b', and 'add' are now visible.
%
% In addition to mathematical operations, MATLAB also has logical operators.
% These are used to formulate conditions, i.e., statements that are either
% true or false. Such logical expressions are the basis for control
% structures like if, elseif, else, which we will learn about in Chapter
% 1.6. A logical expression usually arises from comparing variables or
% values.

% Logical comparisons with variables (a is still = 5 and b = 3)
a > b     % greater than
a < b     % less than
a == b    % equal
a ~= b    % not equal

% On the right side, you now see either 1 or 0. A 1 means true, a 0 means
% false. We will use logical operators below to define control structures.
%
% Variables don't necessarily have to contain numbers. We can also store
% letters in variables.

% Creating a variable for text
name = 'MATLAB';
alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

% To display what is in a variable, we can again use the function 'disp'.

% Output of variable values
disp(name);
disp(alphabet);

EXCURSUS Variable naming: The name of the variable can be chosen freely,
but should be meaningful and self-explanatory to increase code readability.
The convention in programming is the so-called camelCase. camelCase
describes a way of writing variable names in which multiple words are
concatenated without separators. The initial letters from the second word
onward are capitalized to improve readability. The name comes from the fact
that the capital initial letters look like the humps of a camel. Examples:
variableNames, rowVector, columnVector. This should implicitly make it
clear that MATLAB is case-sensitive, i.e., 'Variable' and 'variable' are
not the same.

% 1.2 Arrays and Matrices
% An array is a collection of values arranged in a specific order. An array
% is created with square brackets [], where the values are separated by
% commas, semicolons, or spaces.
%
% A one-dimensional array (like a list) we call a vector in MATLAB. This
% one dimension can be either a row or a column.

% Creating a row vector (array with one row)
rowVector = [1, 2, 3, 4, 5]

% If we want to store consecutive numbers in a variable, we can also simply
% use a colon.

% Creating a row vector (array with one row)
rowVector = 1:5

% Occasionally we need an empty array, e.g., when we want to leave certain
% options as default in a function (see below).

% Creating an empty array
emptyArray = []

% As you can see above, values that should be in the same row are separated
% by a comma. If we want the values in a new row, we separate them with a
% semicolon (';').

% Creating a column vector (array with one column)
columnVector = [6; 7; 8; 9; 10]

% Now rows and columns can be combined arbitrarily. A resulting
% two-dimensional array (similar to a table) we call a matrix in MATLAB.

% Creating a matrix (2x3 matrix with 2 rows and 3 columns)
matrix = [1, 2, 3; 4, 5, 6]

% Of course, vectors and matrices can also be created with letters. We
% already saw a letter vector above when we displayed the alphabet.

% Creating a vector with letters
letterVector = ['A', 'B', 'C']
alphabet

% Creating a matrix with letters
letterMatrix = ['A', 'B', 'C'; 'D', 'E', 'F']

% For consecutive letters, you can also use the colon again.

% Creating a vector with letters
alphabet = 'A':'Z'

% 1.2.1 Concatenating
% Concatenating describes the joining of arrays or matrices. This makes it
% possible to create larger arrays or matrices from several smaller ones by
% appending them. There are two basic types of concatenation: horizontal
% and vertical.
%
% Horizontal Concatenation
% In horizontal concatenation, arrays or matrices are joined side by side.
% We use a comma between the numbers.

% Join row vectors horizontally
vector1 = [1, 2, 3]
vector2 = [4, 5, 6]
joinedVector = [vector1, vector2]

% Vertical Concatenation
% In vertical concatenation, arrays or matrices are joined one below the
% other. We use a semicolon between the numbers.

% Join row vectors vertically
joinedVector = [vector1; vector2]

% Important: When concatenating, the dimensions of the arrays or matrices
% must match. For example, in horizontal concatenation, the number of rows
% must be equal, and in vertical concatenation, the number of columns must
% be equal.

EXCURSUS Concatenating matrices: We can also concatenate entire matrices.
This works exactly the same as described above. We use commas for
horizontal concatenation and semicolons for vertical concatenation.

% Create matrices
matrix1 = [vector1; vector2]
matrix2 = [7, 8, 9; 10 11 12]

% Join matrices vertically
joinedMatrix = [matrix1, matrix2]

% Join matrices horizontally
joinedMatrix = [matrix1; matrix2]

% 1.3 Parentheses
% Parentheses have different meanings in MATLAB.
%
% Round parentheses ( ) are used for calling functions and for indexing (see
% 1.4 Indexing).

% Round parentheses for function input
sqrt25 = sqrt(25)

% In this example, we use round parentheses to give the function sqrt the
% number 25 as input. As a result, we get 5.
%
% As learned above, square brackets [ ] are used for concatenation. Thus,
% you can create arrays or matrices using square brackets.

% Square brackets for creating an array
array = [1, 2, 3, 4]

% Square brackets were used in this example to create an array with the
% values 1, 2, 3, and 4.

EXCURSUS Curly braces: Curly braces { } are used for cell arrays. This
special type of array has the particularity that different data types can
% be packed into it.

% Curly braces for arrays with various data
cellArray = {letterVector, sqrt25, array}

% In our cellArray, we now have various data stored. In cell (1,1) are the
% letters 'ABC' from our letterVector. In cell (1,2) is the number 5 from
% variable sqrt25. In cell (1,3) is our array with the numbers 1, 2, 3, 4.
% We see that using cell arrays enables us to store different data types in
% one variable.

% 1.4 Indexing
% Indexing is the method by which you access specific elements of an array
% or matrix. In MATLAB, indexing starts at 1, meaning the first element of
% an array has index 1. You can access elements by specifying the position
% of the element in round parentheses.
%
% For a vector, this is quite simple. We simply specify the exact position
% of the element in the list.

% Accessing a specific element in an array
array = [10, 20, 30, 40];
secondElement = array(2)

% In a (two-dimensional) matrix, this works exactly the same! However, here
% we must specify in which row and column our desired element is located.
% We can do this by first specifying the value for the row, and then,
% separated by a comma, the value for the column. With matrix(2, 3), we
% access the element in the second row and third column, which is 6 here.

% Accessing an element in a matrix
matrix = [1, 2, 3; 4, 5, 6];
six = matrix(2, 3); % Second row, third column

EXCURSUS Finding index with function: Of course, you can also cleverly use
a function here. For example, you can use the function find to find the
index of a specific value.

% Find index in array
fortyArrayIndex = find(array == 40)
array(fortyArrayIndex)

% Find index in matrix
[fiveRowMatrixIndex, fiveColumnMatrixIndex] = find(matrix == 5)
matrix(fiveRowMatrixIndex, fiveColumnMatrixIndex)

% In the excursion, it is shown how to use the function find to find the
% position (index) of a specific value in an array or matrix and then
% access this element: With find(array == 40), the index of the value 40 in
% the array is found. This index (here: fourth position in the array) is
% used to directly access the element: array(fortyArrayIndex). With
% [fiveRowMatrixIndex, fiveColumnMatrixIndex] = find(matrix == 5), the row
% and column indices of the value 5 (2, 2) in the matrix are found.
% Subsequently, you can directly access the element:
% matrix(fiveRowMatrixIndex, fiveColumnMatrixIndex). The function find
% returns the position(s) at which the condition is satisfied. These can be
% directly used to access the element.

% 1.5 Functions
% Functions are special commands from preprogrammed code that perform a
% specific task.
%
% We already know two functions! In Chapter 1.1 Variables, we learned
% 'disp' and 'sqrt'. Functions are called by their name and take arguments
% (inputs) in round parentheses ( ). They return a result that can be stored
% in a variable.

% Calculating the square root of a number
sqrt_result = sqrt(16);

% Outputting the result
disp(sqrt_result)

% Here the function 'sqrt' is used to calculate the square root of the
% number 16. The result, 4, is stored in the variable sqrt_result. We
% output this result with the function 'disp'.
%
% MATLAB has many built-in functions that perform common mathematical
% calculations. For example, we can output the mean. We show this now
% directly using the vectors we just defined.

% Calculating the mean from a vector
meanRowVector = mean(rowVector)

% The mean of our variable rowVector is thus 3. This works exactly the
% same with the variable columnVector, of course.

% Calculating the mean from a vector
meanColumnVector = mean(columnVector)

% For columnVector, the mean is 8. Functions make complex calculations
% easier for us because we only need to specify the function name and the
% input values.
%
% There are numerous other functions that can be used in MATLAB. We will
% learn many other functions in the course.

% 1.6 Control Structures
% With control structures, you can control the flow of program code. Here
% we will only look at the two essential structures: if-else and for-loops.

% 1.6.1 if-else
% In MATLAB, we can execute only certain parts of the code by using
% conditions. A condition is like a question that is answered either true
% or false. Depending on whether the condition is true or false, a specific
% part of the code is executed. For this, we use the if-else structure.

% Example if-else: Check if a number is positive
number = -5;
if number > 0
    disp('The number is positive.');
else
    disp('The number is negative.');
end

% Here we check if the variable number is greater than 0. If yes, 'The
% number is positive.' is output. If the variable number is less than 0,
% 'The number is negative.' is output. Instead of > and <, you can also
% use == (equal) and ~= (not equal). The if-else structure must always be
% closed with a concluding end. Try what happens if you define a positive
% number (e.g., 5).
%
% Now you can add another condition. What should be output if the number is
% exactly 0?

% Example if-else: Check if a number is positive
number = 0;
if number > 0
    disp('The number is positive.');
elseif number == 0
    disp('The number is 0.');
else
    disp('The number is negative.');
end

% The additional line of code elseif allows us to add another condition with
% a different outcome. We can do this as many times as we want. For all
% cases where the if and elseif conditions don't apply, else is used.

% 1.6.2 for loops
% The second essential control structure is the so-called for-loops. These
% are used to repeatedly execute a specific action. The number of
% repetitions is defined by the loop variable.

% Example for-loop: Output numbers from 1 to 5
for i = 1:5
    disp(['The current number is: ', num2str(i)])
end

% In this example, we define i as the loop variable that runs from 1 to 5.
% This reads as: Start at i = 1, increase the value by 1 each time, and go
% until i = 5. Also within the loop, i can be used to perform further
% calculations. In this example, the current number (the variable i) is
% output with 'disp' each time.
%
% Note: For this text output (disp), we want to use square brackets to
% connect two text elements. However, the value in i (e.g., the number 1)
% must be converted to the character "1". This is done with the function
% num2str (short for "number-to-string"). For programming languages,
% numbers and characters are different things (so-called "data types").
%
% Instead of outputting the results directly, we can also save them and
% output them with 'disp' after the for-loop ends.

% Example: Calculate and save squares of numbers from 1 to 5
for i = 1:5
    squares(i) = i^2;
end
disp('The squares of the numbers from 1 to 5:');
disp(squares)

% Here's what happens:
% In each iteration, the current value of i is squared (i^2). We also use
% the current value i (e.g., 1 in the first loop iteration) to save the
% result of the squaring in an array 'squares' (squares(i), see indexing
% chapter above).
%
% Specifically, this means for loop iteration 2 and loop iteration 3:
% Loop iteration 2: i currently has the value 2. So 2 is squared (=4) and
% the result is saved at the second position in the array squares(2).
% Loop iteration 3: i currently has the value 3. So 3 is squared (=9) and
% the result is saved at the third position in the array squares(3).

% 1.6.3 while loops
% In addition to for-loops, MATLAB also has while-loops. A while-loop
% executes code as long as a condition is true. Unlike the for-loop, the
% number of iterations is thus not predetermined, but depends on the course
% of the program. As long as the condition of the while-loop is true, the
% inner code block is executed again.

% Example while-loop: Squaring
i = 1;
square = 0;

while square <= 20
    square = i^2;
    i = i + 1;
end

disp('First square greater than 20:');
disp(['Loop iteration ', num2str(i), ' with value i = ', num2str(square)])

% While-loops are often used to automate program flows when it's not clear
% how many iterations are necessary, a process should run until a criterion
% is reached, or data should be checked or changed step by step.

% 1.7 Plotting
% Plotting means displaying data graphically. MATLAB offers many functions
% for this, with plot being the most common. With plot, you can display
% values as connected data points in a diagram, where the x-values
% (horizontal axis) and y-values (vertical axis) are specified.

% Creating x- and y-values
x = [0, 1, 2, 3, 4];
y = [0, 1, 4, 9, 16];

% Drawing the plot
plot(x, y)

% Adding titles and axis labels
title('Simple plot of x and y');
xlabel('x-values');
ylabel('y-values');

% Here we create a plot by displaying the values of x and y graphically.
% Each value in x is combined with the corresponding value in y and drawn
% on the chart. The axes can be labeled to make the data more
% understandable.
%
% Well done! You are now finished with Tutorial 1: Programming in MATLAB!
%
% Below are some examples of how to further edit plots. You are welcome to
% look at these, but it's completely optional. In any case, continue with
% Tutorial 2: Digital Signal Processing.
% ----------------------------------------------------------------

EXCURSUS Editing a plot:
% Example 1: Plot with line color and line style
% We can change the line color and line style to make the plot more
% appealing. MATLAB offers many options, such as 'r' for red, 'b' for blue.

% Creating x- and y-values
x = [0, 1, 2, 3, 4];
y = [0, 1, 4, 9, 16];

% Drawing the plot with red line and dashed style
plot(x, y, 'r--'); % 'r' for red and '--' for dashed line

% Adding titles and axis labels
title('Simple plot with custom style');
xlabel('x-values');
ylabel('y-values');

% In this example, the line is displayed in red ('r') and dashed ('--').
% MATLAB also supports many other line styles such as '-.' (dash-dot) or
% ':' (dotted line).

% Example 2: Adding markers
% We can add markers (e.g., points) at the data points to highlight them.
% These markers can be represented by special symbols, such as circles,
% squares, or plus signs.

% Creating x- and y-values
x = [0, 1, 2, 3, 4];
y = [0, 1, 4, 9, 16];

% Drawing the plot with markers (circles) at the data points
plot(x, y, 'r-o'); % 'o' adds circle markers

% Adding titles and axis labels
title('Plot with markers');
xlabel('x-values');
ylabel('y-values');

% In this case, each point in the plot is displayed as a red circle ('o').
% You can also use other markers, such as '*' for stars or '+' for plus
% signs.

% Example 3: Changing axis limits
% Sometimes we want to adjust the axes so that they cover a specific range
% or improve the display of the data. This can be easily done with the
% function axis.

% Creating x- and y-values
x = [0, 1, 2, 3, 4];
y = [0, 1, 4, 9, 16];

% Drawing the plot
plot(x, y, 'b-'); % 'b' for blue line

% Adjusting axis limits
axis([0 5 0 20]); % x-axis from 0 to 5, y-axis from 0 to 20

% Adding titles and axis labels
title('Plot with custom axis limits');
xlabel('x-values');
ylabel('y-values');

% In this example, the plot area is set by axis([0 5 0 20]), where the
% x-axis range goes from 0 to 5 and the y-axis range goes from 0 to 20. Of
% course, the line in the plot stops at (4, 16) here, since no more data
% points were defined above that.

% Example 4: Adding a grid
% Adding a grid can help visualize the values on the plot better.

% Creating x- and y-values
x = [0, 1, 2, 3, 4];
y = [0, 1, 4, 9, 16];

% Drawing the plot
plot(x, y, 'g-o'); % 'g' for green and 'o' for marker

% Adding a grid
grid on;

% Adding titles and axis labels
title('Plot with grid');
xlabel('x-values');
ylabel('y-values');

% By grid on, the grid is activated, which helps to better recognize the
% positions of the data points.

% Example 5: Changing font and font size
% A common adjustment concerns the fonts and sizes of titles and axis
% labels. MATLAB allows you to adjust these properties with the functions
% title, xlabel, and ylabel.

% Creating x- and y-values
x = [0, 1, 2, 3, 4];
y = [0, 1, 4, 9, 16];

% Drawing the plot
plot(x, y, 'm-o'); % 'm' for magenta and 'o' for marker

% Adding titles and axis labels with adjusted font size and type
title('Plot with adjusted font', 'FontSize', 14, 'FontName', 'Arial');
xlabel('x-values', 'FontSize', 12, 'FontName', 'Arial');
ylabel('y-values', 'FontSize', 12, 'FontName', 'Arial');

% In this example, we change the font size and font type for the title and
% axis labels. FontSize sets the font size, and FontName changes the font
% type.

% Example 6: Plotting multiple datasets in one diagram
% Often we want to display multiple datasets in one diagram. This is done
% simply by using multiple plot commands one after another. MATLAB then
% adds each series to the same plot.

% Creating x-values
x = [0, 1, 2, 3, 4];

% Creating two different datasets
y1 = [0, 1, 4, 9, 16];
y2 = [0, 1, 2, 3, 4];

% Drawing the first plot (blue line)
plot(x, y1, 'b-o', 'DisplayName', 'y = x^2'); % 'DisplayName' gives the legend a name

hold on; % Keeps the current plot so that further data can be plotted on it

% Drawing the second plot (red line)
plot(x, y2, 'r-s', 'DisplayName', 'y = x'); % 's' for square markers

% Adding a legend
legend show;

% Adding titles and axis labels
title('Plot with multiple datasets', 'FontSize', 14, 'FontName', 'Arial');
xlabel('x-values', 'FontSize', 12, 'FontName', 'Arial');
ylabel('y-values', 'FontSize', 12, 'FontName', 'Arial');

hold off; % Ends holding the plot

% In this example, we plot two datasets (y1 and y2) in the same diagram,
% where the first dataset is displayed with a blue line and markers and
% the second dataset with a red line and square markers. For overlaying the
% two datasets in one plot, we use the function 'hold on'. The function
% 'legend show' displays the legend that explains each dataset.
