function y = unfold(data, relations)
% UNFOLD unfolds the hierarchies in the data to eliminate
% artificially generated hierarchical data.
%
% USAGE: unfolded = unfold(data, relations)
% 
% where:
%     data: data matrix of N subjects x  M variables.
%     relations matrix of M variables x 1 (parent).
%
% See also: findvar.

for var_idx = 1:length(relations)
    
    % Check for dependency
    if ~relations(var_idx)     
        % Check if data for the subject is entried as missing
        for subj = 1:size(data, 1)
            
            if isnan(data(subj, var_idx))
                % if it's not actually missing, then take action
                if ~isnan(data(subj, relations(var_idx)))
                    data(subj, var_idx) = 0;
                end
                
            end
            
        end
        
    end
    
end

end