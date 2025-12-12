%% Find coefficients


a  = 2*cos(0.2*pi);       % 2*cos(omega0)
C1 = [1, -a, 1];          % 1 - a w + w^2
L  = ones(1, 10);         % 1 + w + ... + w^9
hB_unscaled = deconv(L, C1);
b0  = 1 / sum(hB_unscaled);
hB  = b0 * hB_unscaled   % final DC-normalized coefficients
