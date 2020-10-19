clear all; clc

seed_hash = 11234581123;

len = 100;
X2D = zeros(len);
for i = 1:len
    for j = 1:len
        X2D(i, j) = rand2D(i - len/2, j - len/2, seed_hash);
    end
end
clear i j

histogram(X2D)

function x = rand2D(x, y, seed_hash)
    x = mod(sin(dot([x, y], [12.9898, 78.233])) * (43758.5453 + mod(seed_hash, 100000)), 1);
end