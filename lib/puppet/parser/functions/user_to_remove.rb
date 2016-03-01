#
# user_to_remove.rb
#
# Alexander Schrapel <ndealex@gmail.com>
#
module Puppet::Parser::Functions
  newfunction(:user_to_remove, :type => :rvalue, :doc => <<-EOS
  TODO: Doku
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "user_to_remove(): The argument must be an array") if (arguments.size < 1) or (!arguments[0].kind_of?(Array))

    to_remove = []
    ignore = []
    all = arguments[0]
    ignore = arguments[1] if arguments.length > 1


    users = lookupvar("::system_users")
    if not users.nil?
      users.each do |user, value|
        to_remove << user if (ignore.include?(user) == false) and (all.include?(user) == false)
      end
    else
      return nil
    end
    return to_remove
  end
end
