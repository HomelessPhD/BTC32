% This function will simply transform the 10-base(decimal) integer into 
% 16-base (HEXaDecimal) integer
% (builtin dec2hex is not enough accurate - not enough for large numbers)
function [HEX_number] = Dec2Hex_custom (number)
    Digits = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
    
    HEX_number = '';    
    number_buf = number;
    
    while(1)
        HEX_number = [Digits(rem(number_buf,16)+1), HEX_number];
        number_buf = floor(number_buf/16);
        if(number_buf == 0)
            break;
        end
    end
    
    %if(length(HEX_number) == 0)
    %    HEX_number = '0';
    %end
end