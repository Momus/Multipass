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
  session.exec my_ticket.command_to_do do |channel, stream, data|
    if data =~ /^\[sudo\] password for user:/
      channel.request_pty #= true
      channel.send_data my_ticket.user_pass
    end
    #pp "channel" , channel
    puts "[#{channel[:host]} : #{stream}] #{data}"
    #puts channel.methods
  end

  # run the aggregated event loop
  session.loop
end
