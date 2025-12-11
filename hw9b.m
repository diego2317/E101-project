%% Problem 1) Bode plots of H(s)

wc = 20.*pi;
a1 = 2*cos(5*pi/8);
a2 = 2*cos(7*pi/8);

sys1 = tf(wc^2, [1, -a1*wc, wc^2]);
sys2 = tf(wc^2, [1, -a2*wc, wc^2]);

H = sys1*sys2;

bode(H);
grid on

%% Part 2) Find Resistor values
fp = 10;
zeta1 = a1/2;
zeta2 = a2/2;

C1_1 = 0.22e-6;
C2_1 = 0.1e-6;
C1_2 = 1e-6;
C2_2 = 0.1e-6;

designStage = @(zeta,C1,C2) ...
    deal( ...
      ((2*zeta*sqrt(1/(wc^2*C1*C2))*sqrt(C1/C2)) + ...
      [-1 1].*sqrt( (2*zeta*sqrt(1/(wc^2*C1*C2))*sqrt(C1/C2)).^2 ...
                    - 4*(1/(wc^2*C1*C2)) )) / 2 );

% Stage I (returns [R1,R2])
[R1_1, R2_1] = designStage(zeta1, C1_1, C2_1);
% Stage II
[R1_2, R2_2] = designStage(zeta2, C1_2, C2_2);

% After rounding each R to nearest standard value, define transfer functions:
H1 = tf(1, [R1_1*R2_1*C1_1*C2_1, (R1_1+R2_1)*C2_1, 1]);
H2 = tf(1, [R1_2*R2_2*C1_2*C2_2, (R1_2+R2_2)*C2_2, 1]);
Htot = series(H1, H2);   % cascade

bode(Htot); grid on;