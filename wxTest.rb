require "wx"

include Wx



class MyFrame < Frame
  def initialize()
    super(nil, 
          :title => 'Multipass GUI Mockup' ,
          :pos   => [1,1] ,
          :size  => [1200, 800]

          )

    panel = Wx::Panel.new(self)    #Parent = self = this Frame
    
    drink_choices = ["create account", "reset password", "delete account", "modify account"]   #labels for radio buttons
    
    radios = Wx::RadioBox.new(
                              panel,                        #Parent 
                              :label => "Account Actions",           #Label for box surrounding radio buttons
                              :pos => [20, 5],              
                              :size => Wx::DEFAULT_SIZE,     
                              :choices => drink_choices,    #The labels for the radio buttons
                              :major_dimension => 1,        #Max number of columns(see next line)--try changing it to 2
                              :style => Wx::RA_SPECIFY_COLS #:major_dimension value applies to columns
                              
                              #The :major_dimension and :style in combination determine the layout of the 
                              #RadioBox.  In this case, the maximum number of columns is 1, which means
                              #there can only be one radio button per line.  Because there are 4 radio buttons, 
                              #that means there will be 4 lines, with one radio button per line.
        
                              )

    evt_radiobox(radios.get_id()) {|cmd_event| on_change_radio(cmd_event)}

    #When there is an event of type evt_radiobox on the widget with the id radios.get_id(),
    #the block is called and an "event object" is passed to the block.  The block calls
    #the method on_change_radio(), defined below, relaying the event object to the 
    #method. The event object contains useful information about the radio button 
    #that was selected.


    @text_widget = Wx::StaticText.new(  
                                      panel,                  #Parent 
                                      :label => "coffee",   
                                      :pos => [150, 25],  
                                      :size => Wx::DEFAULT_SIZE      
   
                                      #Store a widget in an instance variable when other
                                      #methods, like the one below, need access to it.
                                      )
    
    
    show     #equivalent to self.show, makes the frame visible
  end
  
  
  def on_change_radio(cmd_event)
    selected_drink = cmd_event.string  #Selected radio's label
    
    #Instead of calling cmd_event.get_string() or cmd_event.set_string(), you can  
    #now call an accessor method with the same name as the property you are trying
    #to get or set. See: wxRuby Overview on the doc page wxruby_intro.html

    @text_widget.label = selected_drink
  


  end #def initialize()

end  #class MyFrame < Frame





class MinimalApp < App
    def on_init
         MyFrame.new #.show() 
    end
 end
 

 MinimalApp.new.main_loop
