%% Blockkurs_Auswertung_Quiz.m
% Visualization of OLAT quiz results (Neurophysiology Block Course).
% Reads Excel exports from the quiz folder, generates per-subject and
% grand average figures showing per-item scores as percentage correct
% with raw score annotations.

clear; close all; clc;

%% Paths
dataPath = '/Users/Arne/Dropbox/AA_Teaching/Blockkurs_Auswertung_neurophysiologische_Experimente/FS_2026/Quiz';
figPath  = dataPath;

%% Configuration
quizI_maxScores = [3, 3, 6, 3, 3];
quizLabels = {'Quiz I', 'Quiz II', 'Quiz III', 'Quiz IV'};
barColor    = [0.30 0.55 0.75];
barColorAvg = [0.25 0.50 0.70];

%% Find Excel files
files = dir(fullfile(dataPath, '*.xlsx'));
if isempty(files)
    error('No .xlsx files found in %s', dataPath);
end

%% Initialize quiz data structure
for q = 1:4
    quizData(q).quizNum = [];
end

%% Read data from each file
for f = 1:length(files)
    fname = files(f).name;
    fpath = fullfile(dataPath, fname);

    if contains(fname, 'Quiz_IV')
        qNum = 4;
    elseif contains(fname, 'Quiz_III')
        qNum = 3;
    elseif contains(fname, 'Quiz_II')
        qNum = 2;
    elseif contains(fname, 'Quiz_I')
        qNum = 1;
    else
        warning('Skipping file (no quiz number found): %s', fname);
        continue;
    end

    fprintf('Reading %s -> %s\n', fname, quizLabels{qNum});

    raw = readcell(fpath, 'Sheet', 'Coverage results');
    [nRows, nCols] = size(raw);
    nItems = nCols - 6;

    % Item names from row 2 (columns 7 onwards)
    itemNames = cell(1, nItems);
    for c = 1:nItems
        val = raw{2, 6 + c};
        if ismissing(val)
            itemNames{c} = sprintf('Item %d', c);
        else
            itemNames{c} = char(string(val));
        end
    end

    % Shorten: "Frage 1a: Topic" -> "1a: Topic"
    shortNames = cell(1, nItems);
    for i = 1:nItems
        tok = regexp(itemNames{i}, '^Frage\s+(.+)$', 'tokens');
        if ~isempty(tok)
            shortNames{i} = tok{1}{1};
        else
            shortNames{i} = itemNames{i};
        end
    end

    % Subject data from rows 5 onwards
    nSubjects = nRows - 4;
    firstNames = cell(nSubjects, 1);
    lastNames  = cell(nSubjects, 1);
    usernames  = cell(nSubjects, 1);
    scores     = NaN(nSubjects, nItems);

    for s = 1:nSubjects
        r = s + 4;
        fullFirst = char(string(raw{r, 2}));
        % Use only first first-name for people with multiple first names
        nameParts = strsplit(strtrim(fullFirst), ' ');
        firstNames{s} = nameParts{1};
        lastNames{s}  = char(string(raw{r, 3}));
        usernames{s}  = char(string(raw{r, 4}));
        for i = 1:nItems
            val = raw{r, 6 + i};
            if ~ismissing(val) && isnumeric(val)
                scores(s, i) = val;
            elseif ~ismissing(val) && (ischar(val) || isstring(val))
                scores(s, i) = str2double(val);
            end
        end
    end

    % Max scores per item
    if qNum == 1
        maxScores = quizI_maxScores;
    else
        maxScores = ones(1, nItems);
    end

    % Store
    quizData(qNum).quizNum    = qNum;
    quizData(qNum).itemNames  = shortNames;
    quizData(qNum).scores     = scores;
    quizData(qNum).maxScores  = maxScores;
    quizData(qNum).pctScores  = (scores ./ maxScores) * 100;
    quizData(qNum).firstNames = firstNames;
    quizData(qNum).lastNames  = lastNames;
    quizData(qNum).usernames  = usernames;
end

%% Determine available quizzes
availableQuizzes = [];
for q = 1:4
    if ~isempty(quizData(q).quizNum)
        availableQuizzes(end+1) = q; %#ok<AGROW>
    end
end
fprintf('Available: %s\n', strjoin(quizLabels(availableQuizzes), ', '));

%% Collect unique subjects across quizzes (matched by username)
allUsernames  = {};
allFirstNames = {};
allLastNames  = {};
for q = availableQuizzes
    for s = 1:length(quizData(q).usernames)
        if ~ismember(quizData(q).usernames{s}, allUsernames)
            allUsernames{end+1}  = quizData(q).usernames{s}; %#ok<AGROW>
            allFirstNames{end+1} = quizData(q).firstNames{s}; %#ok<AGROW>
            allLastNames{end+1}  = quizData(q).lastNames{s};  %#ok<AGROW>
        end
    end
end
nAllSubjects = length(allUsernames);
fprintf('Subjects: %d\n\n', nAllSubjects);

%% --- Individual Subject Figures ---
for s = 1:nAllSubjects
    fig = figure('Position', [0 0 1512 982], 'Visible', 'off');
    sgtitle(sprintf('%s %s', allFirstNames{s}, allLastNames{s}), ...
        'FontSize', 16, 'FontWeight', 'bold');

    for q = availableQuizzes
        ax = subplot(2, 2, q);
        nItems = length(quizData(q).itemNames);

        sIdx = find(strcmp(quizData(q).usernames, allUsernames{s}), 1);
        if ~isempty(sIdx)
            pct  = quizData(q).pctScores(sIdx, :);
            rawV = quizData(q).scores(sIdx, :);
        else
            pct  = NaN(1, nItems);
            rawV = NaN(1, nItems);
        end

        bar(1:nItems, pct, 0.6, 'FaceColor', barColor, 'EdgeColor', 'none');
        hold on;

        % Annotate raw scores above bars
        for i = 1:nItems
            if ~isnan(rawV(i))
                if rawV(i) == round(rawV(i))
                    lbl = sprintf('%d', rawV(i));
                else
                    lbl = sprintf('%.1f', rawV(i));
                end
                text(i, pct(i) + 3, lbl, 'HorizontalAlignment', 'center', ...
                    'FontSize', 9, 'Color', [0.3 0.3 0.3]);
            end
        end

        yline(50, '--', 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);
        ylim([0 115]);
        ylabel('Score (%)');
        
        % Title with total score and percentage
        totalRaw = sum(rawV, 'omitnan');
        totalMax = sum(quizData(q).maxScores);
        totalPct = round((totalRaw / totalMax) * 100);
        if totalRaw == round(totalRaw)
            title(sprintf('%s (%d/%d, %d%%)', quizLabels{q}, totalRaw, totalMax, totalPct), 'FontSize', 12);
        else
            title(sprintf('%s (%.1f/%d, %d%%)', quizLabels{q}, totalRaw, totalMax, totalPct), 'FontSize', 12);
        end
        
        xticks(1:nItems);
        xticklabels(quizData(q).itemNames);
        xtickangle(45);
        ax.Position(2) = ax.Position(2) + 0.05;
        ax.Position(4) = ax.Position(4) - 0.05;
        set(ax, 'FontSize', 10, 'Box', 'off');
        hold off;
    end

    figName = sprintf('Quiz_%s_%s.png', allFirstNames{s}, allLastNames{s});
    exportgraphics(fig, fullfile(figPath, figName), 'Resolution', 300);
    close(fig);
    fprintf('Saved: %s\n', figName);
end

%% --- Grand Average Figure ---
fig = figure('Position', [0 0 1512 982], 'Visible', 'off');
sgtitle('Grand Average', 'FontSize', 16, 'FontWeight', 'bold');

for q = availableQuizzes
    ax = subplot(2, 2, q);
    nItems = length(quizData(q).itemNames);

    pctAll  = quizData(q).pctScores;
    meanPct = mean(pctAll, 1, 'omitnan');
    sdPct   = std(pctAll, 0, 1, 'omitnan');

    bar(1:nItems, meanPct, 0.6, 'FaceColor', barColorAvg, 'EdgeColor', 'none');
    hold on;
    errorbar(1:nItems, meanPct, sdPct, 'k.', 'LineWidth', 1.5, 'CapSize', 10);
    yline(50, '--', 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);

    ylim([0 115]);
    ylabel('Score (%)');
    
    % Title with total score and percentage (mean across subjects)
    rawAll = quizData(q).scores;
    totalMax = sum(quizData(q).maxScores);
    meanTotal = mean(sum(rawAll, 2, 'omitnan'), 'omitnan');
    meanTotalPct = round((meanTotal / totalMax) * 100);
    title(sprintf('%s (N = %d, %.1f/%d, %d%%)', quizLabels{q}, size(pctAll, 1), ...
        meanTotal, totalMax, meanTotalPct), 'FontSize', 12);
    
    xticks(1:nItems);
    xticklabels(quizData(q).itemNames);
    xtickangle(45);
    ax.Position(2) = ax.Position(2) + 0.05;
    ax.Position(4) = ax.Position(4) - 0.05;
    set(ax, 'FontSize', 10, 'Box', 'off');
    hold off;
end

exportgraphics(fig, fullfile(figPath, 'Quiz_GrandAverage.png'), 'Resolution', 300);
close(fig);
fprintf('Saved: Quiz_GrandAverage.png\n');

fprintf('\nDone.\n');
