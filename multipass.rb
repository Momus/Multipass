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

class  Multisession < Net::SSH::Multi::Session


  def initialize

    my_ticket = Ticket.new
    my_ticket.get_command_line

    pp "Ticket" , my_ticket

  end





end

 Multisession.new

pp "Multi" , self
