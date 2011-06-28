#!/usr/bin/ruby 

require 'csv'
require 'pp'

class  List_from_csv

attr_reader :list , :file
   
  def initialize(csv_file)

    @file = csv_file
    @list = Array.new

    CSV.open(@file , 'r') do |row|
      
      row.each {  |column|
        ip = column.to_s
        @list.push(ip)
      }
    end

  end
  
end
