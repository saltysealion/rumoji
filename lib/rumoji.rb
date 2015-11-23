#-*- encoding: utf-8 -*-
require "rumoji/version"
require "rumoji/emoji"
require 'stringio'

module Rumoji
  extend self

  # Transform emoji into its cheat-sheet code
  def encode(str)
    str.gsub(Emoji::ALL_REGEXP) { |match| (emoji = Emoji.find_by_string(match)) && emoji.code || match }
  end

  # Transform a cheat-sheet code into an Emoji
  def decode(str)
    decoded_string = str.gsub(/:([^s:]?[\w-]+):/) {|sym| 
      (Emoji.find($1.intern) || sym).to_s 
    }   

    # transform common references into an emoji
    decoded_string = decoded_string.gsub(/([\=|0-9|a-zA-Z|\W]+)/i) {|sym| 
      (Emoji.find_with_word($1.intern) || sym).to_s 
    }   

    decoded_string
  end

  def encode_io(readable, writeable=StringIO.new(""))
    readable.each_line do |line|
      writeable.write encode(line)
    end
    writeable
  end

  def decode_io(readable, writeable=StringIO.new(""))
    readable.each_line do |line|
      writeable.write decode(line)
    end
    writeable
  end
end
