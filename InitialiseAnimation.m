function InitialiseAnimation()
    global UR3Bot scaraBot Paths currentPath patties ...
           qScaraStart qUR3Start isSecondLoop verticesAtOrigin...
           burgerHandle;
    firstTime = true;
    if isSecondLoop == true || firstTime == true
        
        burgerPosition = [-1.15, 1.4, 0.93];
        burgerHandle = PlaceObject("burger.ply", burgerPosition);
        % Get the vertices of the gripper
        vertices1 = get(burgerHandle, 'Vertices');
        centroid = mean(vertices1, 1);
        % Move the gripper to the origin
        verticesAtOrigin = vertices1 - centroid;
        
        % Set Target Positions
        offset = SE3(transl(0,0,0)*trotx(-pi)); % Ensure an approach from the top
        targetPatty1 = patties.pattyInitialSE3Transform{1}*offset;
        targetPatty2 = patties.pattyInitialSE3Transform{2}*offset;
        targetPatty3 = patties.pattyInitialSE3Transform{3}*offset;
        targetPan = SE3(transl(-0.250, 1.418, 0.990))*offset;
        UR3waypoint1 = SE3(transl(-0.241, 1.355, 1.25))*offset;
        targetTray1 = SE3(transl(-0.825, 1.34, 0.972))*offset;
        scaraWaypoint1 = SE3(transl(-0.83, 1.3, 1.1))*offset;
        scaraWaypoint2 = SE3(transl(-1.2, 1.4, 1))*offset;
        scaraWaypoint3 = SE3(transl(-1.8, 0.95, 1))*offset;
        scaraTarget1 = SE3(transl(-0.827, 1.3, 0.98))*offset;
        scaraTarget2 = SE3(transl(-1.2, 1.4, 0.97))*offset;
        scaraTarget3 = SE3(transl(-1.8, 0.95, 1))*offset;
        
        % Setup Waypoints for UR3
        qUR3Guess1 = deg2rad([-0.07 -172 -55.4 -6.72 -24.9 89.5 6.41 6.41]); % Tray 1 q config UR3
        qUR3Guess2 = deg2rad([-0.54 -172 -33.1 2.88 -24.9 89.5 6.41 6.41]); % Waypoint 1 q config UR3
        qUR3Guess3 = deg2rad([-0.54 -172 -63.6 2.88 -24.9 89.5 6.41 6.41]); % Pan q config UR3
        qUR3Guess4 = deg2rad([-0.80 -135 -65.6 2.88 -24.9 89.5 6.41 6.41]); % Tray 2 q config UR3
        
        qScaraGuess1 = deg2rad([-52.8, -1.8, -0.13]); % Tray q config Scara
        qScaraGuess2 = deg2rad([-52.8, -1.8, 0]); % Waypoint 1 guess Scara
        qScaraGuess3 = deg2rad([26.4, -82.8, 0]); % Waypoint 2 guess Scara
        qScaraGuess4 = deg2rad([26.4, -82.8, -0.10]); % Place point on tray2
        qScaraGuess5 = deg2rad([-264, -1.8, 0]); % Waypoint 3 guess scara
        qScaraGuess6 = deg2rad([-264, -1.8, 1]); % Final place burger
        
        % Setup the Robot Paths
        qUR3Start = UR3Bot.model.getpos();
        qUR3Pick1 = UR3Bot.model.ikcon(targetPatty1, qUR3Guess1);
        qUR3WayPt1 = UR3Bot.model.ikcon(UR3waypoint1, qUR3Guess2);
        qUR3Place1 = UR3Bot.model.ikcon(targetPan, qUR3Guess3);
        qUR3Place2 = UR3Bot.model.ikcon(targetTray1, qUR3Guess4);
        qUR3Pick2 = UR3Bot.model.ikcon(targetPatty2, qUR3Guess1);
        
        qScaraStart = scaraBot.model.getpos();
        qScaraPick1 = scaraBot.model.ikcon(scaraTarget1, qScaraGuess1);
        qScaraWayPt1 = scaraBot.model.ikcon(scaraWaypoint1, qScaraGuess2);
        qScaraWayPt2 = scaraBot.model.ikcon(scaraWaypoint2, qScaraGuess3);
        qScaraPlace1 = scaraBot.model.ikcon(scaraTarget2, qScaraGuess4);
        qScaraWayPt3 = scaraBot.model.ikcon(scaraWaypoint3, qScaraGuess5);
        qScaraPlace2 = scaraBot.model.ikcon(scaraTarget3, qScaraGuess6);
        
        % UR3 Paths
        qPath1 = jtraj(qUR3Start, qUR3Pick1, 75);
        qPath2 = jtraj(qUR3Pick1, qUR3WayPt1, 75);
        qPath3 = jtraj(qUR3WayPt1, qUR3Place1, 75);
        qPath4 = jtraj(qUR3Place1, qUR3WayPt1, 75); % wait to cook here
        qPath5 = jtraj(qUR3WayPt1, qUR3Place1, 75);
        qPath6 = jtraj(qUR3Place1, qUR3WayPt1, 75);
        qPath7 = jtraj(qUR3WayPt1, qUR3Place2, 75);
        qPath8 = jtraj(qUR3Place2, qUR3Pick2, 75);
        
        % Scara Paths
        qPath9 = jtraj(qScaraStart, qScaraPick1, 75);
        qPath10 = jtraj(qScaraPick1, qScaraWayPt1, 75);
        qPath11 = jtraj(qScaraWayPt1, qScaraWayPt2, 75);
        qPath12 = jtraj(qScaraWayPt2, qScaraPlace1, 75);
        qPath13 = jtraj(qScaraPlace1, qScaraWayPt2, 75);
        qPath14 = jtraj(qScaraWayPt2, qScaraWayPt3, 75);
        qPath15 = jtraj(qScaraWayPt3, qScaraPlace2, 75);
        qPath16 = jtraj(qScaraPlace2, qScaraPick1, 75);
        
        Paths = {qPath1, qPath2, qPath3...
                ,qPath4, qPath5, qPath6...
                ,qPath7, qPath8, qPath9...
                ,qPath10, qPath11, qPath12...
                ,qPath13, qPath14, qPath15...
                ,qPath16};

        firstTime = false;
    else
    currentPath = 1;
    end