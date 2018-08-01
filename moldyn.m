% PARAMETERS
NATOM = 200;        % Number of atoms
kB = 0.8314;        % Boltzmann constant (amu,ps,A units)
SIGMA = 3.73;        % LJ size parameter (A)
EPSILON = 123.0472;	% LJ energy parameter (amu.A2.ps-2)
MASS = 16.0;        % Atoms mass (amu)
DT = 0.002;         % Integration step (ps)
DENS = 0.0168616;        % System density in atoms/A^3
LJCUT = 2.5*SIGMA;  % LJ Potential cutoff
TEM = 100.0;        % Temperature (K)
kT = kB*TEM;        % kB*T
EQSTEPS = 10000;    % Equilibration time steps
PRODSTEPS = 30000;  % Production time steps
IE = 1;             % Writing intervals - energies
ITAPE = 100;        % Writing intervals - positions
IANIMATE = 100;     % Animation interval

            			
% OPEN FILES TO STORE OUTPUT DATA
tapefile = fopen('TAPE.dat','w'); % STORES POSITIONS AND VELOCITIES EVERY ITAPE STEPS
moviefile = fopen('MOVIE.xyz','w'); % POSITIONS IN MOVIE FORMAT EVERY IANIMATE STEPS
energyfile = fopen('ENERGIES.dat','w'); % STORES ENERGIES EVERY IE STEPS
pressurefile = fopen('PRESSURE.dat','w'); % STORES PRESSURES EVERY IE STEPS

% CALCULATE LONG RANGE CORRECTIONS FOR ENERGY AND PRESSURE APRIORI
ELRC = (1.0/3.0)*(SIGMA/LJCUT)^9 - (SIGMA/LJCUT)^3;
ELRC = ELRC*(8.0/3.0)*NATOM*pi()*EPSILON*DENS*(SIGMA^3);
PLRC = (2.0/3.0)*(SIGMA/LJCUT)^9 - (SIGMA/LJCUT)^3;
PLRC = PLRC*(16.0/3.0)*pi()*EPSILON*DENS*DENS*(SIGMA^3);
	  	  	
% INITIALIZE THE POSITIONS AND VELOCITIES OF ATOMS
fprintf('STARTING INITIALIZATION \n')
fprintf('\n')
			
% THE POSITIONS ARE CHOSEN SUCH THAT THERE ARE NO MAJOR OVERLAPS OF ATOMS
% CALCULATE SIMULATION BOX LENGTH ACCORDING TO DENSITY AND NATOM
LSIMBOX = (NATOM/DENS)^(1.0/3.0);
LSIMBOX2 = LSIMBOX/2.0;
if LJCUT>LSIMBOX2
    fprintf('******** WARNING: LJCUT > L/2 ******** \n')
	fprintf('LJCUT = %5.3f, L/2 = %5.3f \n', LJCUT, LSIMBOX2)
	fprintf('******** STOPPING  SIMULATION ******** \n')		
	pause
end

% FUNCTION FOR INITIALIZING POSITIONS AND VELOCITIES
[RX,RY,RZ,VX,VY,VZ,FX,FY,FZ,EPOT,PRESS] = iniconfig(NATOM,DENS,kT,SIGMA,EPSILON,MASS,LJCUT);

% EQUILIBRATION STAGE
fprintf('\n')
fprintf('STARTING EQUILIBRATION \n')
	
RESCALE = true; % RESCALE VELOCITIES FOR KEEPING TEMPERATURE FIXED
	
for T = 1:EQSTEPS

    % WRITE TIMESTEP TO SCREEN 
    if (mod(T,1000)==0) 
        fprintf('EQLB STEP %6i \n', T) 
    end
    
    % UPDATE POSITIONS AND VELOCITIES OF THE ATOMS
    [RX,RY,RZ,VX,VY,VZ,FX,FY,FZ,EKIN,EPOT,ETOT,PRESS] = vverlet(RX,RY,RZ,VX,VY,VZ,FX,FY,FZ,NATOM,DENS,kT,SIGMA,EPSILON,MASS,LJCUT,DT,RESCALE);
     
    % ADD LONG-RANGE CORRECTIONS TO ENERGY AND PRESSURE  
	ETOT = ETOT + ELRC;
	EPOT = EPOT + ELRC;
	PRESS = PRESS + PLRC;
			
    % WRITE OUT ENERGIES AND PRESSURES EVERY IE STEPS
    if (mod(T,IE)==0)
        fprintf(energyfile,' %6i %6.3f %6.3f %6.3f \n', T, EKIN, EPOT, ETOT);
        fprintf(pressurefile,' %6i %6.3f \n', T, PRESS);
    end
		                
end	      

% PRODUCTION STAGE
fprintf('\n')
fprintf('STARTING PRODUCTION RUN \n')
	
RESCALE = false; % STOP RESCALING VELOCITIES (NVE ENSEMBLE)
	
for T = 1:PRODSTEPS

    % WRITE TIMESTEP TO SCREEN 
    if (mod(T,1000)==0) 
        fprintf('PROD STEP %6i \n', T) 
    end
    
    % UPDATE POSITIONS AND VELOCITIES OF THE ATOMS
    [RX,RY,RZ,VX,VY,VZ,FX,FY,FZ,EKIN,EPOT,ETOT,PRESS] = vverlet(RX,RY,RZ,VX,VY,VZ,FX,FY,FZ,NATOM,DENS,kT,SIGMA,EPSILON,MASS,LJCUT,DT,RESCALE);
     
    % ADD LONG-RANGE CORRECTIONS TO ENERGY AND PRESSURE  
	ETOT = ETOT + ELRC;
	EPOT = EPOT + ELRC;
	PRESS = PRESS + PLRC;
	
    % WRITE DOWN POSITIONS OF ATOMS IN THE TAPE FILE EVERY ITAPE STEPS
    if (mod(T,ITAPE)==0)
        for I = 1:NATOM    
			fprintf(tapefile,' %6.3f %6.3f %6.3f \n', RX(I), RY(I), RZ(I));
        end
    end
         
    % WRITE DOWN THE POSITIONS OF THE ATOMS IN AN "XMOL" FORMAT TO MAKE 
    % THE MOVIE EVERY IANIMATE STEPS
	if (mod(T,IANIMATE)==0)
        fprintf(moviefile,'%5i \n', NATOM);
        fprintf(moviefile,'\n');
        for I = 1:NATOM    
            fprintf(moviefile,'H %11.4f %11.4f %11.4f \n', RX(I), RY(I), RZ(I));
        end
	end

    % WRITE OUT ENERGIES AND PRESSURES EVERY IE STEPS
    if (mod(T,IE)==0)
        fprintf(energyfile,' %6i %6.3f %6.3f %6.3f \n', T+EQSTEPS, EKIN, EPOT, ETOT);
        fprintf(pressurefile,' %6i %6.3f \n', T+EQSTEPS, PRESS);
    end
		                
end

% CLOSE ALL FILES
fclose('all');
