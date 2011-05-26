#!/usr/bin/ruby 
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


my_ticket = Ticket.new




pp "ticket" , my_ticket









# Net::SSH::Multi.start do |session|
  
#   # define the servers we want to use


#   my_ticket.servers do |host|

#     session.use host

#   end



#   # execute commands on all servers
#   session.exec my_ticket.command_to_do

 
# end



# class  Multisession < Net::SSH::Multi::Session


#   def initialize

#     @my_ticket = Ticket.new
#     @my_ticket.get_command_line

#     pp "Ticket" , my_ticket

#   end

#   def start
#     @concurrent_connections = @my_ticket.options[:maxsess]
#   end


# end

# Multisession.new
# self.start
# pp "Multi" , self
