function y = gschmidt(x, v)

    [~, n] = size(x);
    y = x(:, 1);

    for k = 2:n % orthogonalization process
        z = 0;

        for j = 1:k - 1
            p = y(:, j);
            z = z + ((p' * x(:, k)) / (p' * p)) * p;
        end

        y = [y x(:, k) - z];
    end

    if nargin == 1
        for j = 1:n, y(:, j) = y(:, j) / norm(y(:, j)); end % normalizing
    end
