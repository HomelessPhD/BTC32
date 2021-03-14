function [HEX_number] = Dec2Hex_custom (number)
    Digits = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
    
    HEX_number = '';    
    number_buf = number;

    while(1)
        HEX_number = [Digits(mod(number_buf,16)+1), HEX_number];
        number_buf = floor(number_buf/16);
        if(number_buf == 0)
            break;
        end
    end

end