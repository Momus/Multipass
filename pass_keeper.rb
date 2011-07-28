require 'rubygems'
require 'highline/import'  #gem install highline

class Authorization

  attr_reader :user_password , :target_password


  def prompt(prompt_for_target = false)
    @user_password = ask_for_password("Enter your admin password")
    return unless prompt_for_target

    5.times do
      password     = ask_for_password("Enter password for target account")
      confirmation = ask_for_password("Please, re-enter password to verify")

      if password == confirmation
        @target_password = password

        return
      else
      puts "The two passwords do not match.  Please try again."
      end
    end
  end

  private

  def ask_for_password(message)
    ask("#{message}: ") { |q| q.echo = '*' }
  end
end
