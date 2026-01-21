%% Tutorial 8 – Data Export and Storage
% This optional tutorial shows you how to save and export results from your
% EEG analyses, both for further processing in other programs (e.g., R,
% Python) and for publications.
%
% Contents:
% 
% - 0. Introduction
% - 1. Exporting tables as CSV/TXT
%   - 1.1 Saving tables as CSV
%   - 1.2 Saving tables as TXT
%   - 1.3 Saving tables with additional options
% - 2. Saving plots
%   - 2.1 Saving plots as PNG
%   - 2.2 High-resolution plots for publications
%   - 2.3 Saving plots as PDF
%   - 2.4 Saving plots with specific dimensions
%   - 2.5 Saving multiple plots
% - 3. Saving data as MAT files
%   - 3.1 Simple saving
%   - 3.2 Saving structures
%   - 3.3 Compressed saving (v7.3 format)
% - 4. BIDS format: Structure for organized data storage
%   - 4.1 What is BIDS?
%   - 4.2 Why use BIDS?
%   - 4.3 Creating a simple BIDS-like structure
%   - 4.4 Naming files according to BIDS convention
%   - 4.5 Storing metadata in JSON
%   - 4.6 Creating participants.tsv
% - 5. Best practices for data storage
%   - 5.1 Organized folder structure
%   - 5.2 Consistent file names
%   - 5.3 Documentation

%% 0. Introduction
% After you have performed your EEG analyses, you often want to save or
% export the results:
% - **For further analyses**: e.g., in R or Python for statistical tests
% - **For publications**: high-resolution plots for papers or presentations
% - **For reproducibility**: Save intermediate results so you don't have to
%   recalculate them later
%
% In this tutorial, you will learn various methods for saving and exporting
% data and results.
%
% These tutorials are designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how data export
% works. You will have many opportunities to apply what you've learned later
% in the block course.

%% 1. Exporting tables as CSV/TXT
% Tables are ideal for saving results that you want to use later in other
% programs (e.g., R, Python, Excel).

%% 1.1 Saving tables as CSV
% CSV (Comma-Separated Values) is a universal format that can be read by
% almost all programs:
%
% Example: Create and save a table with results
% vp_id = [1; 2; 3; 4];
% condition = ["A"; "A"; "B"; "B"];
% mean_rt = [500; 520; 540; 560];
% 
% T = table(vp_id, condition, mean_rt, ...
%     'VariableNames', {'VP','Condition','Mean_RT'});
% 
% % Save as CSV
% writetable(T, 'results.csv');
%
% The function `writetable` saves a table as a CSV file. The file is saved
% in the current folder (or you specify a complete path).
%
% You can then open the file in R or Python:
% - R: `read.csv("results.csv")`
% - Python: `pandas.read_csv("results.csv")`
% - Excel: simply open

%% 1.2 Saving tables as TXT
% You can also save tables as TXT files, with various delimiters:
%
% Example: As TXT with tab as delimiter
% writetable(T, 'results.txt', 'Delimiter', '\t');
%
% The option `'Delimiter', '\t'` uses tab as delimiter instead of comma.
% This is sometimes useful when your data contains commas.
%
% Further options:
% - `'Delimiter', ','`: Comma (standard for CSV)
% - `'Delimiter', '\t'`: Tab
% - `'Delimiter', ';'`: Semicolon (sometimes used in Excel)

%% 1.3 Saving tables with additional options
% `writetable` has many options to customize the output:
%
% Example: Save without row names
% writetable(T, 'results.csv', 'WriteRowNames', false);
%
% Example: With specific encoding (for special characters)
% writetable(T, 'results.csv', 'Encoding', 'UTF-8');
%
% IMPORTANT NOTE: If your data contains special characters (e.g., umlauts),
% make sure the encoding is correct. `'UTF-8'` is usually a good choice.

%% 2. Saving plots
% Plots for publications often need to be high-resolution and saved in
% specific formats.

%% 2.1 Saving plots as PNG
% PNG (Portable Network Graphics) is a good format for plots with many
% details:
%
% Example: Create plot and save as PNG
% figure;
% plot(EEGC1.times, ERP1(channel_index, :), 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% title('ERP')
% 
% % Save as PNG
% print('erp_plot.png', '-dpng');
%
% The function `print` saves the current figure. `'-dpng'` specifies the
% format (PNG). The file is saved in the current folder.

%% 2.2 High-resolution plots for publications
% For publications, you often need high-resolution plots. You can specify
% the resolution with the option `'-r'` (resolution):
%
% Example: High-resolution plot (300 DPI, standard for publications)
% print('erp_plot_highres.png', '-dpng', '-r300');
%
% The resolution is specified in DPI (dots per inch):
% - 150 DPI: For screen presentations
% - 300 DPI: Standard for publications (journals)
% - 600 DPI: Very high-resolution (for very detailed plots)
%
% You can also adjust the size of the figure before saving it:
%
% figure('Position', [100, 100, 800, 600]);  % Width × height in pixels
% plot(EEGC1.times, ERP1(channel_index, :), 'LineWidth', 2)
% print('erp_plot_customsize.png', '-dpng', '-r300');
%
% IMPORTANT NOTE: Larger figures need more storage space. For publications,
% usually 800–1200 pixels width and 300 DPI are sufficient.

%% 2.3 Saving plots as PDF
% PDF (Portable Document Format) is a vector-based format that is well
% suited for publications because it can be scaled without quality loss:
%
% Example: Save plot as PDF
% figure;
% plot(EEGC1.times, ERP1(channel_index, :), 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% print('erp_plot.pdf', '-dpdf');
%
% PDFs are particularly useful when journals prefer PDFs or when you want
% to edit the plots later (e.g., in Adobe Illustrator).

%% 2.4 Saving plots with specific dimensions
% Often you want to save plots in specific dimensions (e.g., for a specific
% column width in a paper):
%
% Example: Plot with specific dimensions (in cm)
% figure('Units', 'centimeters', 'Position', [10, 10, 12, 8]);
% plot(EEGC1.times, ERP1(channel_index, :), 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% print('erp_plot_cm.pdf', '-dpdf', '-r300');
%
% Here the figure size is specified in centimeters (12 cm wide, 8 cm high).
% This is useful when you know exactly what size you need (e.g., for a column
% width of 8.5 cm in a paper).

%% 2.5 Saving multiple plots
% If you have multiple plots, you might want to save them all:
%
% Example: Save all open figures
% figures = findall(0, 'Type', 'figure');  % Find all open figures
% for i = 1:length(figures)
%     figure(figures(i));  % Activate this figure
%     filename = sprintf('plot_%02d.png', i);
%     print(filename, '-dpng', '-r300');
% end
%
% Or you can save each figure individually after creating it:
%
% figure(1);
% plot(EEGC1.times, ERP1(channel_index, :))
% print('erp_condition1.png', '-dpng', '-r300');
% 
% figure(2);
% plot(EEGC1.times, ERP2(channel_index, :))
% print('erp_condition2.png', '-dpng', '-r300');

%% 3. Saving data as MAT files
% MAT files are MATLAB's native format and are well suited for saving
% intermediate results or complete datasets.

%% 3.1 Simple saving
% The simplest method is to save variables directly:
%
% Example: Save individual variables
% save('results.mat', 'ERP1', 'ERP2', 'ERP3');
%
% This saves the variables `ERP1`, `ERP2`, and `ERP3` in the file
% `results.mat`. You can load them later with `load('results.mat')`.

%% 3.2 Saving structures
% Often you want to save several related variables. Structures are ideal
% for this:
%
% Example: Save results in a structure
% results.ERP1 = ERP1;
% results.ERP2 = ERP2;
% results.ERP3 = ERP3;
% results.times = EEGC1.times;
% results.channel = channel_index;
% 
% save('results_structure.mat', 'results');
%
% This way you have all results organized in a structure. When you load the
% file later, you have everything in a clear structure.

%% 3.3 Compressed saving (v7.3 format)
% For large files (e.g., complete EEG datasets), you should use the v7.3
% format, which is compressed and more efficient:
%
% Example: Save compressed
% save('eeg_data.mat', 'EEG', '-v7.3');
%
% The `'-v7.3'` format supports:
% - Compression (smaller files)
% - Files larger than 2 GB
% - Partial loading (load only specific variables)
%
% IMPORTANT NOTE: The v7.3 format is slower for saving and loading, but the
% files are smaller. For small files, the standard format (v7) is sufficient.

%% 4. BIDS format: Structure for organized data storage
% BIDS (Brain Imaging Data Structure) is a standard for organizing
% neuroimaging data. It makes your data traceable and reproducible.

%% 4.1 What is BIDS?
% BIDS defines a clear folder structure and naming conventions for
% neuroimaging data. The structure looks approximately like this:
%
% ```
% dataset/
% ├── dataset_description.json
% ├── participants.tsv
% ├── sub-001/
% │   ├── ses-001/
% │   │   ├── eeg/
% │   │   │   ├── sub-001_ses-001_task-rest_eeg.set
% │   │   │   ├── sub-001_ses-001_task-rest_eeg.fdt
% │   │   │   └── sub-001_ses-001_task-rest_eeg.json
% │   │   └── beh/
% │   │       └── sub-001_ses-001_task-rest_beh.tsv
% │   └── sub-001_ses-002/
% └── sub-002/
% ```
%
% The most important principles:
% - **Hierarchical structure**: Subjects → Sessions → Modalities (e.g., EEG)
% - **Consistent naming conventions**: `sub-XXX_ses-XXX_task-XXX_eeg.set`
% - **Metadata in JSON**: Additional information in structured files

%% 4.2 Why use BIDS?
% BIDS offers several advantages:
% - **Reproducibility**: Others can easily understand your data structure
% - **Compatibility**: Many tools support BIDS (e.g., EEGLAB, MNE-Python)
% - **Metadata**: Important information is stored in a structured way
% - **Sharing**: Easier to share data with others

%% 4.3 Creating a simple BIDS-like structure
% Even if you don't need to be fully BIDS-compliant, you can use a similar
% structure:
%
% Example: Create BIDS-like folder structure
% project_name = "EEG_Blockkurs";
% base_dir = "BIDS_dataset";
% 
% % Create folder structure
% for sub = 2:11
%     subj_dir = fullfile(base_dir, sprintf("sub-%03d", sub), "eeg");
%     if ~exist(subj_dir, "dir")
%         mkdir(subj_dir);
%     end
% end
%
% This creates a structure like:
% ```
% BIDS_dataset/
% ├── sub-002/
% │   └── eeg/
% ├── sub-003/
% │   └── eeg/
% ...
% ```

%% 4.4 Naming files according to BIDS convention
% BIDS uses a specific naming convention:
%
% Example: Name files according to BIDS
% subj_id = 2;
% session = 1;
% task = "rest";
% 
% filename = sprintf("sub-%03d_ses-%02d_task-%s_eeg.set", ...
%     subj_id, session, task);
% 
% % Save file
% % pop_saveset(EEG, 'filename', filename, 'filepath', subj_dir);
%
% The naming convention is:
% - `sub-XXX`: Subject ID (3 digits, with leading zeros)
% - `ses-XXX`: Session (optional, if multiple sessions)
% - `task-XXX`: Task/condition
% - `modality`: Type of data (e.g., `eeg`, `meg`, `ieeg`)
% - `suffix`: File type (e.g., `eeg`, `events`, `channels`)

%% 4.5 Storing metadata in JSON
% BIDS uses JSON files for metadata. You can create these in MATLAB:
%
% Example: Create JSON metadata (simplified)
% metadata = struct();
% metadata.SamplingFrequency = EEG.srate;
% metadata.PowerLineFrequency = 50;  % 50 Hz in Europe, 60 Hz in USA
% metadata.SoftwareFilters = struct();
% metadata.SoftwareFilters.HighPass = struct('FilterType', 'Butterworth', ...
%     'HalfPowerFrequency', 1, 'FilterOrder', 4);
% 
% % Save as JSON (requires jsonencode, available from MATLAB R2016b)
% json_str = jsonencode(metadata);
% fid = fopen('eeg_metadata.json', 'w');
% fprintf(fid, '%s', json_str);
% fclose(fid);
%
% JSON (JavaScript Object Notation) is a text-based format for structured
% data. It is easily readable and supported by many programs.
%
% IMPORTANT NOTE: `jsonencode` is available from MATLAB R2016b. For older
% versions, you can use external functions or save the metadata as MAT files.

%% 4.6 Creating participants.tsv
% BIDS uses a `participants.tsv` file that contains information about all
% participants:
%
% Example: Create participants.tsv
% vp_ids = (2:11)';
% age = [23; 25; 22; 30; 28; 24; 26; 27; 29; 25];  % Example values
% sex = ["f"; "m"; "f"; "m"; "f"; "f"; "m"; "f"; "m"; "f"];
% 
% participants = table(vp_ids, age, sex, ...
%     'VariableNames', {'participant_id', 'age', 'sex'});
% 
% % Save as TSV
% writetable(participants, fullfile(base_dir, 'participants.tsv'), ...
%     'Delimiter', '\t', 'FileType', 'text');
%
% The `participants.tsv` file contains demographic information about all
% participants. This makes it easy to use this information later (e.g., for
% statistical analyses in R).

EXCURSUS Full BIDS compliance: For full BIDS compliance, there are many
further requirements (e.g., `dataset_description.json`, `channels.tsv`,
`events.tsv`, etc.). The EEGLAB BIDS tools can help create BIDS-compliant
datasets. For the block course, a simple BIDS-inspired structure is usually
sufficient to keep the data organized.

%% 5. Best practices for data storage
% Here are some tips for good data storage:

%% 5.1 Organized folder structure
% Use a clear folder structure:
%
% ```
% Project/
% ├── data/
% │   ├── raw_data/
% │   └── preprocessed_data/
% ├── scripts/
% ├── results/
% │   ├── erps/
% │   ├── plots/
% │   └── tables/
% └── figures/
% ```
%
% This makes it easy to find and organize data.

%% 5.2 Consistent file names
% Use consistent naming conventions:
%
% GOOD:
% - `erp_condition1_sub002.png`
% - `results_all_vps.csv`
% - `eeg_sub002_preprocessed.mat`
%
% BAD:
% - `plot1.png`
% - `results_final_v2.csv`
% - `data.mat`
%
% Consistent names make it easier to find files and understand what they
% contain.

%% 5.3 Documentation
% Document what is stored in the files:
%
% Example: Create README file
% fid = fopen('README_results.txt', 'w');
% fprintf(fid, 'Results from %s\n', datestr(now));
% fprintf(fid, 'ERP1: Condition 1 (familiar)\n');
% fprintf(fid, 'ERP2: Condition 2 (unfamiliar)\n');
% fprintf(fid, 'ERP3: Condition 3 (scrambled)\n');
% fprintf(fid, 'Time window: -200 to 800 ms\n');
% fprintf(fid, 'Baseline: -200 to 0 ms\n');
% fclose(fid);
%
% A README file explains what is stored in the files and how they were
% created. This is especially important when you want to use the data later
% or share it with others.

%% Summary
% In this tutorial, you have learned:
%
% 1. **Exporting tables**: How you save tables as CSV or TXT to use them in
%    other programs
%
% 2. **Saving plots**: How you save plots as PNG or PDF, with various
%    resolutions for publications
%
% 3. **MAT files**: How you save data as MAT files, both simply and
%    compressed (v7.3 format)
%
% 4. **BIDS format**: How you use a BIDS-inspired structure for organized
%    data storage
%
% 5. **Best practices**: Tips for good data storage and organization
%
% These methods help you organize and save your results, both for further
% processing and for publications and reproducibility.
