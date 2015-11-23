# -*- encoding: utf-8 -*-
module Rumoji
  class Emoji

    attr_reader :name, :string

    def initialize(string, symbols, common_references = [],  name = nil)
      @string = string
      @codepoints = string.codepoints
      @cheat_codes = [symbols].flatten
      @common_references = [common_references].flatten
      @name = name || @cheat_codes.first.to_s.upcase.gsub("_", " ")
    end

    def symbol
      @cheat_codes.first
    end

    def code
      ":#{symbol}:"
    end

    def include?(s)
      @cheat_codes.include? s
    end

    def include_reference?(s)
      @common_references.include? s.to_sym
    end

    def to_s
      @string
    end

    def hash
      code.hash
    end

    def hex
      @hex ||= @codepoints.map{|point| point.to_s(16).upcase }.join("-")
    end

    def codepoints
      @codepoints.entries
    end

    def multiple?
      @codepoints.size > 1
    end

    autoload :PEOPLE, 'rumoji/emoji/people'
    autoload :NATURE, 'rumoji/emoji/nature'
    autoload :OBJECTS, 'rumoji/emoji/objects'
    autoload :PLACES, 'rumoji/emoji/places'
    autoload :SYMBOLS, 'rumoji/emoji/symbols'

    ALL = PEOPLE | NATURE | OBJECTS | PLACES | SYMBOLS

    ALL_REGEXP = Regexp.new(ALL.map(&:string).join('|'))

    def self.find(s)
      ALL.find {|emoji| emoji.include? s}
    end

    def self.find_with_word(s)
      ALL.find {|emoji| emoji.include_reference? s}
    end

    STRING_LOOKUP = ALL.each.with_object({}) do |emoji, lookup|
      lookup[emoji.string] = emoji
    end

    def self.find_by_string(string)
      STRING_LOOKUP[string]
    end
  end
end
