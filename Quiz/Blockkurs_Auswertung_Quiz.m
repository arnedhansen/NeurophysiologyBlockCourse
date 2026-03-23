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

%% Compute Swiss grades (0.25 precision): min points = 4.0, max points = 6.0
for q = availableQuizzes
    totalPoints = sum(quizData(q).scores, 2, 'omitnan');
    minPts = min(totalPoints);
    maxPts = max(totalPoints);
    if maxPts > minPts
        rawGrade = 4 + (totalPoints - minPts) / (maxPts - minPts) * 2;
    else
        rawGrade = repmat(5.0, size(totalPoints));
    end
    quizData(q).grades = round(rawGrade * 4) / 4;  % 0.25 precision
    quizData(q).totalPoints = totalPoints;
end

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

%% Precompute average quiz grade per subject (0.5 precision, worst grade dropped)
avgGrades = NaN(nAllSubjects, 1);
for s = 1:nAllSubjects
    grades = [];
    for q = availableQuizzes
        sIdx = find(strcmp(quizData(q).usernames, allUsernames{s}), 1);
        if ~isempty(sIdx)
            grades(end+1) = quizData(q).grades(sIdx); %#ok<AGROW>
        end
    end
    if length(grades) >= 2
        gradesSorted = sort(grades);
        avgGrades(s) = mean(gradesSorted(2:end));  % drop worst
    elseif length(grades) == 1
        avgGrades(s) = grades(1);
    end
    if ~isnan(avgGrades(s))
        avgGrades(s) = round(avgGrades(s) * 2) / 2;  % 0.5 precision
    end
end

%% --- Individual Subject Figures ---
for s = 1:nAllSubjects
    fig = figure('Position', [0 0 1512 982], 'Visible', 'off');
    if ~isnan(avgGrades(s))
        sgtitle(sprintf('%s %s (Ø Quiz: %.1f)', allFirstNames{s}, allLastNames{s}, avgGrades(s)), ...
            'FontSize', 16, 'FontWeight', 'bold');
    else
        sgtitle(sprintf('%s %s', allFirstNames{s}, allLastNames{s}), ...
            'FontSize', 16, 'FontWeight', 'bold');
    end

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
        
        % Title with total score, percentage, and Swiss grade
        totalRaw = sum(rawV, 'omitnan');
        totalMax = sum(quizData(q).maxScores);
        totalPct = round((totalRaw / totalMax) * 100);
        if ~isempty(sIdx)
            gradeStr = sprintf(', %.2f', quizData(q).grades(sIdx));
        else
            gradeStr = '';
        end
        if totalRaw == round(totalRaw)
            title(sprintf('%s (%d/%d, %d%%%s)', quizLabels{q}, totalRaw, totalMax, totalPct, gradeStr), 'FontSize', 12);
        else
            title(sprintf('%s (%.1f/%d, %d%%%s)', quizLabels{q}, totalRaw, totalMax, totalPct, gradeStr), 'FontSize', 12);
        end
        
        xticks(1:nItems);
        xticklabels(quizData(q).itemNames);
        xtickangle(45);
        ax.Position(2) = ax.Position(2) + 0.05;
        ax.Position(4) = ax.Position(4) - 0.05;
        set(ax, 'FontSize', 8, 'Box', 'off');
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

%% --- Quiz Grade Distributions ---
fig = figure('Position', [0 0 1512 982], 'Visible', 'off');
fig.Color = [0.98 0.98 0.98];
gradeVals = 4:0.25:6;        % bar centers (0.25 steps)
gradeClr   = [0.22 0.42 0.62];
gradeClrEnd = [0.18 0.48 0.52];

% Subplot
spIdx = [1 2 4 5];  % positions for Quiz I, II, III, IV
for i = 1:4
    ax = subplot(2, 3, spIdx(i));
    if ismember(i, availableQuizzes)
        g = quizData(i).grades;
        counts = arrayfun(@(v) sum(g == v), gradeVals);
        bar(gradeVals, counts, 0.85, 'FaceColor', gradeClr, 'EdgeColor', 'none', 'FaceAlpha', 0.92);
        xlim([3.75 6.25]);
        xticks(gradeVals);
        xticklabels(arrayfun(@(v) sprintf('%.2g', v), gradeVals, 'UniformOutput', false));
        xlabel('Swiss grade');
        ylabel('Count');
        meanQuiz = mean(g);
        title(sprintf('%s (Ø %.1f)', quizLabels{i}, meanQuiz), 'FontSize', 12, 'FontWeight', 'normal');
    else
        axis off;
        title(quizLabels{i}, 'FontSize', 12, 'FontWeight', 'normal');
    end
    set(ax, 'FontSize', 10, 'Box', 'off', 'XTickLabelRotation', 45, 'TickLength', [0.02 0.02]);
end

% End grade: centered in 3rd column, spans full height
ax = subplot(2, 3, [3 6]);
endGrades = avgGrades(~isnan(avgGrades));
if ~isempty(endGrades)
    counts = arrayfun(@(v) sum(endGrades == v), gradeVals);
    bar(gradeVals, counts, 0.85, 'FaceColor', gradeClrEnd, 'EdgeColor', 'none', 'FaceAlpha', 0.92);
    xlim([3.75 6.25]);
    xticks(gradeVals);
    xticklabels(arrayfun(@(v) sprintf('%.2g', v), gradeVals, 'UniformOutput', false));
    xlabel('Swiss grade');
    ylabel('Count');
else
    axis off;
end
if ~isempty(endGrades)
    title(sprintf('End grade (Ø %.1f)', mean(endGrades)), 'FontSize', 12, 'FontWeight', 'normal');
else
    title('End grade', 'FontSize', 12, 'FontWeight', 'normal');
end
set(ax, 'FontSize', 10, 'Box', 'off', 'XTickLabelRotation', 45, 'TickLength', [0.02 0.02]);

exportgraphics(fig, fullfile(figPath, 'Quiz_Grades.png'), 'Resolution', 300);
close(fig);
fprintf('Saved: Quiz_Grades.png\n');

fprintf('\nDone.\n');
