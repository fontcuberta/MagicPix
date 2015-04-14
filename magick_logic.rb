require 'pry'


class Auth
	def login?(user)
    if user.nil?
      return false
    else
      return true
    end
  end

  	def found?(user, password)
  		if user == "isaura" and password == "arya stark"
  			return true
  		end
  	end

end


class CountWord
	def execute(thisfile)
		thisfile[:tempfile].read.split.size
	end
end


