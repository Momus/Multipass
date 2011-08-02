#Have a container ready for the output

Channel_Result_Struct = Struct.new(:time_stamp , \
                             :result)

@result_hash = Hash.new



.....         output = Channel_Result_Struct.new( Time.now , data)
        
        @result_hash[c_[:host].to_s] =  output
