module Administr8te::EmailingsHelper
  
  def test_connection(emailing)
    api_key = emailing.api_key
    list_key = emailing.list_key
    h = Hominid::API.new(api_key, {:secure => true, :timeout => 60})
    list = h.find_list_by_id(list_key)
  end

end
