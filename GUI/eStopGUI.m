function eStopGUI()
    global estopBtnHandle ResumebtnHandle
    % Create main figure for GUI
    mainFig = figure('Name', 'Control Panel', 'NumberTitle', 'off', 'Position', [100, 100, 700, 200], 'Color', [0.8 0.8 0.8]);

    % Button for "Press to Run"
    uicontrol('Style', 'pushbutton', 'String', 'Demo Laser Sensor', ...
        'Position', [5, 140, 175, 60], ...
        'Callback', @toggleStop, ...
        'FontSize', 10, ...
        'BackgroundColor', [0.2 0.6 0.2], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'person');

    % Button for "Delete Person"
    uicontrol('Style', 'pushbutton', 'String', 'Delete Person', ...
        'Position', [5, 100, 175, 40], ...  % Adjusted y position and height
        'Callback', @toggleStop, ...  % Replace this with an appropriate callback function if necessary
        'FontSize', 10, ...
        'BackgroundColor', [0.8 0.2 0.2], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'deletePerson');

    % Button for "Press to Run"
    uicontrol('Style', 'pushbutton', 'String', 'Place Object Near Robot', ...
        'Position', [5, 40, 175, 60], ...
        'Callback', @toggleStop, ...
        'FontSize', 10, ...
        'BackgroundColor', [0.2 0.6 0.2], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'forcedcollision');

    % Button for Deleting the object placed with the robots
    uicontrol('Style', 'pushbutton', 'String', 'Delete Object', ...
        'Position', [5, 0, 175, 40], ...  % Adjusted y position and height
        'Callback', @toggleStop, ...  % Replace this with an appropriate callback function if necessary
        'FontSize', 10, ...
        'BackgroundColor', [0.8 0.2 0.2], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'deleteObject');


    % Button for "E-Stop"
    estopBtnHandle = uicontrol('Style', 'pushbutton', 'String', 'E-Stop', ...
        'Position', [275, 50, 175, 100], ...
        'Callback', @toggleStop, ...
        'FontSize', 10, ...
        'BackgroundColor', [1, 0.5, 0], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'emergency');

    % Resume Button
    ResumebtnHandle = uicontrol('Style', 'pushbutton', 'String', 'Resume', ...
        'Position', [275+225, 50, 175, 100], ...
        'Callback', @toggleStop, ...
        'FontSize', 10, ...
        'BackgroundColor', [0.2 0.6 0.2], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'resume');

    uicontrol('Style', 'pushbutton', 'String', 'Teach', ...
        'Position', [200, 50, 50, 100], ...  
        'Callback', @initialiseTeach, ...
        'FontSize', 10, ...
        'BackgroundColor', [0.2 0.2 0.6], ...
        'ForegroundColor', [1 1 1], ...
        'Tag', 'initRobots');
end

% New callback function for initialising robots
function initialiseTeach(~, ~)
    global scaraBot UR3Bot
    % Assuming scaraBot and UR3Bot are available (define or pass them as needed)
    scaraApp = AdvancedTeachSCARA();
    scaraApp.initializeRobot(scaraBot);
    UR3App = AdvancedTeachUR3();
    UR3App.initializeRobot(UR3Bot);

    % Update the UI or display a message if necessary
    disp('Robots initialised successfully.');
end