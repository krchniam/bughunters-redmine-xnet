module ActiveSupport #:nodoc:
 module Multibyte #:nodoc:
   # Returns a regular expression that matches valid characters in the current encoding
   def self.valid_character
     case $KCODE
     when 'UTF8'
       VALID_CHARACTER['UTF-8']
     when 'SJIS'
       VALID_CHARACTER['Shift_JIS']
     end
   end

   # Verifies the encoding of a string
   def self.verify(string)
     if expression = valid_character
       for c in string.split(//)
         return false unless valid_character.match(c)
       end
     end
     true
   end

   # Verifies the encoding of the string and raises an exception when it's not valid
   def self.verify!(string)
     raise ActiveSupport::Multibyte::Handlers::EncodingError.new("Found characters with invalid encoding") unless verify(string)
   end

   # Removes all invalid characters from the string
   def self.clean(string)
     if expression = valid_character
       stripped = []; for c in string.split(//)
         stripped << c if valid_character.match(c)
       end; stripped.join
     else
       string
     end
   end
 end
end