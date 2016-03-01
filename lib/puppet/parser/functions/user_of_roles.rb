#
# user_of_roles.rb
#
# Alexander Schrapel <ndealex@gmail.com>
#
module Puppet::Parser::Functions
  newfunction(:user_of_roles, :type => :rvalue, :doc => <<-EOS
  Returned a list of all user are member of given roles.

  Parameter:
    1. Array of roles
    2. Boolean (optional) - If true return only user with login rights.

    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "role_users(): The argument must be an array") if (arguments.size < 1) or (!arguments[0].kind_of?(Array))

    all = Array.new
    arguments[0].each do |role|
      all += call_function('hiera_array', ["user_role_#{role}", []] )
    end
    # remove duplicates
    all.uniq!

    # check of login role
    if (arguments.size > 1) and (arguments[1] == true)
      allowed_users = Array.new
      allowed_roles = call_function('hiera_array', ['user_login_roles', []])
      allowed_roles.each do |role|
        allowed_users += call_function('hiera_array', ["user_role_#{role}", []] )
      end
      all = all & allowed_users
    end

    return all
  end
end
