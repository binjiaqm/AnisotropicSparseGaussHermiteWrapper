function [sparse_point, sparse_weight] = aniso_sparsegrid_wrapper(dim_num,level,importance)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wapper written by Bin Jia @ 20161210 www.bin-jia.com
% other functions can be downloaded @ https://people.sc.fsu.edu/~jburkardt/cpp_src/sgmga/sgmga.html 
% Last visited @ 20161210
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% example:
%{

dim_num = 2; level = 2; 
importance=[2,1];
[sparse_point, sparse_weight] = aniso_sparsegrid_wrapper(dim_num,level,importance);

%}

% Change parameters when you use the code.
%% Private use

tol = sqrt(eps);
level_weight = sgmga_importance_to_aniso ( dim_num, importance );
rule = 5*ones(dim_num,1);
np=zeros(dim_num,1);
growth=3*ones(dim_num,1);
np_sum = sum ( np(1:dim_num) );
p = zeros(np_sum,1);

point_total_num = sgmga_size_total ( dim_num, level_weight, level, ...
      rule, growth );

point_num = sgmga_size ( dim_num, level_weight, level, rule, growth, ...
      np, p, tol );

sparse_unique_index = sgmga_unique_index ( dim_num, level_weight, ...
      level, rule, growth, np, p, tol, point_num, point_total_num );

[ sparse_order, sparse_index ] = sgmga_index ( dim_num, level_weight, ...
      level, rule, growth, point_num, point_total_num, sparse_unique_index );

sparse_weight = sgmga_weight ( dim_num, level_weight, level, rule, ...
      growth, np, p, point_num, point_total_num, sparse_unique_index );
  
sparse_point = sgmga_point ( dim_num, level_weight, level, rule, ...
      growth, np, p, point_num, sparse_order, sparse_index );
	  
sparse_weight = sparse_weight/pi;
sparse_point  = sparse_point * sqrt(2);