% Dummy octave script - composes a "task" for "aimed" search of the
% private keys for BTC32 Puzzle addresses.
%
%
% Donations could be sent here: 1QKjnfVsTT1KXzHgAFUbTy3QbJ2Hgy96WU
% ( i am poor Ukrainian student that will really appreciate your 
% donates - have no home, living in the dorm and trying to cope 
% for the smallest flat in the city - with no success at the moment,
% nearly 10% of desired amount)

%% clear all
clc;
close all;
clear all;

% To run this script in Octave you will need the symbolic package that 
% could be downloaded from https://octave.sourceforge.io/symbolic/index.html
% (that could also require some python3 packages:
% sudo apt-get install python3-pip
% python3 -m pip install --user mpmath
% python3 -m pip install --user sympy==1.5.1)
pkg load symbolic;


%% Define parameters
    % VPA (default MATLAB precision is not enough to accurately process
    % large numbers like 2^150 and thats why Variable-Precision arithmetic
    % is used here == AKA Large Numbers)
vpa_acc = 100;
    % BruteForce parameters
        % Here is the bruteforce speed estimation that will be used to
        % estimate the interval of Private Keys to be brutted withing given
        % time interval
BruteRate_MKs = 200;
        % The maximum allowed time (timeout) for one search operation - 
        % the Private Keys interval (series) would be chosen based on the
        % desired "time out" and the bruteforce speed
Run_TimeOut_m = 10;
        % The maximum amount of Private Keys to be investigated during
        % one search operation
MAX_Keys_interval = ceil(vpa(BruteRate_MKs * (10^6) * Run_TimeOut_m * 60, vpa_acc));
 
        % Private keys for each "BTC32 puzzle" address lies inside the known
        % continues interval (series) of values: 2^(n-1) - 2^(n), 2^(n-1) 
        % in total where "n" is the index of the given address.
        % It was decided to describe each Private Key in "dimensionless"
        % form - Private Key relative position inside its interval
        % Alpha(PK_n) ==  (PK_n - 2^(n-1)) / (2^n - 2^(n-1));
        %
        % Here the desired Private Keys intervals position are given by 
        % its central value - script will inspect keys located in interval 
        % with center at alpha_to_seek value and  MAX_Keys_interval width		
alpha_to_seek = vpa([0 0.0078125 0.75 0.82207866191468159655642011784948 0.82817983680743556540448935265886 1], vpa_acc);

%% Read the list of an interesting unspent addresses from the file
%  (this file should be prepared to have a simple content - lines with 
%   addresses going to be inspected as following
%   n,"btc address"
%   
%   For example:
%   66,"13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so"
%   67,"1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9"
%
%   File could contain multiple lines - the script will generate the task
%   for each given address using each of the given alpha values
[bits, addresses] = textread( 'Pzl32_unspentList.csv', '%d "%s"' ,'delimiter' , ',' );

    % Open\create a file to write the composed task - the task file will
    % contain the information of addresses and Private Keys intervals
    % in a consumable form.
fid = fopen('task_file.txt','w')
for i = 1:length(bits)
    for j = 1:length(alpha_to_seek)
            % Calculate the left and right edges of the interval for the
            % given BTC address \ alpha value
        left_edge = floor( vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc) * (1+alpha_to_seek(j)) ) + floor(-MAX_Keys_interval/2);
        right_edge = ceil( vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc) * (1+alpha_to_seek(j)) ) + ceil( MAX_Keys_interval/2);
		
            % If the interval overlap the 2^(n-1) or 2^(n) edges - smallest
            % and largest possible values for the given Private Key - just
            % shift the search interval(instead of reducing it) - because
            % there is no reason to search the Private Key outside of the
            % 2^(n-1) - 2^(n) interval:
            %  *__|__*______________| -> *|____*______________|
            % |______________*__|__* ->  |______________*____|*        
        if (left_edge - vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc) < -1)
            left_edge = floor(vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc)) -1;
            right_edge = ceil(vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc) ) + MAX_Keys_interval;
        end

        if (right_edge - vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc)*2 > 1)
            left_edge = floor(vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc))*2 -MAX_Keys_interval;
            right_edge = ceil(vpa(2^(vpa(bits(i), vpa_acc)-1), vpa_acc))*2 +1;
        end

		    % octave sript works slow - output some data to information
			% about the process
        fprintf(1,'%d\n',bits(i));

        fprintf(fid,'%d,%f,%s:%s,%s\n',bits(i),double(alpha_to_seek(j)),Dec2Hex_custom(left_edge), Dec2Hex_custom(right_edge), addresses{i});

    end
end

fclose(fid);
