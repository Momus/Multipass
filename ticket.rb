  class Ticket

    attr_accessor :user_name , :user_pass , :target_pass
    attr_accessor :options, :command , :debug_level 
    attr_accessor :servers ,  :server_file , :command_to_do 


    def initialize

      #Hash to hold all of the command line options
      @options = {} 

      optparse = OptionParser.new do|opts|

        # Display a banner at the top of help screen
        opts.banner = <<BANNER_TXT

Multipass:  Run your command on a group of servers simultaneously.  

Usage:  multipass.rb [options] user_name server_file.csv 'command' 
 
If the p flag is specified, multipass will prompt for a second
password to be used if the command that is run requires one. For
example: 'multipass -p username serverlist.csv 'sudo passwd'
would first prompt the user 'username' for his administrative password
then it would prompt for a second password twice to verify that it is
correct, which will be passed to the shell when the 'passwd' command
executes.

user_name:        the short-name you use to administer the servers

server_file.csv:  a list servers (resolvable FQDNs or IP's) in a comma
                  separated variable (CSV) file.  As of this version,
                  the file may only contain IPs or FQDNs each in a
                  separate cell.

'command' :       command to be run on the servers.
THE COMMAND MUST BE ENCLOSED IN SINGLE QUOTES, AS ABOVE


Options:
BANNER_TXT

        # Define the options and display what they do
        
        @options[:password] =  false
        opts.on( '-p' , '--password' , \
                 'Prompt for a password to be used in the command' ) do
          @options[:password] = true
        end
        
        @options[:maxsess] = false
        opts.on( '-m' ,  '--maxsessions NUM' , Integer, \
                 'Change number of ssh sessions from default to NUM') do |m| 
          @options[:maxsess] = m
        end
        @options[:debug_level] = ":fatal"
        opts.on( '-d' , '--debug_level :level' , String,\
                 "Set the debug level with which to run the program.\n" +\
                 "Options are: :debug :info :warn :error :fatal") do |opt|
          @options[:debug_level] = opt
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

      server_info = List_from_csv.new(ARGV[1])
      @servers = server_info.list
      @server_file = server_info.file
      


      # Part III: get all the necessary passwords

      ticket_authorization = Authorization.new
      
      if @options[:password]
        ticket_authorization.prompt(true)
        @target_pass =  ticket_authorization.target_password
      else
        ticket_authorization.prompt
      end

      @user_pass =  ticket_authorization.user_password


      # Part IV: Don't forget to pass the command to the object
      #          and user name
      
      @user_name     = ARGV[0]
      @command_to_do = ARGV[2]
   
  end
end
