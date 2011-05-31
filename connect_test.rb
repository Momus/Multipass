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

    session.open_channel do |channel|

      channel.request_pty(:term => 'xterm') do |ch, success|

        if success
          ch.exec my_ticket.command_to_do  do |ch, success|
            if success
              puts "command has begun executing..."
              # this is a good place to hang callbacks like #on_data...
            else
              puts "alas! the command could not be invoked!"
            end
            
          end
        else
          puts "Could not open channel"
        end

      end

 

      pp "command" ,  my_ticket.command_to_do

    end
    
    
    #shell = session.shell.open

    #shell.my_ticket.command_to_do

    #shell.exit


   
  end




  # run the aggregated event loop
  session.loop
end
