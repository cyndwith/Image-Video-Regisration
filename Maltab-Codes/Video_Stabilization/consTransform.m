function [Transform] = consTransform(newTrajectory)
     Transform(3,1) = newTrajectory(1);
     Transform(3,2) = newTrajectory(3);
    theta = newTrajectory(3);
    Transform(1,1) = cos(theta);
    Transform(1,2) = sin(theta);
    Transform(2,1) = -sin(theta);
    Transform(2,2) = cos(theta);
    Transform(1,3) = 0;
    Transform(2,3) = 0;
    Transform(3,3) = 1;
    