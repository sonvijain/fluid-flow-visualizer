% Fluid Flow Visualization 
clc; clear; 

% Define grid and base parameters
x = linspace(0, 10, 50); 
y = linspace(0, 10, 50); 
[X, Y] = meshgrid(x, y); 


disp('Choose a velocity field:');
disp('1. Vortex Field');
disp('2. Laminar Flow');
disp('3. Rotational Flow');
choice = input('Enter your choice (1/2/3): ');

switch choice
    case 1
        % Vortex Field
        U = -sin(pi * X) .* cos(pi * Y); 
        V = cos(pi * X) .* sin(pi * Y); 
        fieldName = 'Vortex Field';
    case 2
         % Laminar Flow (Linear velocity profile)
        U = ones(size(X));  % Constant X-direction velocity
        V = 0.1 * Y;        % Linear velocity increase with Y
        fieldName = 'Laminar Flow';
    case 3
        % Rotational Flow
        U = -Y; 
        V = X;  
        fieldName = 'Rotational Flow';
    otherwise
        error('Invalid choice. Please restart and select 1, 2, or 3.');
end


numParticles = 100; 
particlesX = 10 * rand(numParticles, 1); 
particlesY = 10 * rand(numParticles, 1); 


dt = 0.01; % Time step
numSteps = 500; % Number of animation steps


figure('Name', 'Fluid Flow Visualization');
hold on;
axis([0 10 0 10]);
title(['Fluid Flow: ', fieldName]);
xlabel('X-axis');
ylabel('Y-axis');

% Plot velocity vectors and streamlines
quiver(X, Y, U, V, 'b'); % Velocity vectors
startX = 0:0.5:10; % Starting points for streamlines
startY = 0:0.5:10;
streamline(X, Y, U, V, startX, startY); % Streamlines

% Initialize video writer
videoFileName = [fieldName, '_Simulation.mp4'];
videoWriter = VideoWriter(videoFileName, 'MPEG-4');
videoWriter.FrameRate = 30; 
open(videoWriter);

% Plot particle motion
for step = 1:numSteps
    % Interpolate velocity at particle positions
    particleU = interp2(X, Y, U, particlesX, particlesY, 'linear', 0);
    particleV = interp2(X, Y, V, particlesX, particlesY, 'linear', 0);

    % Update particle positions
    particlesX = particlesX + particleU * dt;
    particlesY = particlesY + particleV * dt;

    % Wrap particles around boundaries (periodicity)
    particlesX = mod(particlesX, 10);
    particlesY = mod(particlesY, 10);

    % Clear previous particles and replot
    scatter(particlesX, particlesY, 20, 'r', 'filled');
    pause(0.01);

    % Capture the frame for the video
    frame = getframe(gcf);
    writeVideo(videoWriter, frame);
end

close(videoWriter);
hold off;

disp(['Simulation complete! Video saved as ', videoFileName]);
