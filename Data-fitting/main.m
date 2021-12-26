m = 15;
x = [0, 64, 128, 192, 256, 320, 384, 448, 384, 320, 256, 192, 128, 64, 0]';
y = [30, 30, 26, 24, 17, 11, 7, 0, 6, 7, 11, 14, 20, 25, 29]';

m_1 = find(~y);
x_1 = x(1 : m_1);
y_1 = y(1 : m_1);

m_2 = m_1;
x_2 = x(m_1 : end);
y_2 = y(m_1 : end);

addpath(genpath(fullfile('octave-interval-examples', 'm')));

X_1 = [ones([m_1, 1]) x_1];
mid_y_1 = y_1;
rad_y_1 = ones([m_1, 1]);

X_2 = [ones([m_2, 1]) x_2];
mid_y_2 = y_2;
rad_y_2 = ones([m_2, 1]);

ir_scatter(ir_problem(X_1(1 : (end - 1), :), mid_y_1(1 : (end - 1)), rad_y_1(1 : (end - 1))), 'b.');
hold on;
ir_scatter(ir_problem(X_2(2 : end, :), mid_y_2(2 : end), rad_y_2(2 : end)), 'r.');
ir_scatter(ir_problem(X_1(end, :), mid_y_1(end), rad_y_1(end)), 'k.');
grid on;
xlabel('Код управления');
ylabel('Код энкодера');

mid_y_1 = flip(mid_y_1);

x_2 = flip(x_2);
X_2 = flip(X_2);

inf_y_1 = mid_y_1 - rad_y_1;
sup_y_1 = mid_y_1 + rad_y_1;

inf_y_2 = mid_y_2 - rad_y_2;
sup_y_2 = mid_y_2 + rad_y_2;

[tolmax_1, beta_1, envs_1, ccode_1] = tolsolvty(X_1, X_1, inf_y_1, sup_y_1);
[tolmax_2, beta_2, envs_2, ccode_2] = tolsolvty(X_2, X_2, inf_y_2, sup_y_2);

[~, indices_1] = sort(envs_1(:, 1));
[~, indices_2] = sort(envs_2(:, 1));

w_1 = max(0, -envs_1(indices_1, 2));
w_2 = max(0, -envs_2(indices_2, 2));

figure();
ir_scatter(ir_problem(X_1, mid_y_1, rad_y_1 + w_1), '.');
hold on;
ir_scatter(ir_problem(X_2, mid_y_2, rad_y_2 + w_2), '.');
ir_plotline(beta_1, x_1);
ir_plotline(beta_2, x_2);

inf_y = min(inf_y_1, inf_y_2);
sup_y = max(sup_y_1, sup_y_2);

x = x_1;
X = X_1;

[tolmax, beta, envs, ccode] = tolsolvty(X, X, inf_y, sup_y);

mid_y = (inf_y + sup_y) / 2;
rad_y = (sup_y - inf_y) / 2;

figure();
ir_scatter(ir_problem(X, mid_y, rad_y), '.');
hold on;
ir_plotline(beta, x);
grid on;
xlabel('Код управления');
ylabel('Код энкодера');
