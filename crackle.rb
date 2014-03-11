def crackle
	(1..100).each do |x|
		case
			when (x % 3 == 0) && (x % 5 == 0)
				puts "CracklePop"
			when x % 3 == 0
				puts "Crackle"
			when x % 5 == 0
				puts "Pop"
			else
				puts "SnaggleFu. Wait until #{x} becomes.."
			end
	end
end

def crackle_two #doesn't work
	1.upto(100) do |x|
		if (x % 3 == 0)
			"CracklePop" if (x % 5 == 0) #doesn't work
			puts "Crackle"
		elsif (x % 5 == 0)
			puts "Pop"
		else 
			puts "SnaggleFu. Wait until #{x} becomes.."
		end
	end
end


class CracklePop
	
	def cracklepop(num)
		1.upto(num) do |x|
			if divide_by_three?(x) && divide_by_five?(x)
				puts "CracklePop"
			elsif divide_by_three?(x)
				puts "Crackle"
			elsif divide_by_five?(x)
				puts "Pop"
			else
				puts "#{x}"
			end
		end
	end

	def divide_by_three?(num)
		num % 3 == 0 ? true : false
	end

	def divide_by_five?(num)
		num % 5 == 0 ? true : false
	end
end