function data = fix_encodings(data, rule)
% FIX_ENCODINGS Fix and standardise parent variable encodings so
% that msising values are listed always as NaN according to the
% substitution rule provided.
%
% USAGE: data = fix_encodings(data, rule)
% 
% where:
%     data: is a N subjects x  M variables data matrix.
%     rule: is a 1 x M vector with the encoded treatment following
%
% See also: fill_nested, prep_missing
    switch rule
      case 1 % Negative values are missing
        data(data < 0) = NaN;
      case 2 % No missing values encoded
        data(data < 0) = NaN;
      case 3 % Not applicable: -2; Missing: -1 and -3
        data(data == -2) = Inf;
        data(data == -1) = NaN;
        data(data == -3) = NaN;
      case 4 % Missing: -1 and -3; Less than one: -10
        data(data == -1) = NaN;
        data(data == -3) = NaN;
        data(data == -10) = 0;
      case 5 % Missing: 222 and 313
        data(data == 222) = NaN;
        data(data == 313) = NaN;
      case 6 % Missing: 6 and negative values
        data(data == 6) = NaN;
        data(data <  0) = NaN;
      otherwise % Unkown rule case
        Error = MException('fix_encodings:InvalidAction',...
                           'Unkown rule value %d.', ...
                           rule(var));
        
        throw(Error);
    end

end