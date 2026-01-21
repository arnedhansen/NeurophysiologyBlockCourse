%% Tutorial 3 – Data Structures in MATLAB
% This optional tutorial deepens your understanding of data structures in MATLAB,
% as they are useful later in EEG analysis.
%
% Contents:
% 
% - 0. Introduction
% - 1. Why data structures are important
% - 2. Structures (struct)
%   - 2.1 Creating simple structures
%   - 2.2 Accessing and modifying fields
%   - 2.3 Nested structures
%   - 2.4 Example: Mini-EEG structure
% - 3. Cell arrays (cell)
%   - 3.1 Creating cell arrays
%   - 3.2 Cell arrays in EEG analysis
%   - 3.3 Accessing elements: IMPORTANT DIFFERENCE
% - 4. Tables (table) for behavioral data
%   - 4.1 Creating tables
%   - 4.2 Filtering and sorting
%   - 4.3 Combining tables with additional information
% - 5. Mix of everything: modeling a small EEG study
%   - 5.1 Loop over all participants
%   - 5.2 Summarizing results in a table

%% 0. Introduction
% So far, we have mainly worked with simple variables: numbers, vectors, and
% matrices. In EEG analysis, however, we work with complex data that consists
% of many different pieces of information:
% - Measurement data (time × channel × trial)
% - Metadata (subject, condition, age, gender, ...)
% - Events (triggers, reaction times, ...)
%
% MATLAB provides various data types to organize this information meaningfully.
% In this tutorial, you will learn about three important data structures:
% structures (struct), cell arrays (cell), and tables (table).
%
% These tutorials are designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how different data
% structures work. You will have many opportunities to apply what you've learned
% later in the block course.

%% 1. Why data structures are important
% Imagine you have collected data from several participants (VPs): reaction
% times, accuracy, age, gender, condition, etc. How could you store this
% information?
%
% One possibility would be to create a separate vector for each piece of
% information:

reaction_times = [520 480 510 495];   % in milliseconds
accuracy      = [1   0   1   1  ];   % 1 = correct, 0 = incorrect
age           = [23  25  22  30];    % Age of VPs

mean_rt = mean(reaction_times)
mean_acc = mean(accuracy)

% This works, but it quickly becomes confusing when you have many pieces of
% information. Also, you must ensure that all vectors have the same length and
% the order is correct (e.g., that the reaction time at position 1 really
% belongs to VP 1).
%
% Data structures help you group related information and make the code more
% organized. In this tutorial, you will learn about three important structures:
% struct, cell, and table.

%% 2. Structures (struct)
% Structures allow you to store different pieces of information under one name
% using so-called fields. This is comparable to a "folder" for a participant in
% which various pieces of information are stored.

%% 2.1 Creating simple structures
% We create a structure for a participant. The structure is called "vp1" and
% contains various fields, which we separate with a dot (.).

vp1.id        = 1;
vp1.age       = 23;
vp1.gender    = "f";
vp1.condition = "Stroop_congruent";
vp1.reaction_times = [520 480 510 495];
vp1.accuracy      = [1   0   1   1  ];

vp1   % Display the structure

% As you can see, all information is now stored under one name "vp1". The
% structure has various fields: id, age, gender, condition, reaction_times, and
% accuracy. Each field can contain a different data type (number, text, vector).

%% 2.2 Accessing and modifying fields
% You access fields of a structure using dot notation. You simply specify the
% name of the structure, then a dot, then the name of the field.

vp1.age
vp1.reaction_times

% You can also modify fields by assigning them a new value:

vp1.age = 24;

% And you can add new fields at any time:

vp1.handedness = "right";

vp1   % The structure now also contains the new field "handedness"

% IMPORTANT NOTE: Structures are very flexible. You can add new fields at any
% time, but make sure to keep the spelling consistent (e.g., always "gender"
% and not sometimes "gender", sometimes "Gender").

%% 2.3 Nested structures
% Structures can contain other structures as fields. This is practical for
% grouping information.

vp1.demographics.age      = 24;
vp1.demographics.gender  = "f";

vp1.experiment.condition  = "Stroop_congruent";
vp1.experiment.session    = 1;

vp1.demographics
vp1.experiment

% Here we have organized the information into substructures: "demographics"
% contains all demographic information, "experiment" contains all
% experiment-related information. This makes the code more organized when you
% have many pieces of information.

%% 2.4 Example: Mini-EEG structure
% In EEGLAB, EEG data is stored in a large structure called `EEG`. We build a
% heavily simplified version here so you understand how such structures are
% organized.

EEG_mini.srate   = 250;                  % Sampling rate in Hz
EEG_mini.chanlocs = ["Fz","Cz","Pz"];    % Channel names (channel locations)
EEG_mini.data    = randn(3, 2500);       % 3 channels × 2500 time points
EEG_mini.times   = (0:2499) / EEG_mini.srate * 1000; % Time in ms

size(EEG_mini.data)

% The structure `EEG_mini` now contains various pieces of information about our
% EEG data: the sampling rate (srate), the channel names (chanlocs), the actual
% measurement data (data), and a time vector (times). Later in the block course,
% you will work with real EEG structures that contain many more fields (e.g.,
% Events, epochs, ICA components, etc.).

%% 3. Cell arrays (cell)
% Cell arrays allow you to store elements of different sizes or types in a
% "matrix". Access is done with curly braces {} instead of parentheses ().

%% 3.1 Creating cell arrays
% Example: various instruction texts of different lengths

instructions = { ...
    "Please respond as quickly and accurately as possible."; ...
    "Take breaks in between if you get tired."; ...
    "Fixate on the point in the center of the screen."};

instructions{1}

% As you can see, we use curly braces {} to create and access elements of a
% cell array. The first element is a longer text, the second is an even longer
% text, the third is a shorter text. In a normal matrix, all rows would have to
% be the same length; here they can be different lengths.

%% 3.2 Cell arrays in EEG analysis
% Cell arrays are particularly useful when you have a different number of
% trials per condition. For example, condition 1 might have four trials,
% condition 2 only three trials, and condition 3 five trials.

rt_condition = cell(1,3);  % Create a cell array with 1 row and 3 columns

rt_condition{1} = [520 480 510 495];      % Condition 1: 4 trials
rt_condition{2} = [610 590 620];          % Condition 2: 3 trials
rt_condition{3} = [700 710 690 705 695];  % Condition 3: 5 trials

% Number of trials per condition
n_trials = cellfun(@length, rt_condition)

% The function `cellfun` applies a function (here `length`) to each element of
% a cell array. The result is a normal vector with the length of each element.
% You can see: condition 1 has 4 trials, condition 2 has 3 trials, condition
% 3 has 5 trials.

%% 3.3 Accessing elements: IMPORTANT DIFFERENCE
% This is a common beginner mistake! There is an important difference between
% parentheses () and curly braces {}:

rt_cond1_cell = rt_condition(1)    % returns a 1×1 cell (still a cell array!)
rt_cond1_vec  = rt_condition{1}    % returns the numeric vector (the content of the cell)

% With parentheses (1), you access the element as a cell – so you get a cell
% array back. With curly braces {1}, you access the content of the cell – so
% you get the numeric vector back.
%
% If you want to do calculations with the data (e.g., calculate the mean), you
% need curly braces:

mean_rt = cellfun(@mean, rt_condition)

% The function `cellfun` with `@mean` automatically calculates the mean for each
% element in the cell array. The result is a vector with the means: [501.25,
% 606.67, 700.00] (rounded).

EXCURSUS Curly braces vs. parentheses: This difference is very important and
often overlooked! Think of a cell array like a box with several compartments.
With parentheses (1), you take out the whole box (so you get a box back). With
curly braces {1}, you open the box and take out the content (so you get the
actual content – e.g., a numeric vector – back). If you want to do calculations
with the data, you always need the content, so use curly braces.

%% 4. Tables (table) for behavioral data
% Tables are practical for organizing participant and experimental data in a
% form similar to Excel. Each column can have a different data type, and you
% can easily filter, sort, and combine.

%% 4.1 Creating tables
% We create a table with information about several participants:

vp_id   = [1; 2; 3; 4];
age     = [23; 25; 22; 30];
condition = ["A"; "A"; "B"; "B"];
mean_rt = [500; 520; 540; 560];

T = table(vp_id, age, condition, mean_rt, ...
    'VariableNames', {'VP','Age','Condition','Mean_RT'});

T

% As you can see, the table is displayed similarly to an Excel table: each row
% is a participant, each column is a variable. We specified the column names
% with 'VariableNames'. IMPORTANT: In tables, all columns must have the same
% number of rows (here: 4 rows).

%% 4.2 Filtering and sorting
% Tables make it easy to filter and sort data. For example, we can display only
% participants from condition A:

T_A = T(T.Condition == "A", :)

% The syntax `T.Condition == "A"` creates a logical vector (true/false) that
% indicates which rows have condition "A". With `:` we say that we want to keep
% all columns. The result is a new table with only the rows that have condition
% "A".
%
% We can also sort the table by reaction time:

T_sort = sortrows(T, "Mean_RT", "ascend")

% The function `sortrows` sorts the rows of a table by a specific column.
% "ascend" means ascending (smallest RT first), "descend" would mean descending
% (largest RT first).

%% 4.3 Combining tables with additional information
% Suppose we have a second table with, e.g., questionnaire values. We can
% merge these tables:

questionnaire = table([1;2;3;4], [12;18;15;10], ...
    'VariableNames', {'VP','Stress_Scale'});

questionnaire

% Merge tables by VP ID:

T_merged = join(T, questionnaire, 'Keys', 'VP')

T_merged

% The function `join` connects two tables based on a common column (here: 'VP').
% The result is a new table that contains all columns from both tables.
% Participants that only appear in one table are not included (this is an
% "inner join" – there are also other join types, but we don't need them here).

%% 5. Mix of everything: modeling a small EEG study
% Now we combine everything we've learned and create a data structure for
% multiple participants. This is similar to what you will do later in the
% block course when analyzing data from multiple VPs.

n_vp = 3;
vp = struct();  % Create an empty structure

for i = 1:n_vp
    vp(i).id        = i;
    vp(i).age       = randi([20 35]);  % Random age between 20 and 35
    vp(i).condition = randsample(["A","B"],1);  % Random condition A or B
    vp(i).rt        = 400 + randn(1,20)*30;  % 20 trials with random RTs
end

vp

% Here we have created a structure that contains multiple participants. Each
% participant is an element in the array `vp`. `vp(1)` is the first VP, `vp(2)`
% is the second VP, etc. Each VP has the fields id, age, condition, and rt
% (reaction times as a vector with 20 trials).
%
% IMPORTANT NOTE: `vp` is an array of structures. This means that `vp` itself
% is an array (like a vector), but each element is a structure. You can access
% the structure of the first VP with `vp(1)` and then access its fields with
% `vp(1).age`, `vp(1).rt`, etc.

%% 5.1 Loop over all participants
% Now we can iterate over all participants and, e.g., calculate the means:

for i = 1:n_vp
    fprintf("VP %d (Condition %s): mean RT = %.1f ms\n", ...
        vp(i).id, vp(i).condition, mean(vp(i).rt));
end

% The function `fprintf` outputs formatted text. `%d` stands for an integer,
% `%s` for text, `%.1f` for a decimal number with one decimal place. `\n`
% creates a line break.
%
% You can see that each VP has a different mean reaction time (because we
% generated random values). In real data, you would see the actual means here.

%% 5.2 Summarizing results in a table
% Often you want to summarize the results of all participants in a table. This
% is how:

vp_id   = (1:n_vp)';
age     = arrayfun(@(x)x.age, vp)';
cond    = string({vp.condition})';
mean_rt = arrayfun(@(x)mean(x.rt), vp)';

ResultTable = table(vp_id, age, cond, mean_rt, ...
    'VariableNames', {'VP','Age','Condition','Mean_RT'})

ResultTable

% This looks complicated, but step by step:
% - `arrayfun(@(x)x.age, vp)` applies a function to each element of `vp` and
%   extracts the field `age`
% - `string({vp.condition})` converts the condition values to strings
% - `arrayfun(@(x)mean(x.rt), vp)` calculates the mean of the RTs for each VP
% - The `'` at the end transposes the vectors to column vectors (for the table)
%
% The result is a clear table with all important information about the
% participants. You can then use this table, e.g., in R or Python for further
% processing or save it as a CSV file.

EXCURSUS arrayfun and cellfun: These functions are very useful when you want to
apply operations to all elements of an array or cell array. `arrayfun` works
with normal arrays (e.g., arrays of structures), `cellfun` works with cell
arrays. The syntax `@(x)x.age` is a so-called anonymous function: it takes an
element `x` and returns `x.age`. You could also do this with a normal for
loop, but `arrayfun` and `cellfun` are often shorter and more readable.

%% Summary
% In this tutorial, you have learned about three important data structures:
%
% 1. **Structures (struct)**: Organize related information under one name with
%    fields. Practical for participants or EEG data.
%
% 2. **Cell arrays (cell)**: Allow storing elements of different sizes or
%    types. Practical when you have, e.g., different numbers of trials per
%    condition.
%
% 3. **Tables (table)**: Organize data similar to Excel tables. Practical for
%    behavioral data that you want to filter, sort, and combine.
%
% You will use these structures frequently later in the block course,
% especially when working with EEG data. The EEGLAB structure `EEG` is itself a
% large structure with many fields, and you will often use tables to organize
% results from multiple participants.
