%% Tutorial 4 – Clean Code & Reproducibility
% This optional tutorial shows you principles for well-structured, reproducible
% code. These skills are important when you later work with real EEG data in the
% block course.
%
% Contents:
% 
% - 0. Introduction
% - 1. Why clean scripts are important
% - 2. Structure of analysis scripts
%   - 2.1 Example: Basic structure
% - 3. Loops over subjects and conditions
%   - 3.1 Loop over subjects
%   - 3.2 Nested loops: Subjects and conditions
% - 4. Writing functions
%   - 4.1 Simple function
%   - 4.2 Function with multiple outputs
%   - 4.3 Function for a preprocessing step
% - 5. Mini-project: Small analysis pipeline
%   - 5.1 Example code skeleton
%   - 5.2 Tips for good pipeline structure
% - 6. Error handling
%   - 6.1 try-catch for robust scripts
%   - 6.2 warning vs. error
% - 7. Debugging tips
%   - 7.1 Outputs with disp and fprintf
%   - 7.2 Timing with tic and toc
%   - 7.3 Inspecting workspace

%% 0. Introduction
% So far, you have mainly seen short code examples in the tutorials that
% demonstrate individual concepts. In practice, however, you will write longer
% scripts that perform several steps in sequence: loading data, processing,
% analyzing, and saving results.
%
% In this tutorial, you will learn how to structure such scripts well so that
% they:
% - are traceable (you still understand what the code does after weeks)
% - are repeatable (you can run the analysis again later)
% - are extensible (you can easily add new subjects or conditions)
%
% These tutorials are designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how good code is
% structured. You will have many opportunities to apply what you've learned
% later in the block course.

%% 1. Why clean scripts are important
% Imagine you performed an analysis three months ago and now want to repeat or
% extend it. If your code is unclear, you will have difficulty understanding
% exactly what you did.
%
% Typical problems with poorly structured code:
%
% - "Click analysis" only via GUIs: You did everything by mouse click, but
%   there's no record of which steps you performed
% - Copy-paste of code: You copied the same code block 10 times and changed
%   it slightly each time – if you find an error, you have to correct it 10
%   times
% - Unclear file names and folder structures: You no longer know which file
%   contains which version of the data
%
% Good code avoids these problems by:
%
% - documenting all steps (with comments)
% - outsourcing repeatable operations into loops or functions
% - having a clear structure (parameters at the beginning, then processing,
%   then saving)

%% 2. Structure of analysis scripts
% A typical analysis script should have the following sections:
%
% 1. **Configuration / Parameters**: All important values are defined at the
%    beginning (e.g., which subjects, which conditions, which time windows)
% 
% 2. **Set paths**: Where are the data? Where should results be saved?
% 
% 3. **Load data**: Data are loaded (often in a loop over subjects)
% 
% 4. **Preprocessing**: Data are cleaned, filtered, etc.
% 
% 5. **Analysis**: The actual analysis is performed
% 
% 6. **Save results**: Results are saved (as MAT files, tables, plots, etc.)

%% 2.1 Example: Basic structure
% Here you see an example of the basic structure of an analysis script:

% 1. Configuration / Parameters

project_name = "EEG_Blockkurs";
subjects     = 2:4;   % Example: VP 2–4
conditions   = ["congruent","incongruent"];

% 2. Set paths (adjust path if necessary)
path_data    = fullfile("Praxis","data","preprocessed_data");
path_results = fullfile("Ergebnisse", project_name);

% 3. Create folder if it doesn't exist
if ~exist(path_results, "dir")
    mkdir(path_results);
end

% The function `fullfile` creates paths that work on every operating system
% (Windows uses backslashes, Mac/Linux use forward slashes). `fullfile` does
% this automatically correctly.
%
% The function `exist` checks whether something exists. `"dir"` means that we
% check whether it is a folder (directory). If the folder doesn't exist, it
% is created with `mkdir`.
%
% IMPORTANT NOTE: It's a good idea to define all parameters at the beginning
% of the script. If you want to change something later (e.g., analyze other
% subjects), you only need to change one line, not search through the entire
% code.

%% 3. Loops over subjects and conditions
% Often you want to perform the same analysis steps for many participants and
% conditions. Instead of writing the code for each VP and each condition
% individually, you use loops.

%% 3.1 Loop over subjects
% Here you see how to iterate over several subjects:

for s = 1:length(subjects)
    subj_id = subjects(s);
    fprintf("Processing subject %d ...\n", subj_id);
    
    % Example filename: "gip_sub-00X.mat"
    filename = sprintf("gip_sub-%03d.mat", subj_id);
    fullpath = fullfile(path_data, filename);
    
    if ~isfile(fullpath)
        warning("File %s not found, skipping.", fullpath);
        continue;
    end
    
    % Here the actual analysis steps would follow:
    % - Load data
    % - Preprocessing
    % - Time-frequency analyses
    % - etc.
    
    % Save results per subject (example, commented out):
    % save(fullfile(path_results, sprintf('Result_VP_%03d.mat', subj_id)), ...
    %      'EEG', '-v7.3');
end

% The function `sprintf` formats text similarly to `fprintf`, but returns a
% string instead of outputting it. `%03d` means: an integer with at least 3
% digits, padding with leading zeros (e.g., 002 instead of 2).
%
% `isfile` checks whether a file exists. If the file is not found, `continue`
% continues the loop to the next iteration without executing the rest of the
% code. This prevents errors when a file is missing.
%
% IMPORTANT NOTE: The variable `s` is the index in the array `subjects`, not
% the subject ID itself! `subjects(s)` gives you the actual subject ID
% (e.g., 2, 3, or 4). This is important when your subject IDs don't start
% consecutively at 1.

%% 3.2 Nested loops: Subjects and conditions
% Often you want to iterate over various conditions for each participant as
% well. You do this with nested loops:

for s = 1:length(subjects)
    subj_id = subjects(s);
    
    for b = 1:length(conditions)
        cond = conditions(b);
        fprintf("Subject %d – Condition %s\n", subj_id, cond);
        
        % Here: Select trials for this condition,
        % analyze ERP or time-frequency, etc.
    end
end

% The outer loop iterates over subjects, the inner loop over conditions. This
% means that for each subject, all conditions are processed before switching
% to the next subject.
%
% IMPORTANT NOTE: Nested loops can quickly become complex. Make sure that
% variable names are clear (`s` for subject index, `b` for condition index)
% and that you don't accidentally use the wrong variable.

EXCURSUS Loops vs. vectorization: In MATLAB, there are often two ways to
achieve something: with loops or with vectorized operations. Vectorized
operations are often faster, but loops are sometimes clearer and easier to
understand. For beginners, loops are usually the better way because they
explicitly show what happens. Later you can learn when vectorization makes
sense.

%% 4. Writing functions
% If you use the same code block multiple times, you should outsource it into
% a function. Functions make your code:
% - shorter (you write the code only once)
% - clearer (the function name says what is done)
% - easier to test (you can test the function in isolation)
% - easier to correct (if you find an error, you only have to correct it once)

%% 4.1 Simple function
% A function is a separate file with the name of the function. Example: You
% create a file `calculate_mean.m` with the following content:
%
% function m = calculate_mean(x)
%     % CALCULATE_MEAN – returns the mean of a vector
%     %
%     % Input:
%     %   x – numeric vector
%     %
%     % Output:
%     %   m – mean of x
%     m = mean(x);
% end
%
% In your script, you can then simply call the function:

data = [1 2 3 4 5];
m = mean(data);  % You could also use mean() directly, but this is an example

% IMPORTANT NOTE: The filename must exactly match the function name! The
% function `calculate_mean` must be in the file `calculate_mean.m`. MATLAB
% then finds the function automatically if it's in the current folder or in
% the MATLAB path.

%% 4.2 Function with multiple outputs
% Functions can also have multiple outputs. Example: A function that
% calculates mean AND standard deviation.
%
% function [m, s] = describe_data(x)
%     % DESCRIBE_DATA – returns mean and standard deviation
%     %
%     % Input:
%     %   x – numeric vector
%     %
%     % Output:
%     %   m – mean of x
%     %   s – standard deviation of x
%     m = mean(x);
%     s = std(x);
% end
%
% Call:

data = [1 2 3 4 5];
[m, s] = [mean(data), std(data)];  % Example, you could also call the function

% If you only need the mean, you can also request only one output:
% m = describe_data(data);  % Only mean is returned

%% 4.3 Function for a preprocessing step
% Functions are particularly useful for recurring steps, e.g., a filter step
% that you perform for multiple subjects.
%
% Example (pseudocode, not executable):
%
% function EEG_out = my_highpass_filter(EEG_in, f_cutoff)
%     % MY_HIGHPASS_FILTER – filters EEG data with a high-pass filter
%     %
%     % Input:
%     %   EEG_in   – EEG structure (input EEG structure)
%     %   f_cutoff – cutoff frequency in Hz (cutoff frequency)
%     %
%     % Output:
%     %   EEG_out  – filtered EEG structure (filtered EEG structure)
%     %
%     % Here you could use, e.g., pop_eegfiltnew from EEGLAB:
%     % EEG_out = pop_eegfiltnew(EEG_in, f_cutoff, []);
%     %
%     % For this example, we leave the content empty.
%     EEG_out = EEG_in; % Placeholder
% end
%
% IMPORTANT NOTE: Functions should be well documented. The comment directly
% under the function line (starting with `%`) is displayed by MATLAB as help
% text when you type `help functionname`. Always describe what the function
% does, what inputs it expects, and what outputs it provides.

EXCURSUS Local vs. global variables: Variables that you define within a
function are "local" – they only exist within the function and are not saved
in the workspace. This is usually good because it prevents functions from
accidentally overwriting variables that you use in your main script. If you
really want to use a variable from the workspace in a function, you can pass
it as input.

%% 5. Mini-project: Small analysis pipeline
% Now we combine everything we've learned and create a small analysis
% pipeline. This is a simplified example of what you will do later in the
% block course.

%% 5.1 Example code skeleton
% Here you see the structure of a typical pipeline:

% Define parameters
subjects     = 2:4;
conditions   = ["A","B"];
time_window  = [0.3 0.6];   % 300–600 ms
freq_band    = [8 12];      % 8–12 Hz (e.g., Alpha)

% Initialize result storage
Results = [];

for s = 1:length(subjects)
    subj_id = subjects(s);
    
    % --- Load data (pseudocode) ---
    % filename = sprintf("gip_sub-%03d.mat", subj_id);
    % data = load(fullfile(path_data, filename));
    % EEG = data.EEG;
    
    for b = 1:length(conditions)
        cond = conditions(b);
        
        % --- Select trials for this condition (pseudocode) ---
        % EEG_cond = select_condition(EEG, cond);
        
        % --- Calculate metric (pseudocode) ---
        % metric = calculate_metric(EEG_cond, time_window, freq_band);
        metric = rand();  % Placeholder for this example
        
        % Add result to table
        Results = [Results; ...
            table(subj_id, cond, metric, ...
            'VariableNames', {'VP','Condition','Metric'})];
    end
end

Results

% This pipeline shows the typical structure:
% 1. Parameters are defined at the beginning
% 2. A result storage is initialized (here an empty table)
% 3. Nested loops iterate over subjects and conditions
% 4. For each combination, a metric is calculated
% 5. Results are stored in a table
%
% IMPORTANT NOTE: The initialization of `Results` as an empty table is
% important. If you try to concatenate a table that doesn't exist yet, you
% get an error. You could also use `Results = []` and then add the first row
% differently, but the table is clearer.

%% 5.2 Tips for good pipeline structure
% Here are some tips that help you write good pipelines:
%
% 1. **Comment important steps**: Not every line needs to be commented, but
%    complex or important steps should be explained.
%
% 2. **Use meaningful variable names**: `subj_id` is better than `s`,
%    `condition` is better than `b`. (But in loops, short names like `s` and
%    `b` are also okay if the context is clear.)
%
% 3. **Test with few subjects first**: Before you apply the pipeline to all
%    subjects, test it with one or two subjects. This saves time if you find
%    an error.
%
% 4. **Save intermediate results**: If a calculation takes a long time, save
%    the result so you don't have to recalculate it if something goes wrong.
%
% 5. **Check for errors**: Use `isfile`, `exist`, or `try-catch` to catch
%    errors before they crash the entire script.

%% 6. Error handling
% When working with many files or complex analyses, errors can occur. Good
% error handling ensures that your script doesn't completely crash when
% something goes wrong.

%% 6.1 try-catch for robust scripts
% The `try-catch` structure allows you to catch errors and react to them
% without the entire script stopping:

% Example: Try to load data, catch errors
% for s = 1:length(subjects)
%     subj_id = subjects(s);
%     filename = sprintf("gip_sub-%03d.mat", subj_id);
%     fullpath = fullfile(path_data, filename);
%     
%     try
%         load(fullpath);
%         fprintf("Subject %d loaded successfully.\n", subj_id);
%         % Here you would perform the analysis
%     catch ME
%         warning("Error loading subject %d: %s", subj_id, ME.message);
%         continue;  % Skip this subject and go to the next
%     end
% end

% The `try` section contains the code that might fail. If an error occurs, the
% `catch` section is executed. `ME` (MException) contains information about the
% error, e.g., `ME.message` for the error message.
%
% IMPORTANT NOTE: `try-catch` should be used sparingly. It's better to avoid
% errors (e.g., check with `isfile` whether a file exists) than to catch
% them. But for unpredictable errors (e.g., corrupted files), `try-catch` is
% very useful.

%% 6.2 warning vs. error
% MATLAB offers two types of messages:
% - `warning`: Outputs a warning, but the script continues
% - `error`: Stops the script with an error message

% Example: Warning for missing files
% if ~isfile(fullpath)
%     warning("File %s not found, skipping.", fullpath);
%     continue;
% end

% Example: Error for critical errors
% if isempty(EEG.data)
%     error("EEG data is empty! Analysis cannot be performed.");
% end

% Use `warning` for problems that are not critical (e.g., missing files that
% can be skipped). Use `error` for critical problems that make the analysis
% impossible (e.g., empty data).

%% 7. Debugging tips
% If your code doesn't work, you need to find out why. Here are some useful
% techniques:

%% 7.1 Outputs with disp and fprintf
% The simplest method is to output intermediate values:

% Example: Output during a loop
% for s = 1:length(subjects)
%     subj_id = subjects(s);
%     fprintf("Processing subject %d ...\n", subj_id);
%     
%     % Here you would perform the analysis
%     % If something goes wrong, you see at which subject it happened
% end

% `fprintf` is more flexible than `disp` because you can create formatted
% outputs. `%d` stands for an integer, `%s` for text, `\n` for a line break.

%% 7.2 Timing with tic and toc
% If your code is slow, you might want to know how long certain parts take:

% tic;  % Start timer
% % Here comes your code that takes a long time
% % e.g., a loop over all subjects
% for s = 1:length(subjects)
%     % Perform analysis
% end
% elapsed_time = toc;  % Stop timer and save time
% fprintf("Analysis took %.2f seconds.\n", elapsed_time);

% `tic` starts a timer, `toc` stops it and returns the elapsed time. This
% helps you identify which parts of your code are slow.

%% 7.3 Inspecting workspace
% If something doesn't work, look at the variables in the workspace:

% size(EEG.data)      % Check dimensions
% class(EEG.data)     % Check data type
% isempty(EEG.data)   % Check if empty
% unique([EEG.event.type])  % See unique event types

% These commands help you understand what's in your variables and why
% something doesn't work.

%% Summary
% In this tutorial, you have learned:
%
% 1. **Why clean scripts are important**: They are traceable, repeatable, and
%    extensible.
%
% 2. **Structure of analysis scripts**: Parameters at the beginning, then
%    processing, then saving.
%
% 3. **Loops over subjects and conditions**: Avoid copy-paste and make code
%    clearer.
%
% 4. **Writing functions**: Make code shorter, clearer, and easier to test.
%
% 5. **Pipeline structure**: How you combine everything into a complete
%    analysis pipeline.
%
% These principles you will use frequently later in the block course,
% especially when working with real EEG data. Good code saves you time and
% makes your analyses reproducible.
