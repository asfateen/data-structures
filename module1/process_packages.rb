# In this problem you will implement a program to simulate the processing of network packets.

# A struct representing a request with its arrival time and time required for processing.
Request = Struct.new(:arrived_at, :time_to_process)

# A struct representing a response with a flag indicating if the request was dropped and the start time of processing.
Response = Struct.new(:was_dropped, :started_at)

# A class representing a buffer that processes network packets.
class Buffer
  def initialize(size)
    @size = size
    @finish_time = []
  end

  # Processes a request and returns a response.
  def process(request)
    @finish_time.shift while !@finish_time.empty? && @finish_time.first <= request.arrived_at

    if @finish_time.size >= @size
      return Response.new(true, -1)
    end

    start_time = [@finish_time.empty? ? request.arrived_at : @finish_time.last, request.arrived_at].max

    @finish_time << start_time + request.time_to_process

    Response.new(false, start_time)
  end
end

# Processes a list of requests using a given buffer.
def process_requests(requests, buffer)
  responses = []
  requests.each do |request|
    responses << buffer.process(request)
  end
  responses
end


if __FILE__ == $0
  buffer_size, n_requests = gets.split.map(&:to_i)
  requests = []
  n_requests.times do
    arrived_at, time_to_process = gets.split.map(&:to_i)
    requests << Request.new(arrived_at, time_to_process)
  end

  buffer = Buffer.new(buffer_size)
  responses = process_requests(requests, buffer)

  responses.each do |response|
    puts response.was_dropped ? -1 : response.started_at
  end
end

