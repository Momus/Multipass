#!/usr/bin/env ruby
# mulitpass.rb

require 'optparse' #std Ruby lib
require 'csv' #std Ruby lib
load './list_from_csv.rb'
load './pass_keeper.rb'
load './ticket.rb'

# Pretty print objects for a better debugging experience
# Declaration should probably be removed in final version
require 'pp'


require 'rubygems'
require 'net/ssh'
require 'net/ssh/multi'


#The necessary data is contained in a Ticket object 
my_ticket = Ticket.new


#Have a container ready for the output

Channel_Result_Struct = Struct.new(:time_stamp , \
                             :result)

@result_hash = Hash.new






# Connection errors can be handled rather gracefully in net-ssh-multi through
# the use of a proc object that is invoked when a server connection fails

connect_error_handler = Proc.new do |server|

  #Log them

  result_struct  = Channel_Result_Struct.new  
  result_struct[:time_stamp] = Time.now
  result_struct[:result] = "Connection to " + server.host + " FAILED"
  @result_hash[server.host] = result_struct

  #And print them out to the console

  puts "\n"
  puts 'Connection to ' + server.host + " FAILED\n\n"


end


Net::SSH::Multi.start(:concurrent_connections => my_ticket.options[:maxsess], \
                      :on_error => connect_error_handler) do |session|


  # define the servers we want to use
  my_ticket.servers.each do |session_server|
    session.use session_server , :user =>  my_ticket.user_name ,  \
    :password => my_ticket.user_pass ,\
    :timeout => 2 ,\
    :verbose => :error
 

    # Debugging options go above in the "verbose" key.
    #For normal operation, this should be set to 'FATAL'
    # See File lib/net/ssh.rb :
    
    #174            when :debug then Logger::DEBUG
    #175:           when :info  then Logger::INFO
    #176:           when :warn  then Logger::WARN
    #177:           when :error then Logger::ERROR
    #178:           when :fatal then Logger::FATAL
    # http://net-ssh.rubyforge.org/ssh/v2/api/classes/Net/SSH.html
 end

  # Open an RFC 4254 channel
  # http://tools.ietf.org/html/rfc4254#page-5

 session.open_channel do |channel|

    hostname = channel.properties[:host]
    
    #  Tell the user what's going on, with a little whitespace for clarity:
    #puts "\n\n"
    #puts "Starting a new ssh session on " +  hostname

    #  Make a new container for our data

    #Have a container ready for the output

    result_struct  = Channel_Result_Struct.new  #Struct.new(:time_stamp ,:result)

    result_struct[:time_stamp] = Time.now

    #The :result key must point to a string
    result_struct[:result] = " "

    # A pty is necessary for sudo, get one when we open the channel
    channel.request_pty(:modes => \
                        { Net::SSH::Connection::Term::ECHO => 0 }) do |c, success|
      raise "could not request pty" unless success
      
      #sends the command to the channel, ignoring any preceeding data:
      channel.exec   my_ticket.command_to_do do  |ch, success|

        #This will only show if the command could not be executed, not if it fails
        # execution, so it's kinda useless.
        raise my_ticket.command_to_do + "not executed" unless success

      end
 


      # According to rfc4254 Section 5.2.:
      #       Data transfer is done with messages of the following type.
      #
      #          byte      SSH_MSG_CHANNEL_DATA
      #          uint32    recipient channel
      #          string    data

      # The "data" in the codeblock below is the "data" string returned
      # in accordance with above.


      # See also:  http://net-ssh.github.com/ssh/v1/chapter-3.html#s1
           
     channel.on_data do |c_, data|

        # Scan channel data string for password prompts, sending 
        # the appropriate string to each one.  

        if data =~ /^Password\:$/x
          channel.send_data(my_ticket.user_pass + "\n")
        
        else data =~ /.*\:$/x
          channel.send_data(my_ticket.target_pass + "\n")
        end
          
        #result_struct[:result] = data
        result_struct.result =  result_struct[:result] + data
        
        #puts "Result:\n"
        puts  '[' + hostname + ']  ' + data 
          
        @result_hash[hostname] = result_struct
      end
      
      channel.wait

    end
    
    # run the aggregated event loop
    session.loop      

  end 

end





# The first version of this script will place results in a file
# with a dynamically generated name

# The name will be in the format hr_min_sec_day-month-yy.csv


#def write_to_csv(hash_of_results)

time_string = Time.now.strftime("%Hh%Mm%Ss-%d-%b-%y")
file_name = 'results/' + time_string + ".csv"
pp "Output written to:" , file_name


CSV.open(file_name , "w") do |csv|

  #The keys in the result hash are the hosts, extract those as well
  # The values are Channel_Result_Structs (:time_stamp , :result)

  csv << ["Time Stamp" , "Host" , "Command Output"]

  @result_hash.each_pair do |key,value|

    csv << [ value.time_stamp , key ,  value.result]
  end

end
