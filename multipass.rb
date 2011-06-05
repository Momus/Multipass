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


Net::SSH::Multi.start(:concurrent_connections => my_ticket.options[:maxsess]) do |session|


  # define the servers we want to use
  my_ticket.servers.each do |session_server|
    session.use session_server , :user =>  my_ticket.user_name ,  \
    :password => my_ticket.user_pass
  end

  # Open an RFC 4254 channel
  # http://tools.ietf.org/html/rfc4254#page-5

 session.open_channel do |channel|

    
    #  Tell the user what's going on:
    
    puts "\n\n\n"
    puts "Starting a new ssh session on " + channel.properties[:host]

    # A pty is necessary for sudo, get one when we open the channel
    channel.request_pty(:modes => { Net::SSH::Connection::Term::ECHO => 0 }) do |c, success|
      raise "could not request pty" unless success
      
      #sends the command to the channel, ignoring any preceeding data:
      channel.exec   my_ticket.command_to_do
 
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

        if data =~ /^\[sudo\] password for.*\:/
          channel.send_data(my_ticket.user_pass + "\n")
        end
        if data =~ /.*:\ $/
          channel.send_data(my_ticket.target_pass + "\n")
        else

          puts  data 
     
 
        end
 
      end
       
        pp channel.properties[:host]   #each { |key| puts key} 

         #pp c
     
    end
  end




  # run the aggregated event loop
  session.loop
end


# dbrengauz@IBM-03232011-Z9Z ~/dev/Multipass
# $ ruby multipass.rb -p dmitri test/idadm_and_momus.csv 'sudo passwd dmitri'
# Enter your admin password: **********
# Enter password for target account: **********
# Please, re-enter password to verify: **********
# Enter new UNIX password:
# Changing password for user dmitri.
# New UNIX password:

