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


#finished = ("%08x" * 8) % Array.new(8) { rand(0xFFFFFFFF) }


Net::SSH::Multi.start do |session|


  # define the servers we want to use
  my_ticket.servers.each do |session_server|
    session.use session_server , :user =>  my_ticket.user_name ,  \
    :password => my_ticket.user_pass
  end



 session.open_channel do |channel|
    channel.request_pty  do |c, success| #(:modes => \
      # { Net::SSH::Connection::Term::ECHO => 0 })\
      
      raise "could not request pty" unless success
      channel.exec   my_ticket.command_to_do
      channel.on_data do |c_, data|
        #if data =~ /^Password:/
        channel.send_data(my_ticket.user_pass + "\n")
        #else
        puts data
        pp c_.pretty_print_inspect
        #end
      end

      
    end
  end



  # run the aggregated event loop
  session.loop
end
