#!/usr/bin/env ruby
require 'rubygems'
require 'net/ssh'
require 'net/ssh/multi'
require 'optparse' #std Ruby lib
require 'csv' #std Ruby lib
load './list_from_csv.rb'
load './pass_keeper.rb'
load './ticket.rb'

require 'pp'



###<Ticket:0x80276d130
# @auth_pass="m007",
# @command_to_do="z1com z9z0",
# @options={:maxsess=>69, :password=>true},
# @server_file="test/momus.csv",
# @servers=["208.111.39.128"],
# @user_name="dmitri",
# @user_pass="wqer">


my_ticket = Ticket.new
# pp "ticket" , my_ticket

@my_pass = my_ticket.user_pass

Net::SSH::Multi.start do |session|


#  session.use :options => {:password => '17IbmSucks'}

  # define the servers we want to use

#  my_ticket.servers.each do |session_server|
    session.use 'dmitri@208.111.39.128' , :password => @my_pass
 # end

  # execute commands on all servers
  session.exec "uptime"

  # run the aggregated event loop
  session.loop
end





#my_session = Net::SSH::Multi::Session.new

#Load up the servers into session from the ticket
#my_ticket.servers.each do |session_server|
#  my_session.server_list.add(session_server)
#end

#Pass the password
#my_session.use :options => {:password => my_ticket.user_pass}

#Pass the user name
#my_session.default_user = my_ticket.user_name
# pp "Session" , my_session

#my_session.exec "uptime"

#Class: Net::SSH::Multi::Server 
#Overview
# Encapsulates the connection information for a single remote server, as
# well as the Net::SSH session corresponding to that information. You'll rarely
# need to instantiate one of these directly: instead, 
# you should use Net::SSH::Multi::Session#use.'

#"Session"
#<Net::SSH::Multi::Session:0x8026df010
# @connect_threads=[],
# @default_user="kwaku",
# @gateway=nil,
# @groups={},
# @on_error=:fail,
# @open_connections=0,
# @open_groups=[],
# @pending_sessions=[],
# @server_list=#<Net::SSH::Multi::ServerList:0x8026dc5b8 @list=[]>,
# @session_mutex=#<Mutex:0x8026dbfa0>>









#HOST = '172.19.53.160'
#USER =  my_ticket.user_name
#PASS = my_ticket.user_pass

#host_list = my_ticket.servers

#host_list.each do |host|
#  Net::SSH.start( host, USER, :password => PASS ) do|ssh|
#    output = ssh.exec!('ls')
#    puts output
#  end
#end
