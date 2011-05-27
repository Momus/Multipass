#!/usr/bin/env ruby
require 'rubygems'
require 'net/ssh'
require 'optparse' #std Ruby lib
require 'csv' #std Ruby lib
load './list_from_csv.rb'
load './pass_keeper.rb'
load './ticket.rb'

require 'pp'

my_ticket = Ticket.new
 pp my_ticket

#HOST = '172.19.53.160'
USER =  my_ticket.user_name
PASS = my_ticket.user_pass
host_list = my_ticket.servers

host_list.each do |host|
  Net::SSH.start( host, USER, :password => PASS ) do|ssh|
    output = ssh.exec!('ls')
    puts output
  end
end
