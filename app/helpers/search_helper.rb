module SearchHelper
  def render_sockets(item)
    output = String.new
    socket_string = item.sockets.split(//)
    links = 0
    sockets = 0
    socket_string.each do |s|
      unless s == ' '
        unless s == '-'
          sockets += 1
          output += "<div class=\"socket socket-#{sockets} socket-#{s}\"></div>"
        else
          links += 1
          if item.w == 1
            output += "<div class=\"link link-v link-#{links}\"></div>"
          else
            output += "<div class=\"link link-h link-#{links}\"></div>"
          end
        end
      else
        links += 1
      end
    end
   # (6-sockets).times do
    #  sockets += 1
    #  output += "<div class=\"socket socket-none socket-#{sockets}\"></div>"
    #end
    output.html_safe
  end
end
