class CracklePop
	
	def cracklepop(num=100)
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

rice = CracklePop.new.cracklepop