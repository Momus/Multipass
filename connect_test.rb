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

require 'net/ssh'
require 'net/ssh/multi'


#The necessary data is contained in a Ticket object 
my_ticket = Ticket.new


Net::SSH::Multi.start do |session|


  # define the servers we want to use
  my_ticket.servers.each do |session_server|
    session.use session_server , :user =>  my_ticket.user_name ,  \
    :password => my_ticket.user_pass
  end



  # execute commands on all servers

  session.open_channel do |ch|

    ch.request_pty
    ch.exec('sudo ls /root') do |c, sucess|

        #raise "could not request pty!" unless sucess



        ch.send_data( my_ticket.user_pass <<  "\n")

        

        # "on_data" is called when the process writes something to stdout
        ch.on_data do |c, data|
          pp  'data' , data.inspect
          #if data =~ /\[sudo\] password/
          #  c.send_data my_ticket.user_pass
          #end
          
          
      end

        # "on_extended_data" is called when the process writes something to 
        #  stderr
        ch.on_extended_data do |c, type, data|
        #  $STDERR.print data
      end

        ch.on_close { puts "done!" }
    end

  end


  # run the aggregated event loop
  session.loop
end


