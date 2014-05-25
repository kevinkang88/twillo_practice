require 'csv'
require 'twilio-ruby'

#################################################

class Student
  attr_reader :name, :phone_number
	def initialize(args = {})
		@name = args[:name]
		@phone_number = args[:phone_number]
	end 
end

#################################################

class PairGenerator 
	attr_reader :list

	def initialize
		file_name = 'data.txt'
		@people = Array.new
		CSV.foreach(file_name,:headers => true,header_converters: :symbol) do |row|
			@people << Student.new(row)
		end
	end

	def pair_up
		randomized_people = @people.shuffle 
		final = Hash.new 
		i = 0
	 	randomized_people.each_slice(2) do |pair|
			final[i = i+1] = pair  
		end
		final
	end
end

#################################################

class TextSender 
	def initialize 
		@account_sid = 'ACb2d18876409ec23f2409b9d3b5986e98' 
	 	@auth_token = 'ab303b1c15f3cafd62494e87c908def2'
	 	@client = Twilio::REST::Client.new @account_sid, @auth_token
	 	self.send_text
	end

	def send_text
	  pairgenerator = PairGenerator.new 
	  pair_hsh = pairgenerator.pair_up
	  pair_hsh.each do |k,v|
		  @client.account.sms.messages.create(
		  :from => '+18052887205',
		  :to => "+#{v.first.phone_number}",
		  :body => "you are in a pair_group - #{k} with #{v.last.name}")
		  @client.account.sms.messages.create(
		  :from => '+18052887205',
		  :to => "+#{v.last.phone_number}",
		  :body => "you are in a pair_group - #{k} with #{v.first.name}")
		end
	end
end

#################################################

text_sender = TextSender.new


