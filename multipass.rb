#!/usr/bin/ruby 
# mulitpass.rb

require 'optparse' #std Ruby lib
require 'csv' #std Ruby lib
load './list_from_csv.rb'
load './pass_keeper.rb'

# Pretty print objects for a better debugging experience
# Declaration should probably be removed in final version 
require 'pp'




# Part I: get input from command line invocation
#http://ruby.about.com/od/advancedruby/a/optionparser2.htm

module Multipass

  #Hash to hold all of the command line options
  options = {} 

  optparse = OptionParser.new do|opts|

    # Display a banner at the top of help screen
    opts.banner = <<BANNER_TXT
Multipass:  Run your command on a group of servers simultaniously.  

Usage:  multipass.rb [options] server_file.csv \'command\' \n \
THE COMMAND MUST BE ENCLOSED IN SINGLE QUOTES, AS ABOVE

BANNER_TXT

    # Define the options and display what they do
    
    options[:password] =  false
    opts.on( '-p' , '--password' , 'Prompt for a password to be used in the command' ) do
      options[:password] = true
    end
  
    options[:maxsess] = false
    opts.on( '-m' ,  '--maxsessions NUM' , Integer,  'Change the number of simultaneous ssh sessions from default to NUM') do |m| 
      options[:maxsess] = m
    end
    
    # This displays the help screen, all programs are
    # assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
      puts opts
      exit
    end



  end

  #This is where some magic happens
  optparse.parse!

  if ARGV.empty? 
    puts optparse
    exit(-1)
  end



  # Part II: read the csv file from command line into the array



  #Get the csv file out of ARGV and into an array
  #Remember, that since oprparse chomps out options, this should be
  #the first item



server_list = List_from_csv.new(ARGV[0])

  pp 'list' , server_list
  pp server_list.list

#  pp 'class' , server_list[0].to_s.class
#  pp 'Commmand' , ARGV[1]


  #session_list = session_obj.@buf_list
  
  #pp 'session_list' , @@session_list

end

