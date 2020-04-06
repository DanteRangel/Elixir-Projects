require 'net/http'
uri = URI('http://127.0.0.1:4000/api/t')
30.times do
  1000.times do 
    Thread.new do 
        Net::HTTP.post_form(uri, 'event' => 'sent_a_message', 'user_id' => 'xyz')
    end
    sleep(.5)
  end
end