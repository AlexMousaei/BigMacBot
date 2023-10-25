
% Clear MATLAB
clear all;
close all;
clc

% % Close Open COM port Connections for arduino estop
% if ~isempty(instrfind)
%     fclose(instrfind);
%     delete(instrfind);
% end

% Declare Global Variables
global UR3Bot scaraBot qPath1 qPath2 Paths currentPath t currentStep patties;
global robotFigure;
robotFigure = figure; % Create the robot figure

%Initialise the Robots
initUR3Pos = transl(0, -0.1+1, 0.85);
UR3Bot = LinearUR3(initUR3Pos);
initScaraPos = transl(-1.55, 1.6, 0.85);
scaraBot = IRB_910sc(initScaraPos);

% Setup the Timer
% Create a timer to animate the robot
currentStep = 1;
t = timer('ExecutionMode', 'fixedSpacing', 'Period', 0.01, 'TimerFcn', @robotStep);

% Load the environment
wSpace = Workspace();
wSpace.DisplayEnvironment;

% Add in the burger patties
patties = Patty(1);

% Create the E-stopGui
eStopGUI();
personGUI();
% % Initialise the serial communication and pass the state manager
% s = serialSetup('COM7');

% Set Target Positions


offset = SE3(transl(0,0,0.01)*trotx(pi));
targetPos1 = patties.pattyInitialSE3Transform{1}*offset;
targetPos2 = patties.pattyFinalSE3Transform{1}*offset;

% Setup Waypoints
qStart = UR3Bot.model.getpos();
qPick1 = UR3Bot.model.ikcon(targetPos1, qStart);
qPlace1 = UR3Bot.model.ikcon(targetPos2, qPick1);
qPath1 = jtraj(qStart, qPick1, 150);
qPath2 = jtraj(qPick1, qPlace1, 150);
Paths = {qPath1, qPath2};
currentPath = 1;



input("Press enter to continue: ", 's');
start(t);





