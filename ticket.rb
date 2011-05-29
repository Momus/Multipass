  class Ticket

    attr_accessor :user_name , :user_pass , :auth_pass
    attr_accessor :options, :command 
    attr_accessor :servers ,  :server_file , :command_to_do 


    def initialize

      #Hash to hold all of the command line options
      @options = {} 

      optparse = OptionParser.new do|opts|

        # Display a banner at the top of help screen
        opts.banner = <<BANNER_TXT
Multipass:  Run your command on a group of servers simultaniously.  

Usage:  multipass.rb [options] user_name server_file.csv \'command\' \n 

user_name:        the shortname you use to adminster the servers

server_file.csv:  a list servers (resolvable FQDNs or IP's) in a comma
                  seperated variable (CSV) file.

'command' :       command to be run on the servers.
THE COMMAND MUST BE ENCLOSED IN SINGLE QUOTES, AS ABOVE

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
        @auth_pass =  ticket_authorization.target_password
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
